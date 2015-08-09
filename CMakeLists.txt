cmake_minimum_required(VERSION 2.8.0)

# FreeImage version
SET( FREEIMAGE_VERSION_MAIN 3)
SET( FREEIMAGE_VERSION_MIDDLE 16)
SET( FREEIMAGE_VERSION_LOWER 0)
SET( FREEIMAGE_VERSION_MINOR 0)
SET( FREEIMAGE_VERSION ${FREEIMAGE_VERSION_MAIN}.${FREEIMAGE_VERSION_MIDDLE}.${FREEIMAGE_VERSION_LOWER} )
SET( FREEIMAGE_VERSION_BUILD ${FREEIMAGE_VERSION_MAIN}.${FREEIMAGE_VERSION_MIDDLE}.${FREEIMAGE_VERSION_LOWER}.${FREEIMAGE_VERSION_MINOR} )


OPTION(ENABLE_PNG "Enable PNG support" 1)
OPTION(ENABLE_JPEG "Enable JPEG support" 1)
OPTION(ENABLE_TIFF "Enable TIFF support" 1)
OPTION(ENABLE_WEBP "Enable WebP support" 0)
OPTION(ENABLE_PLUS "Enable FreeImagePlus wrapper" 1)
OPTION(ENABLE_RAW "Enable RAW support" 0)
OPTION(ENABLE_OPENJP "Enable OpenJPEG support" 0)
OPTION(ENABLE_TESTS "Make built in tests" 0)
OPTION(FREEIMAGE_BUILD_STATIC "Enable static build of freeimage" 1)
OPTION(FREEIMAGE_DYNAMIC_C_RUNTIME "If ON build FreeImage with dynamicly linked C/C++ runtime. If OFF FreeImage is staticly linked with C/C++ runtime.")

IF(NOT FREEIMAGE_DYNAMIC_C_RUNTIME)
# Set to link staticly with runtime
set(CMAKE_USER_MAKE_RULES_OVERRIDE
   ${CMAKE_CURRENT_SOURCE_DIR}/c_flag_overrides.cmake)
set(CMAKE_USER_MAKE_RULES_OVERRIDE_CXX
   ${CMAKE_CURRENT_SOURCE_DIR}/cxx_flag_overrides.cmake)
ENDIF(NOT FREEIMAGE_DYNAMIC_C_RUNTIME)

project (FreeImage)
SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMakeModules)

# Check parameters
INCLUDE(CheckIncludeFile)
INCLUDE(CheckIncludeFileCXX)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckTypeSize)

# Find packages
add_library(zlib Source/ZLib/zlib.h Source/ZLib/crc32.h Source/ZLib/deflate.h Source/ZLib/gzguts.h Source/ZLib/inffast.h Source/ZLib/inffixed.h Source/ZLib/inflate.h Source/ZLib/inftrees.h Source/ZLib/trees.h Source/ZLib/zutil.h Source/ZLib/adler32.c Source/ZLib/compress.c Source/ZLib/crc32.c Source/ZLib/deflate.c Source/ZLib/gzclose.c Source/ZLib/gzlib.c Source/ZLib/gzread.c Source/ZLib/gzwrite.c Source/ZLib/inflate.c Source/ZLib/infback.c Source/ZLib/inftrees.c Source/ZLib/inffast.c Source/ZLib/trees.c Source/ZLib/uncompr.c Source/ZLib/zutil.c)
include_directories(AFTER Source/OpenEXR Source/OpenEXR/Imath Source/OpenEXR/Iex Source/OpenEXR/IexMath Source/OpenEXR/Half Source/LibJXR/jxrgluelib Source/LibJXR/image/sys)
SET(ZLIB_INCLUDE_DIR Source/Zlib/)
IF(ENABLE_PNG)
  include_directories(BEFORE Source/Zlib/)
  add_library(png Source/LibPNG/example.c Source/LibPNG/png.c Source/LibPNG/pngerror.c Source/LibPNG/pngget.c Source/LibPNG/pngmem.c Source/LibPNG/pngpread.c Source/LibPNG/pngread.c Source/LibPNG/pngrio.c Source/LibPNG/pngrtran.c Source/LibPNG/pngrutil.c Source/LibPNG/pngset.c Source/LibPNG/pngtest.c Source/LibPNG/pngtrans.c Source/LibPNG/pngwio.c Source/LibPNG/pngwrite.c Source/LibPNG/pngwtran.c Source/LibPNG/pngwutil.c Source/LibPNG/png.h Source/LibPNG/pngconf.h Source/LibPNG/pngdebug.h Source/LibPNG/pnginfo.h Source/LibPNG/pnglibconf.h Source/LibPNG/pngpriv.h Source/LibPNG/pngstruct.h)
  ADD_DEFINITIONS(-DENABLE_PNG)
