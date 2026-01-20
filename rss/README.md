# UIM RSS Module

A D language library for creating and managing RSS 2.0 feeds. This module provides a complete implementation of the RSS specification with support for channels, items, categories, enclosures, and more.

## Features

- **RSS 2.0 Compliant**: Full support for RSS 2.0 specification
- **Object-Oriented Design**: Clean class hierarchy for feeds, items, and related elements
- **Type-Safe**: Strongly typed with compile-time safety
- **Podcast Support**: Built-in enclosure support for podcasts and media files
- **Category Management**: Support for multiple categories with optional domains
- **Channel Images**: Add logos and branding to your feeds
- **RFC 822 Dates**: Proper date formatting according to RSS standards

## Components

### Feed (Channel)
The main RSS channel containing metadata and items:
- Title, link, and description
- Language and copyright information
- Managing editor and webmaster contacts
- Publication and build dates
- Categories and TTL (Time To Live)
- Channel image

### Item
Individual entries in the feed:
- Title, link, and description
- Author information
- Publication date
- GUID (unique identifier)
- Categories
- Comments link
- Enclosures (for media files)

### Category
Categorization with optional domain:
- Category name
- Optional domain/taxonomy URL

### Enclosure
Media file attachments (podcasts, videos, etc.):
- URL to media file
- File size in bytes
- MIME type

### Image
Channel branding:
- Image URL
- Title and link
- Optional width and height
- Optional description

## Usage

### Creating a Basic Feed

```d
import uim.rss;
import std.datetime;

// Create the feed
auto feed = new DRSSFeed(
    "My Blog",
    "https://example.com/blog",
    "A blog about programming"
);

feed.language = "en-us";
feed.copyright = "© 2026 Example Corp";
feed.pubDate = Clock.currTime(UTC());

// Add categories
feed.addCategory("Technology");
feed.addCategory("Programming");

// Create an item
auto item = new DRSSItem();
item.title = "First Blog Post";
item.link = "https://example.com/blog/first-post";
item.description = "This is my first blog post";
item.pubDate = Clock.currTime(UTC());
item.guid = "https://example.com/blog/first-post";
item.addCategory("News");

// Add item to feed
feed.addItem(item);

// Generate RSS XML
import std.stdio;
writeln(feed.toXML());
```

### Creating a Podcast Feed

```d
import uim.rss;

auto podcast = new DRSSFeed(
    "My Podcast",
    "https://example.com/podcast",
    "Weekly tech discussions"
);

// Create an episode
auto episode = new DRSSItem();
episode.title = "Episode 1: Introduction";
episode.link = "https://example.com/podcast/ep1";
episode.description = "Welcome to the show!";

// Add audio enclosure
auto audio = new DRSSEnclosure(
    "https://example.com/media/ep1.mp3",
    12345678, // File size in bytes
    "audio/mpeg"
);
episode.enclosure = audio;

podcast.addItem(episode);

writeln(podcast.toXML());
```

### Adding a Channel Image

```d
auto image = new DRSSImage(
    "https://example.com/logo.png",
    "My Blog",
    "https://example.com"
);
image.width = 144;
image.height = 144;
feed.image = image;
```

### Working with Categories

```d
// Add to feed
feed.addCategory("Technology");
feed.addCategory("Programming", "https://example.com/taxonomy");

// Add to item
item.addCategory("Tutorial");
item.addCategory("Beginner", "https://example.com/levels");
```

### Setting TTL (Time To Live)

```d
feed.ttl = 60; // Update every 60 minutes
```

## RSS 2.0 Elements Supported

### Channel Elements
- `<title>` - Channel title
- `<link>` - Channel URL
- `<description>` - Channel description
- `<language>` - Language code (e.g., "en-us")
- `<copyright>` - Copyright notice
- `<managingEditor>` - Editor email
- `<webMaster>` - Webmaster email
- `<pubDate>` - Publication date
- `<lastBuildDate>` - Last modification date
- `<category>` - Channel categories
- `<generator>` - Feed generator name
- `<docs>` - RSS specification URL
- `<ttl>` - Time to live in minutes
- `<image>` - Channel image
- `<item>` - Feed items

### Item Elements
- `<title>` - Item title
- `<link>` - Item URL
- `<description>` - Item content
- `<author>` - Author email
- `<category>` - Item categories
- `<comments>` - Comments URL
- `<enclosure>` - Media file attachment
- `<guid>` - Unique identifier
- `<pubDate>` - Publication date
- `<source>` - Source feed

## Building

```bash
cd rss
dub build
```

## Running Examples

```bash
cd examples
dub run
```

## RSS 2.0 Specification

This library implements the [RSS 2.0 Specification](https://www.rssboard.org/rss-specification) as defined by the RSS Advisory Board.

## Common Use Cases

1. **Blog Feeds**: Syndicate blog posts with categories and descriptions
2. **Podcast Feeds**: Distribute audio/video content with enclosures
3. **News Feeds**: Publish news articles with frequent updates
4. **Product Updates**: Announce product releases and updates
5. **Event Feeds**: Share upcoming events and announcements

## Dependencies

- **uim-framework:oop** - Base OOP functionality
- **std.datetime** - Date/time handling

## License

Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.

## Author

Ozan Nurettin Süel (aka UIManufaktur)
