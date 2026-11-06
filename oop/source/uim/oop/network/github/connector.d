/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.network.github.connector;

import uim.oop;

import core.time : Duration, seconds;
import std.algorithm.comparison : min;
import std.algorithm.searching : all, any, canFind, endsWith;
import std.array : join, split;
import std.ascii : isAlphaNum;
import std.conv : to;
import std.string : format, representation, stripRight;
import std.uni : sicmp;
import std.uri : encodeComponent;

import vibe.data.json : parseJsonString;
import vibe.http.client : HTTPClientRequest, HTTPClientResponse, HTTPClientSettings, requestHTTP;
import vibe.http.common : httpMethodFromString;
import vibe.stream.operations : readAllUTF8;

mixin(ShowModule!());

@safe:

/// Thrown if a request fails or GitHub rejects it
class GithubConnectorException : UIMException {
  private int _status;

  this(string msg, int status = 0, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
    _status = status;
  }

  /// The HTTP status of the answer, or 0 if there is none
  int status() const {
    return _status;
  }
}

/// How mergePullRequest combines the commits
enum GithubMergeMethod {
  merge,
  squash,
  rebase
}

/// Selects pull requests and issues by state
enum GithubItemState {
  open,
  closed,
  all
}

/// What a transport has to send
struct GithubRequest {
  string method;
  string url;
  string[string] headers;
  string content;
}

/// What a transport received
struct GithubResponse {
  int status;
  string content;
}

/// Performs a request. Exchange it to use another HTTP client, or for tests.
alias GithubTransport = GithubResponse delegate(GithubRequest request) @safe;

/// Connector for the GitHub REST API.
///
/// Repositories are named "repository" or "owner/repository". The short form refers to the owner of
/// the connector, which is `owner` if set, otherwise the authenticated user.
///
/// All methods that exchange data with GitHub need an open connection and throw
/// GithubConnectorException if GitHub cannot be reached or rejects the request.
interface IGithubConnector : IConnector {
  /// Sends any request to the API, for endpoints without a method of their own
  /// Params:
  ///   method = GET, POST, PUT, PATCH or DELETE
  ///   path = the path below the base URL, with a leading "/" and with its query
  ///   payload = the JSON body, if the request has one
  /// Returns: The JSON answer, or an empty object if the answer has no body
  Json request(string method, string path, Json payload = Json.undefined);

  /// Retrieves the authenticated user
  /// Returns: A Json object containing the user
  Json getAuthenticatedUser();

  /// Retrieves the API limits of the current credentials. This does not count against them.
  /// Returns: A Json object containing the limits
  Json getRateLimit();

  /// Retrieves the repositories the authenticated user has access to.
  /// Without a token, retrieves the public repositories of the owner.
  /// Returns: A Json array containing the repositories
  Json getRepositories();

  /// Creates a new repository, in an organization if the name or the connector says so
  /// Returns: A Json object containing the new repository
  Json createRepository(string name, string description = "", bool isPrivate = true);

  /// Deletes a repository
  void deleteRepository(string name);

  /// Retrieves the details of a repository
  /// Returns: A Json object containing the repository details
  Json getRepository(string name);

  /// Sets the description and the visibility of a repository
  /// Returns: A Json object containing the updated repository
  Json updateRepository(string name, string description, bool isPrivate);

  /// Sets only the given fields of a repository
  /// Returns: A Json object containing the updated repository
  Json updateRepository(string name, Json fields);

  /// Retrieves the branches of a repository
  /// Returns: A Json array containing the branches
  Json getBranches(string repositoryName);

  /// Creates a new branch at the head of another one
  /// Params:
  ///   repositoryName = the repository
  ///   branchName = the new branch
  ///   fromBranch = the source branch, by default the default branch of the repository
  /// Returns: A Json object containing the new reference
  Json createBranch(string repositoryName, string branchName, string fromBranch = "");

  /// Deletes a branch
  void deleteBranch(string repositoryName, string branchName);

  /// Retrieves the details of a branch
  /// Returns: A Json object containing the branch details
  Json getBranch(string repositoryName, string branchName);

  /// Moves a branch to the head of another one
  /// Params:
  ///   repositoryName = the repository
  ///   branchName = the branch to move
  ///   fromBranch = the branch with the new head
  ///   force = also allows moves that are no fast-forward, which drop commits of the branch
  /// Returns: A Json object containing the updated reference
  Json updateBranch(string repositoryName, string branchName, string fromBranch, bool force = false);

  /// Merges a branch into another branch
  /// Returns: A Json object containing the merge commit, which is empty if there was nothing to merge
  Json mergeBranch(string repositoryName, string sourceBranch, string targetBranch);

  /// Compares two branches
  /// Returns: A Json object with "repository", "source", "target" and the GitHub fields "status", "ahead_by",
  /// "behind_by" and "total_commits", seen from the source branch
  Json getMergeStatus(string repositoryName, string sourceBranch, string targetBranch);

  /// Retrieves the pull requests of a repository
  /// Returns: A Json array containing the pull requests
  Json getPullRequests(string repositoryName, GithubItemState state = GithubItemState.open);

  /// Creates a new pull request
  /// Params:
  ///   repositoryName = the repository
  ///   title = the title
  ///   head = the branch with the changes, as "owner:branch" for a fork
  ///   baseBranch = the branch to merge into, by default the default branch of the repository
  ///   description = the text of the pull request
  ///   draft = creates a draft
  /// Returns: A Json object containing the new pull request, whose "number" identifies it
  Json createPullRequest(string repositoryName, string title, string head, string baseBranch = "",
    string description = "", bool draft = false);

  /// Closes a pull request without merging it. GitHub cannot delete pull requests.
  /// Returns: A Json object containing the pull request
  Json closePullRequest(string repositoryName, int pullRequestNumber);

  /// Reopens a closed pull request
  /// Returns: A Json object containing the pull request
  Json reopenPullRequest(string repositoryName, int pullRequestNumber);

  /// Retrieves the details of a pull request
  /// Returns: A Json object containing the pull request details
  Json getPullRequest(string repositoryName, int pullRequestNumber);

  /// Sets the title and, if given, the base branch of a pull request. GitHub cannot change the head.
  /// Returns: A Json object containing the pull request
  Json updatePullRequest(string repositoryName, int pullRequestNumber, string title, string baseBranch = "");

  /// Sets only the given fields of a pull request
  /// Returns: A Json object containing the pull request
  Json updatePullRequest(string repositoryName, int pullRequestNumber, Json fields);

  /// Merges a pull request
  /// Returns: A Json object with the fields "merged", "sha" and "message"
  Json mergePullRequest(string repositoryName, int pullRequestNumber,
    GithubMergeMethod mergeMethod = GithubMergeMethod.merge);

  /// Retrieves the merge status of a pull request
  /// Returns: A Json object with "number", "state", "merged" and "mergeable". The latter is null as long
  /// as GitHub computes it.
  Json getPullRequestMergeStatus(string repositoryName, int pullRequestNumber);

  /// Retrieves the changed files of a pull request
  /// Returns: A Json array containing the files
  Json getPullRequestFiles(string repositoryName, int pullRequestNumber);

  /// Retrieves the commits of a pull request
  /// Returns: A Json array containing the commits
  Json getPullRequestCommits(string repositoryName, int pullRequestNumber);

  /// Retrieves the comments of a pull request
  /// Returns: A Json array containing the comments
  Json getPullRequestComments(string repositoryName, int pullRequestNumber);

  /// Creates a comment on a pull request
  /// Returns: A Json object containing the new comment
  Json createPullRequestComment(string repositoryName, int pullRequestNumber, string comment);

