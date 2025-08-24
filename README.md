What is FreeImage ?
-----------------------------------------------------------------------------
FreeImage is an Open Source library project for developers who would like to support popular graphics image formats like PNG, BMP, JPEG, TIFF and others as needed by today's multimedia applications.

FreeImage is easy to use, fast, multithreading safe, and cross-platform (works with Windows, Linux and Mac OS X).

Thanks to it's ANSI C interface, FreeImage is usable in many languages including C, C++, VB, C#, Delphi, Java and also in common scripting languages such as Perl, Python, PHP, TCL, Lua or Ruby.

The library comes in two versions: a binary DLL distribution that can be linked against any WIN32/WIN64 C/C++ compiler and a source distribution.
Workspace files for Microsoft Visual Studio provided, as well as makefiles for Linux, Mac OS X and other systems.

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