ENDIF()
IF(ENABLE_JPEG)
  add_library(jpeg Source/LibJPEG/ansi2knr.c Source/LibJPEG/cderror.h Source/LibJPEG/cdjpeg.c Source/LibJPEG/cdjpeg.h Source/LibJPEG/cjpeg.c Source/LibJPEG/ckconfig.c Source/LibJPEG/djpeg.c Source/LibJPEG/example.c Source/LibJPEG/jaricom.c Source/LibJPEG/jcapimin.c Source/LibJPEG/jcapistd.c Source/LibJPEG/jcarith.c Source/LibJPEG/jccoefct.c Source/LibJPEG/jccolor.c Source/LibJPEG/jcdctmgr.c Source/LibJPEG/jchuff.c Source/LibJPEG/jcinit.c Source/LibJPEG/jcmainct.c Source/LibJPEG/jcmarker.c Source/LibJPEG/jcmaster.c Source/LibJPEG/jcomapi.c Source/LibJPEG/jconfig.h Source/LibJPEG/jcparam.c Source/LibJPEG/jcprepct.c Source/LibJPEG/jcsample.c Source/LibJPEG/jctrans.c Source/LibJPEG/jdapimin.c Source/LibJPEG/jdapistd.c Source/LibJPEG/jdarith.c Source/LibJPEG/jdatadst.c Source/LibJPEG/jdatasrc.c Source/LibJPEG/jdcoefct.c Source/LibJPEG/jdcolor.c Source/LibJPEG/jdct.h Source/LibJPEG/jddctmgr.c Source/LibJPEG/jdhuff.c Source/LibJPEG/jdinput.c Source/LibJPEG/jdmainct.c Source/LibJPEG/jdmarker.c Source/LibJPEG/jdmaster.c Source/LibJPEG/jdmerge.c Source/LibJPEG/jdpostct.c Source/LibJPEG/jdsample.c Source/LibJPEG/jdtrans.c Source/LibJPEG/jerror.c Source/LibJPEG/jerror.h Source/LibJPEG/jfdctflt.c Source/LibJPEG/jfdctfst.c Source/LibJPEG/jfdctint.c Source/LibJPEG/jidctflt.c Source/LibJPEG/jidctfst.c Source/LibJPEG/jidctint.c Source/LibJPEG/jinclude.h Source/LibJPEG/jmemansi.c  Source/LibJPEG/jmemmgr.c Source/LibJPEG/jmemname.c Source/LibJPEG/jmemnobs.c Source/LibJPEG/jmemsys.h Source/LibJPEG/jmorecfg.h Source/LibJPEG/jpegint.h Source/LibJPEG/jpeglib.h Source/LibJPEG/jpegtran.c Source/LibJPEG/jquant1.c Source/LibJPEG/jquant2.c Source/LibJPEG/jutils.c Source/LibJPEG/jversion.h Source/LibJPEG/rdbmp.c Source/LibJPEG/rdcolmap.c Source/LibJPEG/rdgif.c Source/LibJPEG/rdjpgcom.c Source/LibJPEG/rdppm.c Source/LibJPEG/rdrle.c Source/LibJPEG/rdswitch.c Source/LibJPEG/rdtarga.c Source/LibJPEG/transupp.c Source/LibJPEG/transupp.h Source/LibJPEG/wrbmp.c Source/LibJPEG/wrgif.c Source/LibJPEG/wrjpgcom.c Source/LibJPEG/wrppm.c Source/LibJPEG/wrrle.c Source/LibJPEG/wrtarga.c)
  ADD_DEFINITIONS(-DENABLE_JPEG)