  /// Deletes a comment on a pull request
  void deletePullRequestComment(string repositoryName, int pullRequestNumber, long commentId);

  /// Updates a comment on a pull request
  /// Returns: A Json object containing the comment
  Json updatePullRequestComment(string repositoryName, int pullRequestNumber, long commentId, string comment);

  /// Retrieves a specific comment on a pull request
  /// Returns: A Json object containing the comment details
  Json getPullRequestComment(string repositoryName, int pullRequestNumber, long commentId);

  /// Retrieves the issues of a repository, without its pull requests
  /// Returns: A Json array containing the issues
  Json getIssues(string repositoryName, GithubItemState state = GithubItemState.open);

  /// Retrieves the details of an issue
  /// Returns: A Json object containing the issue
  Json getIssue(string repositoryName, int issueNumber);

  /// Creates a new issue
  /// Returns: A Json object containing the new issue
  Json createIssue(string repositoryName, string title, string description = "");

  /// Sets only the given fields of an issue
  /// Returns: A Json object containing the issue
  Json updateIssue(string repositoryName, int issueNumber, Json fields);

  /// Closes an issue
  /// Returns: A Json object containing the issue
  Json closeIssue(string repositoryName, int issueNumber);

  /// Retrieves the latest commits of a repository
  /// Params:
  ///   repositoryName = the repository
  ///   branchName = the branch, by default the default branch of the repository
  ///   limit = the maximal number of commits, 0 for all of them
  /// Returns: A Json array containing the commits, newest first
  Json getCommits(string repositoryName, string branchName = "", size_t limit = 100);

  /// Retrieves a commit by its SHA, branch or tag
  /// Returns: A Json object containing the commit
  Json getCommit(string repositoryName, string reference);

  /// Retrieves the tags of a repository
  /// Returns: A Json array containing the tags
  Json getTags(string repositoryName);

  /// Retrieves the releases of a repository
  /// Returns: A Json array containing the releases
  Json getReleases(string repositoryName);

  /// Retrieves the latest published release of a repository
  /// Returns: A Json object containing the release
  Json getLatestRelease(string repositoryName);

  /// Creates a new release
  /// Returns: A Json object containing the new release
  Json createRelease(string repositoryName, string tagName, string title = "", string description = "",
    bool draft = false, bool prerelease = false);

  /// Retrieves a file, with its content in base64, or the entries of a directory
  /// Params:
  ///   repositoryName = the repository
  ///   path = the path in the repository
  ///   reference = a SHA, branch or tag, by default the default branch of the repository
  /// Returns: A Json object for a file, a Json array for a directory
  Json getContent(string repositoryName, string path, string reference = "");
}

/// Connects to the GitHub REST API, or to GitHub Enterprise by another base URL:
/// ---
/// auto github = new GithubConnector(token);
/// github.connect();
/// auto pullRequest = github.createPullRequest("uim-framework", "Add connector", "feature/connector");
/// github.mergePullRequest("uim-framework", pullRequest["number"].get!int, GithubMergeMethod.squash);
/// ---
///
/// Redirects are not followed, as they would hand the token to another host. Renamed repositories
/// therefore fail with HTTP 301. Use an https base URL for anything but a local system. Messages,
/// lastError and info never contain the token.
class GithubConnector : IGithubConnector {
  private enum size_t pageSize = 100;

  this() {
    this.initialize();
  }

  /// Params:
  ///   token = a personal access token or an app token
  this(string token) {
    this.initialize();
    _token = token;
  }

  this(Json config) {
    this.initialize(config);
  }

  /// Reads "token", "owner", "baseUrl", "apiVersion" and "userAgent" from the configuration
  bool initialize(Json config = Json(null)) {
    _token = config.getString("token", "");
    _owner = config.getString("owner", "");
    baseUrl(config.getString("baseUrl", "https://api.github.com"));
    _apiVersion = config.getString("apiVersion", "2022-11-28");
    _userAgent = config.getString("userAgent", "uim-framework");
    _transport = &requestWithVibe;
    return true;
  }

  // #region Properties
  // #region token
  protected string _token;
  /// Whether requests are authenticated
  bool hasToken() const {
    return _token.length > 0;
  }

  /// Sets the token (fluent interface). This closes the connection, as the user may change.
  auto token(string value) {
    disconnect();
    _token = value;
    return this;
  }
  // #endregion token

  // #region owner
  protected string _owner;
  /// The owner of repositories without one, by default the authenticated user
  string owner() const {
    return _owner.length > 0 ? _owner : _login;
  }

  auto owner(string value) {
    _owner = value;
    return this;
  }
  // #endregion owner

  // #region login
  protected string _login;
  /// The authenticated user. Empty without a connection or a token.
  string login() const {
    return _login;
  }
  // #endregion login

  // #region baseUrl
  protected string _baseUrl;
  /// The URL of the API, for GitHub Enterprise usually "https://host/api/v3"
  string baseUrl() const {
    return _baseUrl;
  }

  /// Sets the URL of the API (fluent interface). This closes the connection.
  auto baseUrl(string value) {
    disconnect();
    _baseUrl = value.stripRight("/");
    return this;
  }
  // #endregion baseUrl

  // #region apiVersion
  protected string _apiVersion;
  /// The value of the X-GitHub-Api-Version header
  string apiVersion() const {
    return _apiVersion;
  }

  auto apiVersion(string value) {
    _apiVersion = value;
    return this;
  }
  // #endregion apiVersion

  // #region userAgent
  protected string _userAgent;
  /// The User-Agent header, which GitHub requires
  string userAgent() const {
    return _userAgent;
  }

  auto userAgent(string value) {
    _userAgent = value;
    return this;
  }
  // #endregion userAgent

  // #region timeout
  protected Duration _timeout = 30.seconds;
  /// Limit for connecting and for each read
  Duration timeout() const {
    return _timeout;
  }

  auto timeout(Duration value) {
    _timeout = value;
    return this;
  }
  // #endregion timeout

  // #region maxResponseSize
  protected size_t _maxResponseSize = 16 * 1024 * 1024;
  /// Largest accepted answer in bytes, after decompression
  size_t maxResponseSize() const {
    return _maxResponseSize;
  }

  auto maxResponseSize(size_t value) {
    _maxResponseSize = value;
    return this;
  }
  // #endregion maxResponseSize

  // #region transport
  protected GithubTransport _transport;
  auto transport(GithubTransport value) {
    _transport = value;
    return this;
  }
  // #endregion transport
  // #endregion Properties

  private bool _connected = false;
  private string _lastError;
  private string _lastReceivedData;

  // #region IConnector
  string name() {
    return "github";
  }

  /// Checks the credentials and reads the authenticated user. Without a token, only checks that
  /// GitHub answers, which allows to read public data.
  void connect() {
    disconnect();
    clearLastError();
    if (hasToken) {
      auto user = parse("GET", "/user", fetch("GET", "/user"));
      _login = user.getString("login", "");
      if (_login.length == 0) {
        fail("GET /user returned no login.");
      }
    } else {
      fetch("GET", "/rate_limit");
    }
    _connected = true;
  }

  void disconnect() {
    _connected = false;
    _login = "";
    _lastReceivedData = "";
  }

  bool isConnected() {
    return _connected;
  }

