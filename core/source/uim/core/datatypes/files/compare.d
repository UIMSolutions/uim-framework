module uim.core.datatypes.files.compare;

import uim.core;

mixin(ShowModule!());

@safe:

bool compareFiles(string file1, string file2) {
  // Compare file sizes first
  if (getSize(file1) != getSize(file2)) {
    return false;
  }

  // Compare byte-by-byte
  auto content1 = read(file1);
  auto content2 = read(file2);

  return content1 == content2;
}

bool compareFilesChunked(string file1, string file2, size_t chunkSize = 4096) {
  // Compare file sizes first
  if (getSize(file1) != getSize(file2)) {
    return false;
  }

  auto f1 = File(file1, "rb");
  auto f2 = File(file2, "rb");

  ubyte[] buffer1 = new ubyte[chunkSize];
  ubyte[] buffer2 = new ubyte[chunkSize];

  // Compare in chunks
  while (!f1.eof && !f2.eof) {
    auto chunk1 = f1.rawRead(buffer1);
    auto chunk2 = f2.rawRead(buffer2);

    if (chunk1 != chunk2) {
      return false;
    }
  }

  return f1.eof && f2.eof;
}

bool compareFilesHash(string file1, string file2) {
  // Compare file sizes first
  if (getSize(file1) != getSize(file2)) {
    return false;
  }

  auto hash1 = digest!SHA256(read(file1));
  auto hash2 = digest!SHA256(read(file2));

  return hash1 == hash2;
}

// Oder für große Dateien:
ubyte[32] hashFile(string filename) {
  auto file = File(filename, "rb");
  SHA256 hash;
  hash.start();

  ubyte[] buffer = new ubyte[4096];
  while (!file.eof) {
    auto chunk = file.rawRead(buffer);
    hash.put(chunk);
  }

  return hash.finish();
}

bool compareFilesHashLarge(string file1, string file2) {
  if (getSize(file1) != getSize(file2)) {
    return false;
  }
  return hashFile(file1) == hashFile(file2);
}

enum CompareResult {
  identical,
  different,
  error
}

struct FileComparison {
  CompareResult result;
  string message;
}

FileComparison compareFilesSafe(string file1, string file2) {
  try {
    // Prüfen ob Dateien existieren
    if (!exists(file1)) {
      return FileComparison(CompareResult.error, "Datei 1 nicht gefunden");
    }
    if (!exists(file2)) {
      return FileComparison(CompareResult.error, "Datei 2 nicht gefunden");
    }

    // Größe vergleichen
    auto size1 = getSize(file1);
    auto size2 = getSize(file2);

    if (size1 != size2) {
      return FileComparison(CompareResult.different,
        "Unterschiedliche Größen: %d vs %d".format(size1, size2));
    }

    // Inhalt vergleichen
    auto f1 = File(file1, "rb");
    auto f2 = File(file2, "rb");

    ubyte[] buffer1 = new ubyte[4096];
    ubyte[] buffer2 = new ubyte[4096];

    size_t position = 0;
    while (!f1.eof && !f2.eof) {
      auto chunk1 = f1.rawRead(buffer1);
      auto chunk2 = f2.rawRead(buffer2);

      if (chunk1 != chunk2) {
        return FileComparison(CompareResult.different,
          "Unterschied bei Position %d".format(position));
      }
      position += chunk1.length;
    }

    return FileComparison(CompareResult.identical, "Dateien sind identisch");

  } catch (Exception e) {
    return FileComparison(CompareResult.error,
      "Fehler: " ~ e.msg);
  }
}
