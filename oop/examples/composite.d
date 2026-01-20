/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.composite;

import uim.oop;
import std.stdio;

/**
 * Example demonstrating the Composite pattern.
 * 
 * The Composite pattern lets you compose objects into tree structures to
 * represent part-whole hierarchies. It allows clients to treat individual
 * objects and compositions uniformly.
 */

void main() @safe {
  writeln("\n=== Composite Pattern Examples ===\n");
  
  // Example 1: File System
  fileSystemExample();
  
  // Example 2: Organization Structure
  organizationExample();
  
  // Example 3: Graphics System
  graphicsExample();
  
  // Example 4: Menu System
  menuExample();
}

void fileSystemExample() @safe {
  writeln("1. File System Example:");
  writeln("-----------------------");
  
  class File : Leaf {
    private size_t _size;
    
    this(string name, size_t size) {
      super(name, name);
      _size = size;
    }
    
    size_t size() { return _size; }
    
    override string execute() {
      import std.conv : to;
      return "File: " ~ name() ~ " (" ~ _size.to!string ~ " KB)";
    }
  }
  
  class Directory : Composite {
    this(string name) {
      super(name);
    }
    
    override string execute() {
      import std.conv : to;
      string result = "Directory: " ~ name() ~ "\n";
      foreach (child; _children) {
        result ~= "  " ~ child.execute() ~ "\n";
      }
      return result;
    }
    
    size_t totalSize() {
      size_t total = 0;
      foreach (child; _children) {
        if (auto file = cast(File) child) {
          total += file.size();
        } else if (auto dir = cast(Directory) child) {
          total += dir.totalSize();
        }
      }
      return total;
    }
  }
  
  // Build file system
  auto root = new Directory("root");
  
  auto documents = new Directory("documents");
  documents.add(new File("resume.pdf", 150));
  documents.add(new File("letter.doc", 80));
  
  auto pictures = new Directory("pictures");
  pictures.add(new File("photo1.jpg", 2048));
  pictures.add(new File("photo2.jpg", 1856));
  
  root.add(documents);
  root.add(pictures);
  root.add(new File("readme.txt", 5));
  
  writeln(root.execute());
  writeln("Total size: ", root.totalSize(), " KB\n");
}

void organizationExample() @safe {
  writeln("2. Organization Structure Example:");
  writeln("-----------------------------------");
  
  class Employee : Leaf {
    private string _position;
    private double _salary;
    
    this(string name, string position, double salary) {
      super(name, name);
      _position = position;
      _salary = salary;
    }
    
    override string execute() {
      import std.format : format;
      return format("%s (%s) - $%.2f", name(), _position, _salary);
    }
    
    double salary() { return _salary; }
  }
  
  class Department : Composite {
    this(string name) {
      super(name);
    }
    
    override string execute() {
      string result = "Department: " ~ name() ~ "\n";
      foreach (child; _children) {
        result ~= "  " ~ child.execute() ~ "\n";
      }
      return result;
    }
    
    double totalBudget() {
      double total = 0;
      foreach (child; _children) {
        if (auto emp = cast(Employee) child) {
          total += emp.salary();
        } else if (auto dept = cast(Department) child) {
          total += dept.totalBudget();
        }
      }
      return total;
    }
  }
  
  // Build organization
  auto company = new Department("Tech Corp");
  
  auto engineering = new Department("Engineering");
  engineering.add(new Employee("Alice", "Senior Engineer", 120000));
  engineering.add(new Employee("Bob", "Engineer", 90000));
  
  auto sales = new Department("Sales");
  sales.add(new Employee("Charlie", "Sales Manager", 95000));
  sales.add(new Employee("Diana", "Sales Rep", 70000));
  
  company.add(engineering);
  company.add(sales);
  company.add(new Employee("Eve", "CEO", 200000));
  
  writeln(company.execute());
  writeln("Total Budget: $", company.totalBudget(), "\n");
}

void graphicsExample() @safe {
  writeln("3. Graphics System Example:");
  writeln("---------------------------");
  
  class Shape : Leaf {
    private string _type;
    
    this(string name, string type) {
      super(name, name);
      _type = type;
    }
    
    override string execute() {
      return "Draw " ~ _type ~ ": " ~ name();
    }
  }
  
  class Group : Composite {
    this(string name) {
      super(name);
    }
    
    override string execute() {
      string result = "Group: " ~ name() ~ "\n";
      foreach (child; _children) {
        result ~= "  " ~ child.execute() ~ "\n";
      }
      return result;
    }
  }
  
  // Build graphics
  auto canvas = new Group("Canvas");
  
  auto background = new Group("Background");
  background.add(new Shape("Sky", "Rectangle"));
  background.add(new Shape("Ground", "Rectangle"));
  
  auto foreground = new Group("Foreground");
  foreground.add(new Shape("Tree", "Circle"));
  foreground.add(new Shape("House", "Rectangle"));
  foreground.add(new Shape("Roof", "Triangle"));
  
  canvas.add(background);
  canvas.add(foreground);
  canvas.add(new Shape("Sun", "Circle"));
  
  writeln("Rendering scene:");
  writeln(canvas.execute());
}

void menuExample() @safe {
  writeln("4. Menu System Example:");
  writeln("-----------------------");
  
  class MenuItem : Leaf {
    private string _action;
    
    this(string name, string action) {
      super(name, name);
      _action = action;
    }
    
    override string execute() {
      return name() ~ " -> " ~ _action;
    }
  }
  
  class Menu : Composite {
    this(string name) {
      super(name);
    }
    
    override string execute() {
      string result = name() ~ ":\n";
      foreach (i, child; _children) {
        result ~= "  " ~ (i + 1).stringof ~ ". " ~ child.execute() ~ "\n";
      }
      return result;
    }
  }
  
  // Build menu system
  auto mainMenu = new Menu("Main Menu");
  
  auto fileMenu = new Menu("File");
  fileMenu.add(new MenuItem("New", "Create new file"));
  fileMenu.add(new MenuItem("Open", "Open existing file"));
  fileMenu.add(new MenuItem("Save", "Save current file"));
  fileMenu.add(new MenuItem("Exit", "Exit application"));
  
  auto editMenu = new Menu("Edit");
  editMenu.add(new MenuItem("Copy", "Copy selection"));
  editMenu.add(new MenuItem("Paste", "Paste from clipboard"));
  editMenu.add(new MenuItem("Find", "Find text"));
  
  auto helpMenu = new Menu("Help");
  helpMenu.add(new MenuItem("Documentation", "View docs"));
  helpMenu.add(new MenuItem("About", "About this app"));
  
  mainMenu.add(fileMenu);
  mainMenu.add(editMenu);
  mainMenu.add(helpMenu);
  
  writeln(mainMenu.execute());
}