  /// Sends a request, whose answer is available from receive.
  /// Params:
  ///   data = a JSON object with "path", and optionally "method" and "body":
  ///          `{"method": "POST", "path": "/markdown", "body": {"text": "Hello"}}`
  void send(string data) {
    requireConnected();

    Json message;
    try {
      message = parseJsonString(data);
    } catch (Exception e) {
      fail("Data to send is no JSON: " ~ e.msg);
    }
    if (message.type != Json.Type.object) {
      fail("Data to send must be a JSON object.");
    }

    immutable method = message.getString("method", "GET");
    immutable path = message.getString("path", "");
    checkRequest(method, path);
    fetch(method, path, message["body"]);
  }

  /// Returns: The body of the latest answer, also if it was an error
  string receive() {
    requireConnected();
    return _lastReceivedData;
  }

  /// Checks that GitHub answers, with or without a connection
  bool isAvailable() {
    try {
      return exchange("GET", "/rate_limit", Json.undefined).status < 500;
    } catch (GithubConnectorException e) {
      return false;
    }
  }

  bool ping() {
    return _connected && isAvailable();
  }

  string lastError() {
    return _lastError;
  }

  void clearLastError() {
    _lastError = "";
  }

  string status() {
    return _connected ? "connected" : "disconnected";
  }

  /// Returns: A Json object with the state of the connector. This asks GitHub for its availability.
  Json info() {
    return payloadOf(
      "name", name(),
      "status", status(),
      "available", isAvailable(),
      "connected", isConnected(),
      "baseUrl", _baseUrl,
      "owner", owner(),
      "login", _login,
      "authenticated", hasToken);
  }
  // #endregion IConnector

  // #region General
  Json request(string method, string path, Json payload = Json.undefined) {
    requireConnected();
    checkRequest(method, path);
    return parse(method, path, fetch(method, path, payload));
  }

  Json getAuthenticatedUser() {
    return request("GET", "/user");
  }

  Json getRateLimit() {
    return request("GET", "/rate_limit");
  }
  // #endregion General

  // #region Repositories
  Json getRepositories() {
    requireConnected();
    return pages(hasToken ? "/user/repos" : "/users/%s/repos".format(requireOwner()));
  }

  Json createRepository(string name, string description = "", bool isPrivate = true) {
    requireConnected();
    auto target = ownerAndName(name);
    immutable ownRepository = _login.length > 0 && sicmp(target[0], _login) == 0;
    return request("POST", ownRepository ? "/user/repos" : "/orgs/%s/repos".format(target[0]),
      payloadOf("name", target[1], "description", description, "private", isPrivate));
  }

  void deleteRepository(string name) {
    request("DELETE", repositoryPath(name));
  }

  Json getRepository(string name) {
    return request("GET", repositoryPath(name));
  }

  Json updateRepository(string name, string description, bool isPrivate) {
    return updateRepository(name, payloadOf("description", description, "private", isPrivate));
  }

  Json updateRepository(string name, Json fields) {
    return request("PATCH", repositoryPath(name), fields);
  }
  // #endregion Repositories

  // #region Branches
  Json getBranches(string repositoryName) {
    return pages(repositoryPath(repositoryName) ~ "/branches");
  }

  Json createBranch(string repositoryName, string branchName, string fromBranch = "") {
    immutable repository = repositoryPath(repositoryName);
    encodedPath(branchName, "Branch name");
    immutable source = fromBranch.length > 0 ? fromBranch : defaultBranch(repository);
    return request("POST", repository ~ "/git/refs",
      payloadOf("ref", "refs/heads/" ~ branchName, "sha", headOf(repository, source)));
  }

  void deleteBranch(string repositoryName, string branchName) {
    request("DELETE", "%s/git/refs/heads/%s".format(
        repositoryPath(repositoryName), encodedPath(branchName, "Branch name")));
  }

  Json getBranch(string repositoryName, string branchName) {
    return request("GET", "%s/branches/%s".format(
        repositoryPath(repositoryName), encodedPath(branchName, "Branch name")));
  }

  Json updateBranch(string repositoryName, string branchName, string fromBranch, bool force = false) {
    immutable repository = repositoryPath(repositoryName);
    immutable branch = encodedPath(branchName, "Branch name");
    return request("PATCH", "%s/git/refs/heads/%s".format(repository, branch),
      payloadOf("sha", headOf(repository, fromBranch), "force", force));
  }

  Json mergeBranch(string repositoryName, string sourceBranch, string targetBranch) {
    immutable repository = repositoryPath(repositoryName);
    encodedPath(sourceBranch, "Source branch");
    encodedPath(targetBranch, "Target branch");
    return request("POST", repository ~ "/merges", payloadOf("base", targetBranch, "head", sourceBranch));
  }

  Json getMergeStatus(string repositoryName, string sourceBranch, string targetBranch) {
    // The comparison holds all commits and files, so only its summary leaves this method
    auto comparison = request("GET", "%s/compare/%s...%s".format(repositoryPath(repositoryName),
        encodedPath(targetBranch, "Target branch"), encodedPath(sourceBranch, "Source branch")));
    return payloadOf(
      "repository", repositoryName,
      "source", sourceBranch,
      "target", targetBranch,
      "status", comparison.getString("status", ""),
      "ahead_by", comparison["ahead_by"].opt!long(0),
      "behind_by", comparison["behind_by"].opt!long(0),
      "total_commits", comparison["total_commits"].opt!long(0));
  }
  // #endregion Branches

  // #region Pull requests
  Json getPullRequests(string repositoryName, GithubItemState state = GithubItemState.open) {
    return pages("%s/pulls?state=%s".format(repositoryPath(repositoryName), state));
  }

  Json createPullRequest(string repositoryName, string title, string head, string baseBranch = "",
    string description = "", bool draft = false) {
    immutable repository = repositoryPath(repositoryName);
    if (title.length == 0) {
      fail("Pull request title must not be empty.");
    }
    if (head.length == 0) {
      fail("Head branch must not be empty.");
    }

    immutable base = baseBranch.length > 0 ? baseBranch : defaultBranch(repository);
    return request("POST", repository ~ "/pulls", payloadOf(
        "title", title, "head", head, "base", base, "body", description, "draft", draft));
  }

  Json closePullRequest(string repositoryName, int pullRequestNumber) {
    return updatePullRequest(repositoryName, pullRequestNumber, payloadOf("state", "closed"));
  }

  Json reopenPullRequest(string repositoryName, int pullRequestNumber) {
    return updatePullRequest(repositoryName, pullRequestNumber, payloadOf("state", "open"));
  }

  Json getPullRequest(string repositoryName, int pullRequestNumber) {
    return request("GET", pullRequestPath(repositoryName, pullRequestNumber));
  }

  Json updatePullRequest(string repositoryName, int pullRequestNumber, string title, string baseBranch = "") {
    if (title.length == 0) {
      fail("Pull request title must not be empty.");
    }

    auto fields = payloadOf("title", title);
    if (baseBranch.length > 0) {
      fields["base"] = baseBranch;
    }
    return updatePullRequest(repositoryName, pullRequestNumber, fields);
  }

  Json updatePullRequest(string repositoryName, int pullRequestNumber, Json fields) {
    return request("PATCH", pullRequestPath(repositoryName, pullRequestNumber), fields);
  }

  Json mergePullRequest(string repositoryName, int pullRequestNumber,
    GithubMergeMethod mergeMethod = GithubMergeMethod.merge) {
    return request("PUT", pullRequestPath(repositoryName, pullRequestNumber) ~ "/merge",
      payloadOf("merge_method", mergeMethod.to!string));
  }

  Json getPullRequestMergeStatus(string repositoryName, int pullRequestNumber) {
    auto pullRequest = getPullRequest(repositoryName, pullRequestNumber);
    auto mergeable = "mergeable" in pullRequest;
    return payloadOf(
      "number", pullRequestNumber,
      "state", pullRequest.getString("state", ""),
      "merged", pullRequest["merged"].opt!bool(false),
      "mergeable", mergeable !is null ? *mergeable : Json(null));
  }

