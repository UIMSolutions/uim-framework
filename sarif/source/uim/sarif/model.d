/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sarif.model;

import std.conv : to;
import std.json;

import uim.core;

mixin(ShowModule!());

@safe:

private bool sarifHasKey(const Json value, string key) {
	return value.hasKey(key);
}

private string sarifString(const Json value, string key, string fallback = "") {
	if (!value.hasKey(key))
		return fallback;

	auto node = value[key];
	return node.isString ? node.getString : fallback;
}

private size_t sarifSizeT(const Json value, string key, size_t fallback = 0) {
	if (!value.hasKey(key))
		return fallback;

	auto node = value[key];
	if (node.isInteger) {
		return node.to!size_t;
	}
	// if (node.type == JSONType.uinteger) {
	// 	return node.uinteger.to!size_t;
	// }

	return fallback;
}

private Json sarifTextNode(string value) {
	return Json(value);
}

private Json sarifSizeNode(size_t value) {
	return Json(value);
}

private Json[] sarifArrayOrEmpty(const Json value, string key) {
	if (!sarifHasKey(value, key)) {
		return null;
	}

	auto node = value[key];
	if (!node.isArray)
		return null;

	return node.toArray;
}

private Json sarifObjectOrEmpty(const Json value, string key) {
	Json node = Json(null);
	if (!sarifHasKey(value, key)) {
		return node;
	}

	auto child = value[key];
	if (child.isObject) {
		return child;
	}

	return node;
}

private bool sarifMessageHasContent(const ref SarifMessage message) {
	return message.text.length || message.markdown.length || message.id.length;
}

private bool sarifArtifactLocationHasContent(const ref SarifArtifactLocation location) {
	return location.uri.length || location.uriBaseId.length || location.description.length;
}

private bool sarifRegionHasContent(const ref SarifRegion region) {
	return region.startLine || region.startColumn || region.endLine || region.endColumn;
}

private bool sarifPhysicalLocationHasContent(const ref SarifPhysicalLocation location) {
	return sarifArtifactLocationHasContent(location.artifactLocation) ||
		sarifRegionHasContent(location.region);
}

private bool sarifToolComponentHasContent(const ref SarifToolComponent component) {
	return component.name.length ||
		component.version_.length ||
		component.semanticVersion.length ||
		component.downloadUri.length ||
		component.informationUri.length ||
		component.fullName.length ||
		component.language.length ||
		component.rules.length;
}

enum SarifVersion {
	unknown,
	v2_1_0
}

string sarifVersionToString(SarifVersion sarifVersion) {
	final switch (sarifVersion) {
		case SarifVersion.v2_1_0:
			return "2.1.0";
		case SarifVersion.unknown:
			return "unknown";
	}
}

SarifVersion sarifVersionFromString(string value) {
	if (value == "2.1.0") {
		return SarifVersion.v2_1_0;
	}

	return SarifVersion.unknown;
}

struct SarifMessage {
	string text;
	string markdown;
	string id;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (text.length) {
			node["text"] = Json(text);
		}
		if (markdown.length) {
			node["markdown"] = Json(markdown);
		}
		if (id.length) {
			node["id"] = Json(id);
		}
		return node;
	}

	@trusted static SarifMessage fromJson(const Json value) {
		return SarifMessage(
			sarifString(value, "text"),
			sarifString(value, "markdown"),
			sarifString(value, "id")
		);
	}
}

struct SarifArtifactLocation {
	string uri;
	string uriBaseId;
	string description;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (uri.length) {
			node["uri"] = Json(uri);
		}
		if (uriBaseId.length) {
			node["uriBaseId"] = Json(uriBaseId);
		}
		if (description.length) {
			node["description"] = SarifMessage(description).toJson();
		}
		return node;
	}

	@trusted static SarifArtifactLocation fromJson(const Json value) {
		return SarifArtifactLocation(
			sarifString(value, "uri"),
			sarifString(value, "uriBaseId"),
			sarifString(sarifObjectOrEmpty(value, "description"), "text")
		);
	}
}

struct SarifRegion {
	size_t startLine;
	size_t startColumn;
	size_t endLine;
	size_t endColumn;

	@trusted Json toJson() const {
		Json node = Json.emptyObject;
		if (startLine) {
			node["startLine"] = sarifSizeNode(startLine);
		}
		if (startColumn) {
			node["startColumn"] = sarifSizeNode(startColumn);
		}
		if (endLine) {
			node["endLine"] = sarifSizeNode(endLine);
		}
		if (endColumn) {
			node["endColumn"] = sarifSizeNode(endColumn);
		}
		return node;
	}