ENDIF()
IF(ENABLE_TIFF)
  add_library(tiff Source/LibTIFF4/mkg3states.c Source/LibTIFF4/mkspans.c Source/LibTIFF4/t4.h Source/LibTIFF4/tiff.h Source/LibTIFF4/tiffconf.h Source/LibTIFF4/tiffconf.h-vms Source/LibTIFF4/tiffconf.h.in Source/LibTIFF4/tiffconf.vc.h Source/LibTIFF4/tiffio.h Source/LibTIFF4/tiffio.hxx Source/LibTIFF4/tiffiop.h Source/LibTIFF4/tiffvers.h Source/LibTIFF4/tiffvers.h.in Source/LibTIFF4/tif_aux.c Source/LibTIFF4/tif_close.c Source/LibTIFF4/tif_codec.c Source/LibTIFF4/tif_color.c Source/LibTIFF4/tif_compress.c Source/LibTIFF4/tif_config.h Source/LibTIFF4/tif_config.h-vms Source/LibTIFF4/tif_config.h.in Source/LibTIFF4/tif_config.vc.h Source/LibTIFF4/tif_dir.c Source/LibTIFF4/tif_dir.h Source/LibTIFF4/tif_dirinfo.c Source/LibTIFF4/tif_dirread.c Source/LibTIFF4/tif_dirwrite.c Source/LibTIFF4/tif_dumpmode.c Source/LibTIFF4/tif_error.c Source/LibTIFF4/tif_extension.c Source/LibTIFF4/tif_fax3.c Source/LibTIFF4/tif_fax3.h Source/LibTIFF4/tif_fax3sm.c Source/LibTIFF4/tif_flush.c Source/LibTIFF4/tif_getimage.c Source/LibTIFF4/tif_jbig.c Source/LibTIFF4/tif_jpeg.c Source/LibTIFF4/tif_jpeg_12.c Source/LibTIFF4/tif_luv.c Source/LibTIFF4/tif_lzma.c Source/LibTIFF4/tif_lzw.c Source/LibTIFF4/tif_next.c Source/LibTIFF4/tif_ojpeg.c Source/LibTIFF4/tif_open.c Source/LibTIFF4/tif_packbits.c Source/LibTIFF4/tif_pixarlog.c Source/LibTIFF4/tif_predict.c Source/LibTIFF4/tif_predict.h Source/LibTIFF4/tif_print.c Source/LibTIFF4/tif_read.c Source/LibTIFF4/tif_stream.cxx Source/LibTIFF4/tif_strip.c Source/LibTIFF4/tif_swab.c Source/LibTIFF4/tif_thunder.c Source/LibTIFF4/tif_tile.c Source/LibTIFF4/tif_unix.c Source/LibTIFF4/tif_version.c Source/LibTIFF4/tif_warning.c Source/LibTIFF4/tif_win32.c Source/LibTIFF4/tif_write.c Source/LibTIFF4/tif_zip.c Source/LibTIFF4/uvcode.h Source/LibTIFF4/)
  add_library(half Source/OpenEXR/Half/eLut.cpp Source/OpenEXR/Half/eLut.h Source/OpenEXR/Half/half.cpp Source/OpenEXR/Half/half.h Source/OpenEXR/Half/halfExport.h Source/OpenEXR/Half/halfFunction.h Source/OpenEXR/Half/halfLimits.h Source/OpenEXR/Half/toFloat.cpp Source/OpenEXR/Half/toFloat.h)
  ADD_DEFINITIONS(-DENABLE_TIFF)
ENDIF()
IF(ENABLE_WEBP)
  find_path(WEBP_INCLUDE_DIR mux_types.h)
  find_library(WEBP_LIBRARIES NAMES webp libwebp)
  SET(LIBS ${LIBS} ${WEBP_LIBRARIES})
  find_library(WEBP_MUX_LIBRARIES NAMES webpmux libwebpmux)
  SET(LIBS ${LIBS} ${WEBP_MUX_LIBRARIES})
  ADD_DEFINITIONS(-DENABLE_WEBP)
ENDIF()
IF(ENABLE_RAW)
  find_path(RAW_INCLUDE_DIR libraw.h)
  find_library(RAW_LIBRARIES NAMES raw_static libraw_static)
  SET(LIBS ${LIBS} ${RAW_LIBRARIES})
ENDIF()
IF(ENABLE_OPENJP)
  find_path(OPENJP_INCLUDE_DIR openjpeg.h)
  find_library(OPENJP_LIBRARIES NAMES openjp2 libopenjp2)
  SET(LIBS ${LIBS} ${OPENJP_LIBRARIES})
ENDIF()
IF(ENABLE_PLUS)
  add_library(FreeImagePlus Wrapper/FreeImagePlus/src/fipImage.cpp Wrapper/FreeImagePlus/src/fipMemoryIO.cpp Wrapper/FreeImagePlus/src/fipMetadataFind.cpp Wrapper/FreeImagePlus/src/fipMultiPage.cpp Wrapper/FreeImagePlus/src/fipTag.cpp Wrapper/FreeImagePlus/src/fipWinImage.cpp Wrapper/FreeImagePlus/src/FreeImagePlus.cpp)
  include_directories(AFTER Wrapper/FreeImagePlus Source/)
ENDIF()

# Set default output dirs
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Set libraries for static or DLL build
IF(FREEIMAGE_BUILD_STATIC)
  SET(FREEIMAGE_BUILD_FLAGS -DFREEIMAGE_LIB)
ELSE(FREEIMAGE_BUILD_STATIC)
  SET(FREEIMAGE_LIBRARIES FreeImage)
  SET(FREEIMAGE_BUILD_DLL ON)
ENDIF(FREEIMAGE_BUILD_STATIC)

SET(FREEIMAGE_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/Source)
SET(FREEIMAGE_LIBRARY_DIRS ${CMAKE_BINARY_DIR}/Lib)

add_subdirectory(Source)

IF(ENABLE_TESTS)
  ENABLE_TESTING()
  add_subdirectory(TestAPI)
ENDIF()