  Json getPullRequestFiles(string repositoryName, int pullRequestNumber) {
    return pages(pullRequestPath(repositoryName, pullRequestNumber) ~ "/files");
  }

  Json getPullRequestCommits(string repositoryName, int pullRequestNumber) {
    return pages(pullRequestPath(repositoryName, pullRequestNumber) ~ "/commits");
  }
  // #endregion Pull requests

  // #region Pull request comments
  // The conversation of a pull request belongs to its issue, and GitHub addresses these comments by
  // repository alone. Their IDs exceed the range of an int.
  Json getPullRequestComments(string repositoryName, int pullRequestNumber) {
    return pages(issuePath(repositoryName, pullRequestNumber) ~ "/comments");
  }

  Json createPullRequestComment(string repositoryName, int pullRequestNumber, string comment) {
    immutable path = issuePath(repositoryName, pullRequestNumber) ~ "/comments";
    if (comment.length == 0) {
      fail("Comment must not be empty.");
    }
    return request("POST", path, payloadOf("body", comment));
  }

  void deletePullRequestComment(string repositoryName, int pullRequestNumber, long commentId) {
    request("DELETE", requireCommentPath(repositoryName, pullRequestNumber, commentId));
  }

  Json updatePullRequestComment(string repositoryName, int pullRequestNumber, long commentId, string comment) {
    if (comment.length == 0) {
      fail("Comment must not be empty.");
    }
    return request("PATCH", requireCommentPath(repositoryName, pullRequestNumber, commentId),
      payloadOf("body", comment));
  }

  Json getPullRequestComment(string repositoryName, int pullRequestNumber, long commentId) {
    auto comment = request("GET", commentPath(repositoryName, commentId));
    requireCommentOf(comment, pullRequestNumber);
    return comment;
  }
  // #endregion Pull request comments

  // #region Issues
  Json getIssues(string repositoryName, GithubItemState state = GithubItemState.open) {
    // GitHub lists pull requests as issues, too
    auto result = Json.emptyArray;
    foreach (item; pages("%s/issues?state=%s".format(repositoryPath(repositoryName), state))[]) {
      if (("pull_request" in item) is null) {
        result ~= item;
      }
    }
    return result;
  }

  Json getIssue(string repositoryName, int issueNumber) {
    return request("GET", issuePath(repositoryName, issueNumber));
  }

  Json createIssue(string repositoryName, string title, string description = "") {
    immutable repository = repositoryPath(repositoryName);
    if (title.length == 0) {
      fail("Issue title must not be empty.");
    }
    return request("POST", repository ~ "/issues", payloadOf("title", title, "body", description));
  }

  Json updateIssue(string repositoryName, int issueNumber, Json fields) {
    return request("PATCH", issuePath(repositoryName, issueNumber), fields);
  }

  Json closeIssue(string repositoryName, int issueNumber) {
    return updateIssue(repositoryName, issueNumber, payloadOf("state", "closed"));
  }
  // #endregion Issues

  // #region Commits, tags and releases
  Json getCommits(string repositoryName, string branchName = "", size_t limit = 100) {
    auto path = repositoryPath(repositoryName) ~ "/commits";
    if (branchName.length > 0) {
      path ~= "?sha=" ~ encodeComponent(branchName);
    }
    return pages(path, limit);
  }

  Json getCommit(string repositoryName, string reference) {
    return request("GET", "%s/commits/%s".format(
        repositoryPath(repositoryName), encodedPath(reference, "Reference")));
  }

  Json getTags(string repositoryName) {
    return pages(repositoryPath(repositoryName) ~ "/tags");
  }

  Json getReleases(string repositoryName) {
    return pages(repositoryPath(repositoryName) ~ "/releases");
  }

  Json getLatestRelease(string repositoryName) {
    return request("GET", repositoryPath(repositoryName) ~ "/releases/latest");
  }

  Json createRelease(string repositoryName, string tagName, string title = "", string description = "",
    bool draft = false, bool prerelease = false) {
    immutable repository = repositoryPath(repositoryName);
    if (tagName.length == 0) {
      fail("Tag name must not be empty.");
    }
    return request("POST", repository ~ "/releases", payloadOf(
        "tag_name", tagName, "name", title, "body", description, "draft", draft, "prerelease", prerelease));
  }

  Json getContent(string repositoryName, string path, string reference = "") {
    auto url = "%s/contents/%s".format(repositoryPath(repositoryName), encodedPath(path, "Path"));
    if (reference.length > 0) {
      url ~= "?ref=" ~ encodeComponent(reference);
    }
    return request("GET", url);
  }
  // #endregion Commits, tags and releases

  // #region Paths
  /// Validates a name, so that it stays one segment of a URL
  private void requireName(string value, string subject) {
    if (value.length == 0) {
      fail(subject ~ " must not be empty.");
    }
    if (value == "." || value == ".." || !value.all!(c => c.isAlphaNum || c == '-' || c == '_' || c == '.')) {
      fail("%s '%s' is invalid.".format(subject, value));
    }
  }

  private string requireOwner() {
    immutable result = owner();
    if (result.length == 0) {
      fail("Repository owner is not set.");
    }
    requireName(result, "Repository owner");
    return result;
  }

  /// Splits "repository" or "owner/repository"
  private string[2] ownerAndName(string repository) {
    if (repository.length == 0) {
      fail("Repository name must not be empty.");
    }

    auto parts = repository.split("/");
    if (parts.length > 2) {
      fail("Repository name '%s' is invalid.".format(repository));
    }
    if (parts.length == 1) {
      parts = requireOwner() ~ parts;
    }
    requireName(parts[0], "Repository owner");
    requireName(parts[1], "Repository name");
    return [parts[0], parts[1]];
  }

  private string repositoryPath(string repository) {
    requireConnected();
    auto target = ownerAndName(repository);
    return "/repos/%s/%s".format(target[0], target[1]);
  }

  /// Encodes a value for a URL. Its slashes stay, as branches and files may contain them.
  private string encodedPath(string value, string subject) {
    if (value.length == 0) {
      fail(subject ~ " must not be empty.");
    }

    auto segments = value.split("/");
    if (segments.any!(segment => segment.length == 0 || segment == "." || segment == "..")) {
      fail("%s '%s' is invalid.".format(subject, value));
    }

    string[] result;
    foreach (segment; segments) {
      result ~= encodeComponent(segment);
    }
    return result.join("/");
  }

  private string numberedPath(string repository, string collection, long number, string subject) {
    immutable path = repositoryPath(repository);
    if (number <= 0) {
      fail("%s %d is invalid.".format(subject, number));
    }
    return "%s/%s/%d".format(path, collection, number);
  }

  private string pullRequestPath(string repository, int number) {
    return numberedPath(repository, "pulls", number, "Pull request number");
  }

  private string issuePath(string repository, int number) {
    return numberedPath(repository, "issues", number, "Issue number");
  }

  private string commentPath(string repository, long commentId) {
    return numberedPath(repository, "issues/comments", commentId, "Comment ID");
  }
  // #endregion Paths

  // #region Lookups
  private string defaultBranch(string repository) {
    immutable result = request("GET", repository).getString("default_branch", "");
    if (result.length == 0) {
      fail("Repository has no default branch.");
    }
    return result;
  }

  private string headOf(string repository, string branchName) {
    auto reference = request("GET", "%s/git/ref/heads/%s".format(
        repository, encodedPath(branchName, "Source branch")));
    immutable result = reference.getString(["object", "sha"], "");
    if (result.length == 0) {
      fail("Branch '%s' has no head.".format(branchName));
    }
    return result;
  }

