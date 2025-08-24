What is FreeImage ?
-----------------------------------------------------------------------------
FreeImage is an Open Source library project for developers who would like to support popular graphics image formats like PNG, BMP, JPEG, TIFF and others as needed by today's multimedia applications.

FreeImage is easy to use, fast, multithreading safe, and cross-platform (works with Windows, Linux and Mac OS X).

### This GitHub Fork/Patch of FreeImage
 - Numerous Sub-Dependancy patches (Security/Bugs/Latest) 
 - With patches applied from nVidia Devs and OpenSource additions
 - CMake Build ability allowing compiling easily for all targets and platforms 

Thanks to it's ANSI C interface, FreeImage is usable in many languages including C, C++, VB, C#, Delphi, Java and also in common scripting languages such as Perl, Python, PHP, TCL, Lua or Ruby.

The library comes in two versions: a binary DLL distribution that can be linked against any WIN32/WIN64 C/C++ compiler and a source distribution.
Workspace files for Microsoft Visual Studio provided, as well as makefiles for Linux, Mac OS X and other systems.

## Original Source Code Upstream
https://sourceforge.net/projects/freeimage
Original library can be found : https://freeimage.sourceforge.io 

## Status

[![CMake build](https://github.com/danoli3/FreeImage/actions/workflows/cmake.yml/badge.svg)](https://github.com/danoli3/FreeImage/actions/workflows/cmake.yml)

## Building this fork

By default, JPEG-XR support is only included on Windows, but not on other platforms.

### Simply build it

```bash
cmake . -B cmake-build
cmake --build cmake-build # On Linux, add -j$(nproc) for multicore build
```

### Build and install Debug and Release configuration

```bash
cmake . -B cmake-build-debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=install_dir
cmake --build cmake-build-debug --config Debug --target install # Linux: -j$(nproc)

cmake . -B cmake-build-release -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=install_dir
cmake --build cmake-build-release --config Release --target install # Linux: -j$(nproc)
```
Now `install_dir` contains the compiled binaries for debug and release, as well as the header file and the CMake Config files.

## Using compiled binaries

First, build and install it like explained above.

Then, in another project add the following CMake code:
```cmake
set(CMAKE_PREFIX_PATH <freeimage_install_location>)
find_package(FreeImage CONFIG REQUIRED)
...
target_link_libraries(<your_target> PRIVATE FreeImage::FreeImage)
```

For `find_package` to work, simply set `CMAKE_PREFIX_PATH` to the directory where the compiled binaries are installed (the `install_dir` folder from above).

## Running tests

```bash
cmake . -B cmake-build-debug -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTS=ON
cmake --build cmake-build-debug --config Debug # Linux: -j$(nproc)
ctest --test-dir cmake-build-debug -C Debug # Optionally --rerun-failed --output-on-failure
```

> This ctest command only works with CMake 3.20 or higher. For earlier versions, you must `cd` into `cmake-build-debug` and call ctest without `--test-dir cmake-build-debug`.

----
This is a clone of https://sourceforge.net/p/freeimage/svn/ .

FreeImage is currently sporadically maintained by Hervé Drolon on SourceForge. It is licensed under the GNU General Public License, version 2.0 (GPLv2) or version 3.0 (GPLv3), and the FreeImage Public License (FIPL). More details on the project homepage: https://freeimage.sourceforge.io/ .

Known issues:
-----------------------------------------------------------------------------

    - various CVEs identified and unpatched/fixed
    - buffer overflows in PluginICO.cpp, PSDParser.cpp, PluginTIFF.cpp
    - out of bounds accesses in PluginBMP, PluginPSD, PluginMNG and PluginPICT;
    - integer wrap around and segmentation fault in Exif.cpp;
    - incorrect behavior with extreme values for the tone-mapping algorithms;
    - the jxr encoder cannot handle very large images [eg. >1300 mgpx];
    - the bmp decoder/encoder cannot handle very large images [eg. >1300 mgpx];
    - FreeImage_FlipVertical() does not work correctly with image objects created via FreeImage_CreateView();
    - FreeImage_Copy() crashes with very large images [eg. over 5000 mgpx];
    - FreeImage_Rescale() yields incorrect results for very large images [eg. >4000 mgpx];
    - FreeImage_Rotate() cannot handle very large images [eg. >5000 mgpx];
    - very old OpenEXR library - version 2.2.0;

These issues have been fixed in the QPV branch on this repository.
