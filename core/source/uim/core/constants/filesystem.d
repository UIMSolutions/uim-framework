/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.constants.filesystem;

import uim.core;

mixin(ShowModule!());

@safe:

const string[] fileExtensions = [
  "txt",
  "json",
  "xml",
  "html",
  "csv",
  "md",
  "log",
  "zip",
  "tar",
  "gz",
  "bz2",
  "xz",
  "7z",
  "rar",
  "tar.gz",
  "tar.bz2",
  "tar.xz"
];
const string[] imageExtensions = [
  "jpg",
  "jpeg",
  "png",
  "gif",
  "bmp",
  "tiff",
  "webp",
  "svg",
  "ico"
];
const string[] videoExtensions = [
  "mp4",
  "avi",
  "mkv",
  "mov",
  "wmv",
  "flv",
  "webm",
  "mpeg",
  "mpg"
];
const string[] audioExtensions = [
  "mp3",
  "wav",
  "flac",
  "aac",
  "ogg",
  "wma",
  "m4a",
  "opus"
];
const string[] documentExtensions = [
  "pdf",
  "doc",
  "docx",
  "ppt",
  "pptx",
  "xls",
  "xlsx",
  "odt",
  "ods",
  "odp"
];
const string[] archiveExtensions = [
  "zip",
  "tar",
  "gz",
  "bz2",
  "xz",
  "7z",
  "rar"
];
const string[] codeExtensions = [
  "c",
  "cpp",
  "h",
  "hpp",
  "java",
  "py",
  "js",
  "ts",
  "rb",
  "go",
  "php",
  "html",
  "css",
  "swift",
  "kt"
];
const string[] fontExtensions = [
  "ttf",
  "otf",
  "woff",
  "woff2",
  "eot",
  "svg"
];
const string[] databaseExtensions = [
  "sql",
  "db",
  "sqlite",
  "mdb",
  "accdb"
];
const string[] markupExtensions = [
  "html",
  "xml",
  "json",
  "yaml",
  "md",
  "markdown"
];
const string[] scriptExtensions = [
  "sh",
  "bat",
  "ps1",
  "pl",
  "rb",
  "py",
  "js",
  "ts"
];
const string[] backupExtensions = [
  "bak",
  "old",
  "orig",
  "swp",
  "swo",
  "tmp"
];
const string[] systemExtensions = [
  "dll",
  "exe",
  "sys",
  "drv",
  "so",
  "dylib"
];
const string[] webExtensions = [
  "html",
  "css",
  "js",
  "json",
  "xml",
  "svg",
  "woff",
  "woff2",
  "ttf"
];
const string[] emailExtensions = [
  "eml",
  "msg",
  "mbox",
  "pst",
  "ost"
];
const string[] configurationExtensions = [
  "ini",
  "cfg",
  "conf",
  "properties",
  "json",
  "yaml",
  "yml"
];
const string[] logExtensions = [
  "log",
  "txt",
  "csv",
  "json"
];
const string[] temporaryExtensions = [
  "tmp",
  "temp",
  "part",
  "swp",
  "swo"
];
const string[] sourceCodeExtensions = [
  "c",
  "cpp",
  "h",
  "hpp",
  "java",
  "py",
  "js",
  "ts",
  "rb",
  "go",
  "php",
  "swift",
  "kt"
];
const string[] spreadsheetExtensions = [
  "xls",
  "xlsx",
  "ods",
  "csv"
];
const string[] presentationExtensions = [
  "ppt",
  "pptx",
  "odp"
];
const string[] vectorImageExtensions = [
  "svg",
  "eps",
  "ai",
  "pdf"
];
const string[] rasterImageExtensions = [
  "jpg",
  "jpeg",
  "png",
  "gif",
  "bmp",
  "tiff",
  "webp"
];
const string[] _3dModelExtensions = [
  "stl",
  "obj",
  "fbx",
  "dae",
  "blend",
  "3ds",
  "ply"
];
const string[] fontFileExtensions = [
  "ttf",
  "otf",
  "woff",
  "woff2",
  "eot",
  "svg"
];
const string[] vectorGraphicExtensions = [
  "svg",
  "eps",
  "ai",
  "pdf"
];
const string[] rasterGraphicExtensions = [
  "jpg",
  "jpeg",
  "png",
  "gif",
  "bmp",
  "tiff",
  "webp"
];
const string[] spreadsheetFileExtensions = [
  "xls",
  "xlsx",
  "ods",
  "csv"
];
const string[] presentationFileExtensions = [
  "ppt",
  "pptx",
  "odp"
];
const string[] markupFileExtensions = [
  "html",
  "xml",
  "json",
  "yaml",
  "md",
  "markdown"
];
const string[] scriptFileExtensions = [
  "sh",
  "bat",
  "ps1",
  "pl",
  "rb",
  "py",
  "js",
  "ts"
];
const string[] databaseFileExtensions = [
  "sql",
  "db",
  "sqlite",
  "mdb",
  "accdb"
];
const string[] emailFileExtensions = [
  "eml",
  "msg",
  "mbox",
  "pst",
  "ost"
];
const string[] backupFileExtensions = [
  "bak",
  "old",
  "orig",
  "swp",
  "swo",
  "tmp"
];
const string[] systemFileExtensions = [
  "dll",
  "exe",
  "sys",
  "drv",
  "so",
  "dylib"
];
const string[] webFileExtensions = [
  "html",
  "css",
  "js",
  "json",
  "xml",
  "svg",
  "woff",
  "woff2",
  "ttf"
];
const string[] configurationFileExtensions = [
  "ini",
  "cfg",
  "conf",
  "properties",
  "json",
  "yaml",
  "yml"
];
const string[] logFileExtensions = [
  "log",
  "txt",
  "csv",
  "json"
];
const string[] temporaryFileExtensions = [
  "tmp",
  "temp",
  "part",
  "swp",
  "swo"
];
const string[] sourceCodeFileExtensions = [
  "c",
  "cpp",
  "h",
  "hpp",
  "java",
  "py",
  "js",
  "ts",
  "rb",
  "go",
  "php",
  "swift",
  "kt"
];
const string[] archiveFileExtensions = [
  "zip",
  "tar",
  "gz",
  "bz2",
  "xz",
  "7z",
  "rar"
];
const string[] _3dModelFileExtensions = [
  "stl",
  "obj",
  "fbx",
  "dae",
  "blend",
  "3ds",
  "ply"
];
const string[] vectorImageFileExtensions = [
  "svg",
  "eps",
  "ai",
  "pdf"
];      
const string[] rasterImageFileExtensions = [
  "jpg",
  "jpeg",
  "png",
  "gif",
  "bmp",
  "tiff",
  "webp"
];