  private void requireCommentOf(Json comment, int pullRequestNumber) {
    if (!comment.getString("issue_url", "").endsWith("/issues/" ~ pullRequestNumber.to!string)) {
      fail("Pull request comment was not found.");
    }
  }

  /// GitHub ignores the pull request here, so this keeps a wrong number from changing a foreign comment
  private string requireCommentPath(string repository, int pullRequestNumber, long commentId) {
    immutable path = commentPath(repository, commentId);
    requireCommentOf(request("GET", path), pullRequestNumber);
    return path;
  }
  // #endregion Lookups

  // #region Requests
  private noreturn fail(string message, int status = 0) {
    _lastError = message;
    throw new GithubConnectorException(message, status);
  }

  private void requireConnected() {
    if (!_connected) {
      fail("GitHub connector is not connected.");
    }
  }

  /// The path follows the base URL directly, so without a leading "/" it could change the host
  private void checkRequest(string method, string path) {
    if (!["GET", "POST", "PUT", "PATCH", "DELETE"].canFind(method)) {
      fail("Method '%s' is not supported.".format(method));
    }
    if (path.length == 0 || path[0] != '/' || path.any!(c => c <= ' ' || c == 127)) {
      fail("Path '%s' is invalid.".format(path));
    }
  }

  private static Json payloadOf(Args...)(Args args) if (Args.length % 2 == 0) {
    auto result = Json.emptyObject;
    static foreach (i; 0 .. Args.length / 2) {
      result[args[2 * i]] = args[2 * i + 1];
    }
    return result;
  }

  private string[string] headers() {
    string[string] result = [
      "Accept": "application/vnd.github+json",
      "User-Agent": _userAgent,
      "X-GitHub-Api-Version": _apiVersion
    ];
    if (hasToken) {
      result["Authorization"] = "Bearer " ~ _token;
    }
    return result;
  }

  private GithubResponse exchange(string method, string path, Json payload) {
    GithubRequest message;
    message.method = method;
    message.url = _baseUrl ~ path;
    message.headers = headers();
    if (payload.type != Json.Type.undefined) {
      message.content = payload.toString();
    }

    GithubResponse response;
    try {
      response = _transport(message);
    } catch (Exception e) {
      fail("%s %s failed: %s".format(method, path, e.msg));
    }
    if (response.content.length > _maxResponseSize) {
      fail("Answer of %s %s is too large.".format(method, path));
    }
    return response;
  }

  /// Returns: The body of a successful answer
  private string fetch(string method, string path, Json payload = Json.undefined) {
    _lastReceivedData = "";
    auto response = exchange(method, path, payload);
    _lastReceivedData = response.content;
    if (response.status < 200 || response.status >= 300) {
      auto message = "%s %s returned HTTP %d".format(method, path, response.status);
      immutable detail = errorDetail(response.content);
      fail(detail.length > 0 ? message ~ ": " ~ detail : message, response.status);
    }
    return response.content;
  }

  private Json parse(string method, string path, string content) {
    if (content.length == 0) {
      return Json.emptyObject;
    }
    try {
      return parseJsonString(content);
    } catch (Exception e) {
      fail("Answer of %s %s is no JSON.".format(method, path));
    }
  }

  /// Reads the explanation from an error, including the fields of a failed validation
  private string errorDetail(string content) {
    Json error;
    try {
      error = parseJsonString(content);
    } catch (Exception e) {
      return ""; // For example the error page of a proxy
    }
    if (error.type != Json.Type.object) {
      return "";
    }

    string[] details;
    auto errors = error["errors"];
    if (errors.type == Json.Type.array) {
      foreach (item; errors[]) {
        if (item.type == Json.Type.string) {
          details ~= item.get!string;
        } else if (item.type == Json.Type.object) {
          immutable text = item.getString("message", "");
          details ~= text.length > 0 ? text
            : "%s %s".format(item.getString("field", ""), item.getString("code", ""));
        }
      }
    }

    immutable message = error.getString("message", "");
    return details.length > 0 ? "%s (%s)".format(message, details.join("; ")) : message;
  }

  /// Reads a list with all its pages. This counts pages instead of following the Link header,
  /// whose URLs would decide where the token goes.
  /// Params:
  ///   path = the list, may have a query
  ///   limit = the maximal number of items, 0 for all of them
  private Json pages(string path, size_t limit = 0) {
    immutable separator = path.canFind('?') ? "&" : "?";
    auto result = Json.emptyArray;
    for (size_t page = 1;; page++) {
      immutable perPage = limit > 0 ? min(pageSize, limit - result.length) : pageSize;
      auto items = request("GET", "%s%sper_page=%d&page=%d".format(path, separator, perPage, page));
      if (items.type != Json.Type.array) {
        fail("Answer of GET %s is no list.".format(path));
      }

      foreach (item; items[]) {
        result ~= item;
      }
      if (items.length < perPage || (limit > 0 && result.length >= limit)) {
        return result;
      }
    }
  }

  private GithubResponse requestWithVibe(GithubRequest message) {
    auto settings = new HTTPClientSettings;
    settings.connectTimeout = _timeout;
    settings.readTimeout = _timeout;

    GithubResponse result;
    requestHTTP(message.url, (scope HTTPClientRequest req) {
      req.method = httpMethodFromString(message.method);
      foreach (name, value; message.headers) {
        req.headers[name] = value;
      }
      if (message.content.length > 0) {
        req.writeBody(message.content.representation, "application/json");
      } else if (message.method != "GET") {
        req.headers["Content-Length"] = "0"; // GitHub requires it, for example for a PUT without a body
      }
    }, (scope HTTPClientResponse res) {
      result.status = res.statusCode;
      // The limit also holds for compressed bodies, where Content-Length says little
      result.content = res.bodyReader.readAllUTF8(false, _maxResponseSize);
    }, settings);
    return result;
  }
  // #endregion Requests
}

version (unittest) {
  import std.exception : assertThrown, collectException;

  private enum testBaseUrl = "https://github.test";

  /// A GitHub with fixed answers, which records its requests. Unknown requests return HTTP 404.
  private class FakeGithub {
    GithubResponse[string] answers;
    GithubRequest[] requests;

    void answer(string request, int status, string content = "") {
      answers[request] = GithubResponse(status, content);
    }

    GithubResponse handle(GithubRequest request) {
      requests ~= request;
      if (auto found = (request.method ~ " " ~ request.url[testBaseUrl.length .. $]) in answers) {
        return *found;
      }
      return GithubResponse(404, `{"message": "Not Found"}`);
    }

    /// The method and path of all requests
    string[] log() {
      string[] result;
      foreach (request; requests) {
        result ~= request.method ~ " " ~ request.url[testBaseUrl.length .. $];
      }
      return result;
    }

    Json lastPayload() {
      return parseJsonString(requests[$ - 1].content);
    }

    /// A connector, connected as "octo"
    GithubConnector connector() {
      answer("GET /user", 200, `{"login": "octo"}`);
      auto result = new GithubConnector("secret-token");
      result.baseUrl(testBaseUrl).transport(&handle);
      result.connect();
      requests = null;
      return result;
    }
  }

  /// A JSON array of objects with the IDs from first to last
  private string items(size_t first, size_t last) {
    string[] result;
    foreach (id; first .. last + 1) {
      result ~= `{"id": %d}`.format(id);
    }
    return "[" ~ result.join(",") ~ "]";
  }
}