	@trusted static SarifRegion fromJson(const Json value) {
		return SarifRegion(
			sarifSizeT(value, "startLine"),
			sarifSizeT(value, "startColumn"),
			sarifSizeT(value, "endLine"),
			sarifSizeT(value, "endColumn")
		);
	}
}

struct SarifPhysicalLocation {
	SarifArtifactLocation artifactLocation;
	SarifRegion region;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (!artifactLocation.uri.length && !artifactLocation.uriBaseId.length && !artifactLocation.description.length) {
			return node;
		}
		node["artifactLocation"] = artifactLocation.toJson();
		if (region.startLine || region.startColumn || region.endLine || region.endColumn) {
			node["region"] = region.toJson();
		}
		return node;
	}

	@trusted static SarifPhysicalLocation fromJson(const Json value) {
		return SarifPhysicalLocation(
			SarifArtifactLocation.fromJson(sarifObjectOrEmpty(value, "artifactLocation")),
			SarifRegion.fromJson(sarifObjectOrEmpty(value, "region"))
		);
	}
}

struct SarifLocation {
	string id;
	string message;
	SarifPhysicalLocation physicalLocation;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (id.length) {
			node["id"] = Json(id);
		}
		if (message.length) {
			node["message"] = SarifMessage(message).toJson();
		}
		if (sarifPhysicalLocationHasContent(physicalLocation)) {
			node["physicalLocation"] = physicalLocation.toJson();
		}
		return node;
	}

	@trusted static SarifLocation fromJson(const Json value) {
		return SarifLocation(
			sarifString(value, "id"),
			sarifString(sarifObjectOrEmpty(value, "message"), "text"),
			SarifPhysicalLocation.fromJson(sarifObjectOrEmpty(value, "physicalLocation"))
		);
	}
}

struct SarifReportingDescriptor {
	string id;
	string name;
	SarifMessage shortDescription;
	SarifMessage fullDescription;
	string helpUri;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (id.length) {
			node["id"] = Json(id);
		}
		if (name.length) {
			node["name"] = Json(name);
		}
		if (sarifMessageHasContent(shortDescription)) {
			node["shortDescription"] = shortDescription.toJson();
		}
		if (sarifMessageHasContent(fullDescription)) {
			node["fullDescription"] = fullDescription.toJson();
		}
		if (helpUri.length) {
			node["helpUri"] = Json(helpUri);
		}
		return node;
	}

	@trusted static SarifReportingDescriptor fromJson(const Json value) {
		return SarifReportingDescriptor(
			sarifString(value, "id"),
			sarifString(value, "name"),
			SarifMessage.fromJson(sarifObjectOrEmpty(value, "shortDescription")),
			SarifMessage.fromJson(sarifObjectOrEmpty(value, "fullDescription")),
			sarifString(value, "helpUri")
		);
	}
}

struct SarifToolComponent {
	string name;
	string version_;
	string semanticVersion;
	string downloadUri;
	string informationUri;
	string fullName;
	string language;
	SarifReportingDescriptor[] rules;

	@trusted Json toJson() const {
		Json node = Json.emptyObject;
		if (name.length) {
			node["name"] = Json(name);
		}
		if (version_.length) {
			node["version"] = Json(version_);
		}
		if (semanticVersion.length) {
			node["semanticVersion"] = Json(semanticVersion);
		}
		if (downloadUri.length) {
			node["downloadUri"] = Json(downloadUri);
		}
		if (informationUri.length) {
			node["informationUri"] = Json(informationUri);
		}
		if (fullName.length) {
			node["fullName"] = Json(fullName);
		}
		if (language.length) {
			node["language"] = Json(language);
		}
		if (rules.length) {
			Json[] rulesArray;
			foreach (rule; rules) {
				rulesArray ~= rule.toJson();
			}
			node["rules"] = Json(rulesArray);
		}
		return node;
	}

	@trusted static SarifToolComponent fromJson(const Json value) {
		SarifReportingDescriptor[] parsedRules;
		foreach (ruleValue; sarifArrayOrEmpty(value, "rules")) {
			parsedRules ~= SarifReportingDescriptor.fromJson(ruleValue);
		}

		return SarifToolComponent(
			sarifString(value, "name"),
			sarifString(value, "version"),
			sarifString(value, "semanticVersion"),
			sarifString(value, "downloadUri"),
			sarifString(value, "informationUri"),
			sarifString(value, "fullName"),
			sarifString(value, "language"),
			parsedRules
		);
	}
}

struct SarifTool {
	SarifToolComponent driver;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (sarifToolComponentHasContent(driver)) {
			node["driver"] = driver.toJson();
		}
		return node;
	}

	@trusted static SarifTool fromJson(const Json value) {
		return SarifTool(SarifToolComponent.fromJson(sarifObjectOrEmpty(value, "driver")));
	}
}

