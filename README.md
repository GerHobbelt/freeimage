# FreeImage

March 15th, 2015
FreeImage 3.17.0 released

Release 3.17.0 adds many improvements for ICO, TIFF, PNG, HDR, TGA, GIF, RAW, JXR, JP2, Exif plugins. It comes with new conversion functions for RGBA16/RGBAF formats, as well as new functions used to deal with external pixel buffers (ConvertFromRawBitsEx, CreateView). Other useful added functions are ReslaleRect, GetMemorySize, SetMetadataKeyValue and the FIQ_LFPQUANT quantizer algorithm.
The library has been updated with the new LibPNG (1.6.16), LibTIFF (4.0.4), LibRaw (0.17.a1), LibWebP (0.4.2), OpenEXR (2.2.0).
FreeImage is also distributed with updated VB6, Delphi and C++ wrappers.


# Supported formats

* BMP files [reading, writing]
* Dr. Halo CUT files [reading]
* DDS files [reading]
* EXR files [reading, writing]
* Raw Fax G3 files [reading]
* GIF files [reading, writing]
* HDR files [reading, writing]
* ICO files [reading, writing]
* IFF files [reading]
* JBIG files [reading, writing] **
* JNG files [reading, writing]
* JPEG/JIF files [reading, writing]
* JPEG-2000 File Format [reading, writing]
* JPEG-2000 codestream [reading, writing]
* JPEG-XR files [reading, writing]
* KOALA files [reading]
* Kodak PhotoCD files [reading]
* MNG files [reading]
* PCX files [reading]
* PBM/PGM/PPM files [reading, writing]
* PFM files [reading, writing]
* PNG files [reading, writing]
* Macintosh PICT files [reading]
* Photoshop PSD files [reading]
* RAW camera files [reading]
* Sun RAS files [reading]
* SGI files [reading]
* TARGA files [reading, writing]
* TIFF files [reading, writing]
* WBMP files [reading, writing]
* WebP files [reading, writing]
* XBM files [reading]
* XPM files [reading, writing] 

### Appveyor builds
Current master:

[![Build status](https://ci.appveyor.com/api/projects/status/b87gv2bu4synmb1h/branch/master?svg=true)](https://ci.appveyor.com/project/imazen/freeimage/branch/master)

Last build:

[![Build status](https://ci.appveyor.com/api/projects/status/b87gv2bu4synmb1h?svg=true)](https://ci.appveyor.com/project/imazen/freeimage)

### Travis build

[![Build Status](https://travis-ci.org/imazen/freeimage.svg?branch=master)](https://travis-ci.org/imazen/freeimage)