/// Connecting checks the credentials and sends the required headers
unittest {
  auto github = new FakeGithub;
  github.answer("GET /user", 200, `{"login": "octo"}`);

  auto connector = new GithubConnector("secret-token");
  connector.baseUrl(testBaseUrl ~ "/").transport(&github.handle);
  assert(connector.baseUrl == testBaseUrl);
  assert(!connector.isConnected);
  assert(connector.status == "disconnected");

  connector.connect();
  assert(connector.isConnected);
  assert(connector.status == "connected");
  assert(connector.login == "octo");
  assert(connector.owner == "octo");

  auto headers = github.requests[0].headers;
  assert(headers["Authorization"] == "Bearer secret-token");
  assert(headers["Accept"] == "application/vnd.github+json");
  assert(headers["X-GitHub-Api-Version"] == "2022-11-28");
  assert(headers["User-Agent"] == "uim-framework");

  connector.disconnect();
  assert(!connector.isConnected);
  assert(connector.login == "");
}

/// Rejected credentials leave the connector disconnected
unittest {
  auto github = new FakeGithub;
  github.answer("GET /user", 401, `{"message": "Bad credentials"}`);

  auto connector = new GithubConnector("secret-token");
  connector.baseUrl(testBaseUrl).transport(&github.handle);

  auto error = collectException!GithubConnectorException(connector.connect());
  assert(error !is null);
  assert(error.status == 401);
  assert(error.msg == "GET /user returned HTTP 401: Bad credentials");
  assert(connector.lastError == error.msg);
  assert(!connector.isConnected);

  connector.clearLastError();
  assert(connector.lastError == "");
}

/// Without a token, public data is available from the owner
unittest {
  auto github = new FakeGithub;
  github.answer("GET /rate_limit", 200, "{}");
  github.answer("GET /users/octo/repos?per_page=100&page=1", 200, items(1, 2));

  auto connector = new GithubConnector(Json.emptyObject.set("owner", "octo").set("baseUrl", testBaseUrl));
  connector.transport(&github.handle);
  connector.connect();

  assert(connector.getRepositories().length == 2);
  assert(("Authorization" in github.requests[0].headers) is null);
}

/// Without a connection, nothing is sent
unittest {
  auto github = new FakeGithub;
  auto connector = new GithubConnector("secret-token");
  connector.baseUrl(testBaseUrl).transport(&github.handle);

  assertThrown!GithubConnectorException(connector.getRepositories());
  assertThrown!GithubConnectorException(connector.getRepository("uim"));
  assertThrown!GithubConnectorException(connector.createRepository("uim"));
  assertThrown!GithubConnectorException(connector.request("GET", "/user"));
  assertThrown!GithubConnectorException(connector.send(`{"path": "/user"}`));
  assertThrown!GithubConnectorException(connector.receive());
  assert(connector.lastError == "GitHub connector is not connected.");
  assert(github.requests.length == 0);
  assert(!connector.ping());
}

/// Changing the token or the URL closes the connection, as it was checked for the old ones
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();

  connector.token("other");
  assert(!connector.isConnected);
  assert(connector.login == "");
}

/// Availability follows the answers of GitHub and survives failures of the transport
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();

  github.answer("GET /rate_limit", 200, "{}");
  assert(connector.isAvailable);
  assert(connector.ping);

  github.answer("GET /rate_limit", 503);
  assert(!connector.isAvailable);

  GithubResponse broken(GithubRequest) {
    throw new Exception("connection refused");
  }

  connector.transport(&broken);
  assert(!connector.isAvailable);
  assert(!connector.ping);
  assert(connector.lastError == "GET /rate_limit failed: connection refused");
}

/// The token stays out of everything a connector reports
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /rate_limit", 200, "{}");

  auto info = connector.info();
  assert(info["name"] == "github");
  assert(info["login"] == "octo");
  assert(info["connected"] == true);
  assert(info["available"] == true);
  assert(info["authenticated"] == true);
  assert(!info.toString.canFind("secret-token"));

  auto error = collectException!GithubConnectorException(connector.getRepository("uim"));
  assert(!error.msg.canFind("secret-token"));
}

/// Short names use the owner, full names their own
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim", 200, `{"name": "uim"}`);
  github.answer("GET /repos/org/uim", 200, `{"name": "org-uim"}`);

  assert(connector.getRepository("uim")["name"] == "uim");
  assert(connector.getRepository("org/uim")["name"] == "org-uim");

  connector.owner("org");
  assert(connector.getRepository("uim")["name"] == "org-uim");
}

/// Names cannot leave their segment of the URL
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();

  foreach (name; ["", "..", "a/b/c", "/uim", "uim/", "../user", "a?b", "a#b", "a b", "a%2Fb"]) {
    assertThrown!GithubConnectorException(connector.getRepository(name));
  }
  foreach (branch; ["", "..", "a/../b", "/a", "a/", "a//b"]) {
    assertThrown!GithubConnectorException(connector.getBranch("uim", branch));
    assertThrown!GithubConnectorException(connector.deleteBranch("uim", branch));
  }
  assertThrown!GithubConnectorException(connector.getContent("uim", "../../user"));
  assertThrown!GithubConnectorException(connector.getPullRequest("uim", 0));
  assertThrown!GithubConnectorException(connector.getIssue("uim", -1));
  assertThrown!GithubConnectorException(connector.getPullRequestComment("uim", 1, 0));
  assert(github.requests.length == 0);
}

/// Raw requests cannot change the host or the head of the request
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();

  foreach (path; ["", "user", "@evil.test/user", ".evil.test/user", "/a b", "/a\r\nX-Evil: 1"]) {
    assertThrown!GithubConnectorException(connector.request("GET", path));
  }
  assertThrown!GithubConnectorException(connector.request("TRACE", "/user"));
  assertThrown!GithubConnectorException(connector.request("get", "/user"));
  assert(github.requests.length == 0);
}

/// Branches and files with special characters are encoded, their slashes stay
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/branches/feature/a%23b%3Fc", 200, `{"name": "x"}`);
  github.answer("GET /repos/octo/uim/contents/docs/a%20b.md?ref=feature%2Fx", 200, `{"type": "file"}`);

  assert(connector.getBranch("uim", "feature/a#b?c")["name"] == "x");
  assert(connector.getContent("uim", "docs/a b.md", "feature/x")["type"] == "file");
}

/// Lists are read page by page, and stop at the first page that is not full
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /user/repos?per_page=100&page=1", 200, items(1, 100));
  github.answer("GET /user/repos?per_page=100&page=2", 200, items(101, 200));
  github.answer("GET /user/repos?per_page=100&page=3", 200, items(201, 205));

  auto repositories = connector.getRepositories();
  assert(repositories.length == 205);
  assert(repositories[0]["id"] == 1);
  assert(repositories[204]["id"] == 205);
  assert(github.requests.length == 3);
}

/// A list that exactly fills its pages ends with an empty page
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/tags?per_page=100&page=1", 200, items(1, 100));
  github.answer("GET /repos/octo/uim/tags?per_page=100&page=2", 200, "[]");

  assert(connector.getTags("uim").length == 100);
}

/// A limit keeps large histories from being read completely
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/commits?per_page=30&page=1", 200, items(1, 30));
  assert(connector.getCommits("uim", "", 30).length == 30);
  assert(github.requests.length == 1);

  github.answer("GET /repos/octo/uim/commits?sha=feature%2Fx&per_page=100&page=1", 200, items(1, 100));
  github.answer("GET /repos/octo/uim/commits?sha=feature%2Fx&per_page=50&page=2", 200, items(101, 150));
  assert(connector.getCommits("uim", "feature/x", 150).length == 150);
}