struct SarifResult {
	string ruleId;
	string level;
	string kind;
	SarifMessage message;
	SarifLocation[] locations;

	@trusted Json toJson() const {
		Json node  = Json.emptyObject;
		if (ruleId.length) {
			node["ruleId"] = Json(ruleId);
		}
		if (level.length) {
			node["level"] = Json(level);
		}
		if (kind.length) {
			node["kind"] = Json(kind);
		}
		if (message.text.length || message.markdown.length || message.id.length) {
			node["message"] = message.toJson();
		}
		if (locations.length) {
			Json[] locationsArray;
			foreach (location; locations) {
				locationsArray ~= location.toJson();
			}
			node["locations"] = Json(locationsArray);
		}
		return node;
	}

	@trusted static SarifResult fromJson(const Json value) {
		SarifLocation[] parsedLocations;
		foreach (locationValue; sarifArrayOrEmpty(value, "locations")) {
			parsedLocations ~= SarifLocation.fromJson(locationValue);
		}

		return SarifResult(
			sarifString(value, "ruleId"),
			sarifString(value, "level"),
			sarifString(value, "kind"),
			SarifMessage.fromJson(sarifObjectOrEmpty(value, "message")),
			parsedLocations
		);
	}
}

struct SarifRun {
	SarifTool tool;
	SarifResult[] results;

	@trusted Json toJson() const {
		Json node = Json.emptyObject;
		if (sarifToolComponentHasContent(tool.driver)) {
			node["tool"] = tool.toJson();
		}
		if (results.length) {
			Json[] resultsArray;
			foreach (result; results) {
				resultsArray ~= result.toJson();
			}
			node["results"] = Json(resultsArray);
		}
		return node;
	}

	@trusted static SarifRun fromJson(const Json value) {
		SarifResult[] parsedResults;
		foreach (resultValue; sarifArrayOrEmpty(value, "results")) {
			parsedResults ~= SarifResult.fromJson(resultValue);
		}

		return SarifRun(
			SarifTool.fromJson(sarifObjectOrEmpty(value, "tool")),
			parsedResults
		);
	}
}

struct SarifLog {
	SarifVersion sarifVersion = SarifVersion.v2_1_0;
	SarifRun[] runs;

	@trusted Json toJson() const {
		Json node = Json.emptyObject;
		node["version"] = Json(sarifVersionToString(sarifVersion));
		if (runs.length) {
			Json[] runsArray;
			foreach (run; runs) {
				runsArray ~= run.toJson();
			}
			node["runs"] = Json(runsArray);
		}
		return node;
	}

	@trusted string toJsonString() const {
		return toJson().toString();
	}

	@trusted static SarifLog fromJson(const Json value) {
		SarifRun[] parsedRuns;
		foreach (runValue; sarifArrayOrEmpty(value, "runs")) {
			parsedRuns ~= SarifRun.fromJson(runValue);
		}
		return SarifLog(
			sarifVersionFromString(sarifString(value, "version", "2.1.0")),
			parsedRuns
		);
	}

	@trusted static SarifLog fromJsonString(string payload) {
		return fromJson(parseJsonString(payload));
	}

	bool isValid() const pure nothrow @safe {
		return sarifVersion == SarifVersion.v2_1_0 && runs.length > 0;
	}
}

unittest {
	auto log = SarifLog(
		SarifVersion.v2_1_0,
		[
			SarifRun(
				SarifTool(
					SarifToolComponent(
						"sarif-tool",
						"1.0.0",
						"1.0.0",
						"https://example.com/tool.zip",
						"https://example.com",
						"SARIF Tool",
						"en",
						[
							SarifReportingDescriptor(
								"RULE001",
								"example-rule",
								SarifMessage("Short description", "Short description", ""),
								SarifMessage("Full description", "Full description", ""),
								"https://example.com/help"
							)
						]
					)
				),
				[
					SarifResult(
						"RULE001",
						"warning",
						"fail",
						SarifMessage("Hello from SARIF"),
						[
							SarifLocation(
								"loc-1",
								"file hit",
								SarifPhysicalLocation(
									SarifArtifactLocation("file:///tmp/test.d", "", ""),
									SarifRegion(12, 3, 12, 15)
								)
							)
						]
					)
				]
			)
		]
	);

	auto payload = log.toJsonString();
	auto decoded = SarifLog.fromJsonString(payload);

	assert(decoded.sarifVersion == SarifVersion.v2_1_0);
	assert(decoded.runs.length == 1);
	assert(decoded.runs[0].results.length == 1);
	assert(decoded.runs[0].results[0].message.text == "Hello from SARIF");
	assert(decoded.isValid());
}
