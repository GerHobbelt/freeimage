What is FreeImage ?
-----------------------------------------------------------------------------
FreeImage is an Open Source library project for developers who would like to support popular graphics image formats like PNG, BMP, JPEG, TIFF and others as needed by today's multimedia applications.
FreeImage is easy to use, fast, multithreading safe, and cross-platform (works with Windows, Linux and Mac OS X).

Thanks to it's ANSI C interface, FreeImage is usable in many languages including C, C++, VB, C#, Delphi, Java and also in common scripting languages such as Perl, Python, PHP, TCL, Lua or Ruby.

The library comes in two versions: a binary DLL distribution that can be linked against any WIN32/WIN64 C/C++ compiler and a source distribution.
Workspace files for Microsoft Visual Studio provided, as well as makefiles for Linux, Mac OS X and other systems.


--------------------------------------

This repository is a fork of the FreeImage project that supports building via CMake. Please see the [original project](https://sourceforge.net/projects/freeimage/) if you want the unmodified codebase.

## Building 

Make sure CMake is installed, and run the following commands:

```
$ mkdir build-FreeImage 
$ cmake /path/to/FreeImage 
$ make 
```