/// A list that is no list is an error
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /user/repos?per_page=100&page=1", 200, "{}");
  assertThrown!GithubConnectorException(connector.getRepositories());

  github.answer("GET /user/repos?per_page=100&page=1", 200, "<html>");
  assertThrown!GithubConnectorException(connector.getRepositories());
}

/// Repositories go to the user or to an organization
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("POST /user/repos", 201, `{"name": "uim"}`);
  github.answer("POST /orgs/org/repos", 201, `{"name": "uim"}`);

  assert(connector.createRepository("uim", "A library")["name"] == "uim");
  auto payload = github.lastPayload;
  assert(payload["name"] == "uim");
  assert(payload["description"] == "A library");
  assert(payload["private"] == true);

  connector.createRepository("OCTO/uim");
  assert(github.log[$ - 1] == "POST /user/repos");

  connector.createRepository("org/uim", "", false);
  assert(github.log[$ - 1] == "POST /orgs/org/repos");
  assert(github.lastPayload["name"] == "uim");
  assert(github.lastPayload["private"] == false);
}

/// Updates need their values, so that a short call cannot wipe a repository's settings
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("PATCH /repos/octo/uim", 200, "{}");
  github.answer("DELETE /repos/octo/uim", 204);

  static assert(!__traits(compiles, connector.updateRepository("uim")));

  connector.updateRepository("uim", "New", false);
  assert(github.lastPayload["description"] == "New");
  assert(github.lastPayload["private"] == false);

  connector.updateRepository("uim", Json.emptyObject.set("has_wiki", false));
  assert(github.requests[$ - 1].content == `{"has_wiki":false}`);

  connector.deleteRepository("uim");
  assert(github.log[$ - 1] == "DELETE /repos/octo/uim");
}

/// New branches start at the head of the source, which defaults to the default branch
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim", 200, `{"default_branch": "trunk"}`);
  github.answer("GET /repos/octo/uim/git/ref/heads/trunk", 200, `{"object": {"sha": "abc"}}`);
  github.answer("GET /repos/octo/uim/git/ref/heads/dev/x", 200, `{"object": {"sha": "def"}}`);
  github.answer("POST /repos/octo/uim/git/refs", 201, `{"ref": "refs/heads/new"}`);

  assert(connector.createBranch("uim", "new")["ref"] == "refs/heads/new");
  assert(github.lastPayload["ref"] == "refs/heads/new");
  assert(github.lastPayload["sha"] == "abc");

  github.requests = null;
  connector.createBranch("uim", "new", "dev/x");
  assert(github.requests.length == 2);
  assert(github.lastPayload["sha"] == "def");

  assertThrown!GithubConnectorException(connector.createBranch("uim", "new", "missing"));
}

/// Moving and deleting branches
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/git/ref/heads/main", 200, `{"object": {"sha": "abc"}}`);
  github.answer("PATCH /repos/octo/uim/git/refs/heads/dev", 200, "{}");
  github.answer("DELETE /repos/octo/uim/git/refs/heads/dev", 204);

  connector.updateBranch("uim", "dev", "main");
  assert(github.lastPayload["sha"] == "abc");
  assert(github.lastPayload["force"] == false);

  connector.updateBranch("uim", "dev", "main", true);
  assert(github.lastPayload["force"] == true);

  connector.deleteBranch("uim", "dev");
  assert(github.log[$ - 1] == "DELETE /repos/octo/uim/git/refs/heads/dev");
}

/// Merging branches, with an empty result if there is nothing to merge
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("POST /repos/octo/uim/merges", 201, `{"sha": "abc"}`);

  assert(connector.mergeBranch("uim", "dev", "main")["sha"] == "abc");
  assert(github.lastPayload["base"] == "main");
  assert(github.lastPayload["head"] == "dev");

  github.answer("POST /repos/octo/uim/merges", 204);
  assert(connector.mergeBranch("uim", "dev", "main").length == 0);

  github.answer("POST /repos/octo/uim/merges", 409, `{"message": "Merge conflict"}`);
  auto error = collectException!GithubConnectorException(connector.mergeBranch("uim", "dev", "main"));
  assert(error.status == 409);
}

/// The merge status is a summary, seen from the source
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/compare/main...feature/x", 200,
    `{"status": "ahead", "ahead_by": 2, "behind_by": 0, "total_commits": 2, "files": [{}], "commits": [{}]}`);

  auto status = connector.getMergeStatus("uim", "feature/x", "main");
  assert(status["status"] == "ahead");
  assert(status["ahead_by"] == 2);
  assert(status["source"] == "feature/x");
  assert(status["target"] == "main");
  assert(("files" in status) is null);
}

/// Creating pull requests
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim", 200, `{"default_branch": "trunk"}`);
  github.answer("POST /repos/octo/uim/pulls", 201, `{"number": 7}`);

  assert(connector.createPullRequest("uim", "Title", "dev")["number"] == 7);
  auto payload = github.lastPayload;
  assert(payload["title"] == "Title");
  assert(payload["head"] == "dev");
  assert(payload["base"] == "trunk");
  assert(payload["draft"] == false);

  connector.createPullRequest("uim", "Title", "fork:dev", "main", "Text", true);
  payload = github.lastPayload;
  assert(payload["head"] == "fork:dev");
  assert(payload["base"] == "main");
  assert(payload["body"] == "Text");
  assert(payload["draft"] == true);

  assertThrown!GithubConnectorException(connector.createPullRequest("uim", "", "dev"));
  assertThrown!GithubConnectorException(connector.createPullRequest("uim", "Title", ""));
}

/// GitHub cannot delete pull requests, only close them. Their state is all that changes.
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/pulls?state=all&per_page=100&page=1", 200, items(1, 2));
  github.answer("PATCH /repos/octo/uim/pulls/7", 200, "{}");

  assert(connector.getPullRequests("uim", GithubItemState.all).length == 2);

  connector.closePullRequest("uim", 7);
  assert(github.requests[$ - 1].content == `{"state":"closed"}`);

  connector.reopenPullRequest("uim", 7);
  assert(github.requests[$ - 1].content == `{"state":"open"}`);

  connector.updatePullRequest("uim", 7, "Title");
  assert(github.requests[$ - 1].content == `{"title":"Title"}`);

  connector.updatePullRequest("uim", 7, "Title", "main");
  assert(github.lastPayload["base"] == "main");

  assertThrown!GithubConnectorException(connector.updatePullRequest("uim", 7, ""));
}

/// Merging pull requests
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("PUT /repos/octo/uim/pulls/7/merge", 200, `{"merged": true}`);
  github.answer("GET /repos/octo/uim/pulls/7", 200, `{"state": "open", "merged": false, "mergeable": null}`);
  github.answer("GET /repos/octo/uim/pulls/8", 200, `{"state": "closed", "merged": true, "mergeable": true}`);

  assert(connector.mergePullRequest("uim", 7)["merged"] == true);
  assert(github.lastPayload["merge_method"] == "merge");

  connector.mergePullRequest("uim", 7, GithubMergeMethod.squash);
  assert(github.lastPayload["merge_method"] == "squash");

  auto status = connector.getPullRequestMergeStatus("uim", 7);
  assert(status["number"] == 7);
  assert(status["state"] == "open");
  assert(status["merged"] == false);
  assert(status["mergeable"].type == Json.Type.null_);

  status = connector.getPullRequestMergeStatus("uim", 8);
  assert(status["merged"] == true);
  assert(status["mergeable"] == true);

  github.answer("PUT /repos/octo/uim/pulls/7/merge", 405, `{"message": "Pull Request is not mergeable"}`);
  auto error = collectException!GithubConnectorException(connector.mergePullRequest("uim", 7));
  assert(error.status == 405);
}

