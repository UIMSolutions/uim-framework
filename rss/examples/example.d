/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module rss.examples.example;

import uim.rss;
import std.stdio;
import std.datetime;

void main() {
    writeln("=== UIM RSS Library Example ===\n");

    // Example 1: Creating a simple RSS feed
    writeln("1. Creating a basic RSS feed:\n");
    
    auto feed = new DRSSFeed(
        "My Tech Blog",
        "https://example.com/blog",
        "A blog about technology and programming"
    );
    
    feed.language = "en-us";
    feed.copyright = "Copyright 2026 Example Corp";
    feed.managingEditor = "editor@example.com (John Editor)";
    feed.webMaster = "webmaster@example.com (Jane Webmaster)";
    feed.pubDate = Clock.currTime(UTC());
    feed.lastBuildDate = Clock.currTime(UTC());
    feed.ttl = 60; // Update every 60 minutes
    
    writeln("  Feed created: ", feed.title);
    writeln("  Link: ", feed.link);
    writeln();

    // Example 2: Adding categories to the feed
    writeln("2. Adding categories to the feed:\n");
    
    feed.addCategory("Technology");
    feed.addCategory("Programming", "https://example.com/categories");
    feed.addCategory("Web Development");
    
    writeln("  Added ", feed.categories.length, " categories");
    writeln();

    // Example 3: Adding a channel image
    writeln("3. Adding channel image:\n");
    
    auto image = new DRSSImage(
        "https://example.com/logo.png",
        "My Tech Blog",
        "https://example.com/blog"
    );
    image.width = 144;
    image.height = 144;
    image.description = "My Tech Blog Logo";
    feed.image = image;
    
    writeln("  Image URL: ", image.url);
    writeln();

    // Example 4: Creating RSS items (blog posts)
    writeln("4. Creating RSS items:\n");
    
    // First item
    auto item1 = new DRSSItem();
    item1.title = "Getting Started with D Programming";
    item1.link = "https://example.com/blog/getting-started-d";
    item1.description = "Learn the basics of D programming language and why it's great for system programming.";
    item1.author = "john@example.com (John Doe)";
    item1.guid = "https://example.com/blog/getting-started-d";
    item1.pubDate = Clock.currTime(UTC()) - dur!"hours"(24);
    item1.addCategory("Programming");
    item1.addCategory("D Language", "https://example.com/tags");
    feed.addItem(item1);
    
    writeln("  Created item: ", item1.title);
    
    // Second item with enclosure (podcast/video)
    auto item2 = new DRSSItem();
    item2.title = "Introduction to Web APIs";
    item2.link = "https://example.com/blog/web-apis-intro";
    item2.description = "A comprehensive guide to building RESTful APIs with modern web frameworks.";
    item2.author = "jane@example.com (Jane Smith)";
    item2.guid = "https://example.com/blog/web-apis-intro";
    item2.pubDate = Clock.currTime(UTC()) - dur!"hours"(48);
    
    auto enclosure = new DRSSEnclosure(
        "https://example.com/media/web-apis-intro.mp3",
        12345678, // File size in bytes
        "audio/mpeg"
    );
    item2.enclosure = enclosure;
    item2.addCategory("Web Development");
    item2.addCategory("APIs");
    feed.addItem(item2);
    
    writeln("  Created item with enclosure: ", item2.title);
    
    // Third item
    auto item3 = new DRSSItem();
    item3.title = "Building Scalable Applications";
    item3.link = "https://example.com/blog/scalable-apps";
    item3.description = "Best practices for building applications that scale to millions of users.";
    item3.author = "bob@example.com (Bob Builder)";
    item3.guid = "https://example.com/blog/scalable-apps";
    item3.guidIsPermaLink = true;
    item3.pubDate = Clock.currTime(UTC()) - dur!"hours"(72);
    item3.comments = "https://example.com/blog/scalable-apps#comments";
    item3.addCategory("Architecture");
    item3.addCategory("Scalability");
    feed.addItem(item3);
    
    writeln("  Created item: ", item3.title);
    writeln();

    // Example 5: Generating RSS XML
    writeln("5. Generated RSS 2.0 XML:\n");
    writeln("================================================================");
    writeln(feed.toXML());
    writeln("================================================================\n");

    // Example 6: Creating a podcast feed
    writeln("6. Creating a podcast RSS feed:\n");
    
    auto podcast = new DRSSFeed(
        "Tech Talk Podcast",
        "https://example.com/podcast",
        "Weekly discussions about technology trends"
    );
    
    podcast.language = "en-us";
    podcast.copyright = "© 2026 Tech Talk Inc";
    podcast.ttl = 1440; // Update daily
    podcast.addCategory("Technology");
    podcast.addCategory("Podcast");
    
    // Podcast episode 1
    auto episode1 = new DRSSItem();
    episode1.title = "Episode 1: AI and Machine Learning";
    episode1.link = "https://example.com/podcast/episode-1";
    episode1.description = "In this episode, we discuss the latest trends in AI and machine learning.";
    episode1.pubDate = Clock.currTime(UTC()) - dur!"days"(7);
    episode1.guid = "https://example.com/podcast/episode-1";
    
    auto audioFile1 = new DRSSEnclosure(
        "https://example.com/podcast/episode-1.mp3",
        45678901,
        "audio/mpeg"
    );
    episode1.enclosure = audioFile1;
    episode1.addCategory("AI");
    podcast.addItem(episode1);
    
    // Podcast episode 2
    auto episode2 = new DRSSItem();
    episode2.title = "Episode 2: Cloud Computing";
    episode2.link = "https://example.com/podcast/episode-2";
    episode2.description = "Exploring cloud computing platforms and best practices.";
    episode2.pubDate = Clock.currTime(UTC());
    episode2.guid = "https://example.com/podcast/episode-2";
    
    auto audioFile2 = new DRSSEnclosure(
        "https://example.com/podcast/episode-2.mp3",
        52341234,
        "audio/mpeg"
    );
    episode2.enclosure = audioFile2;
    episode2.addCategory("Cloud");
    podcast.addItem(episode2);
    
    writeln("  Podcast feed created with ", podcast.items.length, " episodes");
    writeln("  Title: ", podcast.title);
    writeln();

    // Example 7: Creating a news feed
    writeln("7. Creating a news RSS feed:\n");
    
    auto news = new DRSSFeed(
        "Tech News Daily",
        "https://technews.example.com",
        "Latest technology news and updates"
    );
    
    news.language = "en-us";
    news.copyright = "© 2026 Tech News Daily";
    news.managingEditor = "editor@technews.example.com";
    news.ttl = 15; // Update every 15 minutes
    news.addCategory("News");
    news.addCategory("Technology");
    
    // News items
    for (int i = 1; i <= 5; i++) {
        auto newsItem = new DRSSItem();
        newsItem.title = "Breaking News Story " ~ i.to!string;
        newsItem.link = "https://technews.example.com/story-" ~ i.to!string;
        newsItem.description = "This is breaking news story number " ~ i.to!string ~ " about latest technology developments.";
        newsItem.pubDate = Clock.currTime(UTC()) - dur!"hours"(i);
        newsItem.guid = "https://technews.example.com/story-" ~ i.to!string;
        newsItem.addCategory("Breaking News");
        news.addItem(newsItem);
    }
    
    writeln("  News feed created with ", news.items.length, " stories");
    writeln("  Update frequency: Every ", news.ttl, " minutes");
    writeln();

    // Example 8: Feed statistics
    writeln("8. Feed statistics:\n");
    writeln("  Blog feed:");
    writeln("    - Items: ", feed.items.length);
    writeln("    - Categories: ", feed.categories.length);
    writeln("    - Has image: ", (feed.image !is null ? "Yes" : "No"));
    writeln();
    writeln("  Podcast feed:");
    writeln("    - Episodes: ", podcast.items.length);
    writeln("    - All have enclosures: ", (podcast.items.length > 0 && podcast.items[0].enclosure !is null ? "Yes" : "No"));
    writeln();
    writeln("  News feed:");
    writeln("    - Stories: ", news.items.length);
    writeln("    - Update TTL: ", news.ttl, " minutes");
    writeln();

    writeln("=== Example Complete ===");
}