/// Comment IDs of GitHub exceed the range of an int
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  enum long commentId = 3_000_000_000;
  enum commentPath = "/repos/octo/uim/issues/comments/3000000000";
  enum comment = `{"id": 3000000000, "body": "Hi", "issue_url": "https://github.test/repos/octo/uim/issues/7"}`;

  github.answer("GET " ~ commentPath, 200, comment);
  github.answer("PATCH " ~ commentPath, 200, comment);
  github.answer("DELETE " ~ commentPath, 204);
  github.answer("POST /repos/octo/uim/issues/7/comments", 201, comment);
  github.answer("GET /repos/octo/uim/issues/7/comments?per_page=100&page=1", 200, "[" ~ comment ~ "]");

  assert(connector.createPullRequestComment("uim", 7, "Hi")["id"].get!long == commentId);
  assert(github.lastPayload["body"] == "Hi");
  assert(connector.getPullRequestComments("uim", 7).length == 1);
  assert(connector.getPullRequestComment("uim", 7, commentId)["body"] == "Hi");

  connector.updatePullRequestComment("uim", 7, commentId, "Changed");
  assert(github.lastPayload["body"] == "Changed");

  connector.deletePullRequestComment("uim", 7, commentId);
  assert(github.log[$ - 1] == "DELETE " ~ commentPath);

  assertThrown!GithubConnectorException(connector.createPullRequestComment("uim", 7, ""));
  assertThrown!GithubConnectorException(connector.updatePullRequestComment("uim", 7, commentId, ""));
}

/// A comment of another pull request is neither read nor changed, also if the numbers only start alike
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/issues/comments/5", 200,
    `{"id": 5, "issue_url": "https://github.test/repos/octo/uim/issues/17"}`);

  assertThrown!GithubConnectorException(connector.getPullRequestComment("uim", 7, 5));
  assertThrown!GithubConnectorException(connector.updatePullRequestComment("uim", 7, 5, "Changed"));
  assertThrown!GithubConnectorException(connector.deletePullRequestComment("uim", 7, 5));
  assert(connector.lastError == "Pull request comment was not found.");
  assert(!github.log.canFind!(entry => entry.canFind("PATCH") || entry.canFind("DELETE")));
}

/// Issues leave out the pull requests that GitHub lists among them
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/issues?state=open&per_page=100&page=1", 200,
    `[{"number": 1}, {"number": 2, "pull_request": {}}, {"number": 3}]`);
  github.answer("POST /repos/octo/uim/issues", 201, `{"number": 4}`);
  github.answer("GET /repos/octo/uim/issues/4", 200, `{"number": 4}`);
  github.answer("PATCH /repos/octo/uim/issues/4", 200, "{}");

  auto issues = connector.getIssues("uim");
  assert(issues.length == 2);
  assert(issues[1]["number"] == 3);

  assert(connector.createIssue("uim", "Bug", "Text")["number"] == 4);
  assert(github.lastPayload["title"] == "Bug");
  assert(connector.getIssue("uim", 4)["number"] == 4);

  connector.closeIssue("uim", 4);
  assert(github.lastPayload["state"] == "closed");

  assertThrown!GithubConnectorException(connector.createIssue("uim", ""));
}

/// Releases
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /repos/octo/uim/releases?per_page=100&page=1", 200, items(1, 3));
  github.answer("GET /repos/octo/uim/releases/latest", 200, `{"tag_name": "v1"}`);
  github.answer("POST /repos/octo/uim/releases", 201, `{"id": 1}`);

  assert(connector.getReleases("uim").length == 3);
  assert(connector.getLatestRelease("uim")["tag_name"] == "v1");

  connector.createRelease("uim", "v2", "Second", "Text", true);
  assert(github.lastPayload["tag_name"] == "v2");
  assert(github.lastPayload["draft"] == true);
  assert(github.lastPayload["prerelease"] == false);

  assertThrown!GithubConnectorException(connector.createRelease("uim", ""));
}

/// Errors carry the explanation of GitHub, including failed validations
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("POST /user/repos", 422, `{"message": "Validation Failed", "errors": [
    {"resource": "Repository", "field": "name", "code": "custom", "message": "name already exists"},
    {"resource": "Repository", "field": "title", "code": "missing"},
    "plain"]}`);
  github.answer("GET /repos/octo/proxy", 502, "<html>Bad Gateway</html>");
  github.answer("GET /repos/octo/old", 301, `{"message": "Moved Permanently", "url": "https://evil.test"}`);

  auto error = collectException!GithubConnectorException(connector.createRepository("octo/uim"));
  assert(error.status == 422);
  assert(error.msg == "POST /user/repos returned HTTP 422: Validation Failed (name already exists; title missing; plain)");

  error = collectException!GithubConnectorException(connector.getRepository("proxy"));
  assert(error.msg == "GET /repos/octo/proxy returned HTTP 502");

  // Redirects are errors, nothing follows them
  github.requests = null;
  error = collectException!GithubConnectorException(connector.getRepository("old"));
  assert(error.status == 301);
  assert(github.requests.length == 1);
}

/// Oversized answers are refused, also from other transports
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector().maxResponseSize(4);
  github.answer("GET /repos/octo/uim", 200, `{"name": "uim"}`);

  assertThrown!GithubConnectorException(connector.getRepository("uim"));
}

/// send and receive give access to any endpoint
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /zen", 200, "Keep it logically awesome.");
  github.answer("POST /markdown", 200, "<p>Hi</p>");
  github.answer("GET /gone", 410, `{"message": "Gone"}`);

  connector.send(`{"path": "/zen"}`);
  assert(connector.receive() == "Keep it logically awesome.");

  connector.send(`{"method": "POST", "path": "/markdown", "body": {"text": "Hi"}}`);
  assert(connector.receive() == "<p>Hi</p>");
  assert(github.lastPayload["text"] == "Hi");

  assertThrown!GithubConnectorException(connector.send(`{"path": "/gone"}`));
  assert(connector.receive() == `{"message": "Gone"}`);

  immutable sent = github.requests.length;
  assertThrown!GithubConnectorException(connector.send("no json"));
  assertThrown!GithubConnectorException(connector.send("[]"));
  assertThrown!GithubConnectorException(connector.send("{}"));
  assertThrown!GithubConnectorException(connector.send(`{"path": "@evil.test/"}`));
  assert(github.requests.length == sent);
}

/// The other methods address the expected endpoints
unittest {
  auto github = new FakeGithub;
  auto connector = github.connector();
  github.answer("GET /user", 200, `{"login": "octo"}`);
  github.answer("GET /rate_limit", 200, `{"rate": {}}`);
  github.answer("GET /repos/octo/uim/branches?per_page=100&page=1", 200, "[]");
  github.answer("GET /repos/octo/uim/pulls/7/files?per_page=100&page=1", 200, items(1, 1));
  github.answer("GET /repos/octo/uim/pulls/7/commits?per_page=100&page=1", 200, items(1, 2));
  github.answer("GET /repos/octo/uim/commits/abc", 200, `{"sha": "abc"}`);

  assert(connector.getAuthenticatedUser()["login"] == "octo");
  assert("rate" in connector.getRateLimit());
  assert(connector.getBranches("uim").length == 0);
  assert(connector.getPullRequestFiles("uim", 7).length == 1);
  assert(connector.getPullRequestCommits("uim", 7).length == 2);
  assert(connector.getCommit("uim", "abc")["sha"] == "abc");
}
