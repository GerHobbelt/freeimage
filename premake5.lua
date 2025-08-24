--
--  FreeImage v3.19.0 build script
--

-- Set a prefix for the install action below
local prefix = _OPTIONS["prefix"] or "./Dist"

-----------------------------------------------------------------------------------------------------------------------------------------------------

solution "FreeImage"
    configurations { "Debug", "Release" }
    platforms { "x32", "x64" }
	location "build"

-----------------------------------------------------------------------------------------------------------------------------------------------------
project "FreeImage"
	kind "SharedLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")

	includedirs
    {
		"Source",
		"Source/Zlib",
		"Source/deprecationmanager",
		"Source/OpenEXR/half",
		"Source/OpenEXR/iex",
		"Source/OpenEXR/ilmimf",
		"Source/OpenEXR/imath",
		"Source/OpenEXR/ilmthread",
    }
        
    files 
    { 
		"Source/*.h",
		"Source/*.cpp",
		"Source/deprecationmanager/*.cpp",
		"Source/FreeImage/*.cpp",
		"Source/metadata/*.cpp",
		"Source/FreeImagetoolkit/*.h",
		"Source/FreeImagetoolkit/*.cpp",	
    }
    
    excludes
    {
    }
	
	links 
	{
		"Zlib",
		"OpenEXR",
		"LibTIFF4",
		"LibPNG",
		"LibOpenJpeg",
		"LibJPEG",
		"LibJXR",
		"LibWebP",
		"LibRaw", 
	}

	defines 
	{
		"WIN32",
		"_WIN32",
		"_WINDOWS",

		"_USRDLL",
		"OPJ_STATIC",
		"FREEIMAGE_EXPORTS",
		"_CRT_SECURE_NO_DEPRECATE",
		"LIBRAW_NODLL",
	}

    filter "configurations:Debug"
        defines { "DEBUG" }
		symbols "On" -- Generate debug symbols
        targetname "FreeImage"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations      	  
        targetname "FreeImage"

    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )
	filter{}

-----------------------------------------------------------------------------------------------------------------------------------------------------
project "FreeImageLib"
	kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")

    includedirs
    {
		"Source",
		"Source/Zlib",
		"Source/deprecationmanager",
		"Source/OpenEXR/half",
		"Source/OpenEXR/iex",
		"Source/OpenEXR/ilmimf",
		"Source/OpenEXR/imath",
		"Source/OpenEXR/ilmthread",
    }

    files 
    { 
		"Source/*.h",
		"Source/deprecationmanager/*.h",
		"Source/deprecationmanager/*.cpp",
		"Source/FreeImage/*.cpp",
		"Source/metadata/*.cpp",
		"Source/FreeImagetoolkit/*.h",
		"Source/FreeImagetoolkit/*.cpp",	
    }
    
    excludes
    {
    }

	defines 
	{
		"WIN32",
		"_WIN32",
		"_WINDOWS",

		"OPJ_STATIC",
		"FREEIMAGE_LIB",
		"_CRT_SECURE_NO_DEPRECATE",
		"LIBRAW_NODLL",
	}
	
	links 
	{
		"Zlib",
		"OpenEXR",
		"LibTIFF4",
		"LibPNG",
		"LibOpenJpeg",
		"LibJPEG",
		"LibJXR",
		"LibWebP",
		"LibRaw", 
	}

    filter "configurations:Debug"
        defines { "DEBUG" }
		symbols "On" -- Generate debug symbols
        targetname "FreeImageLib"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations      	  
        targetname "FreeImageLib"

    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )

    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )

    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )
	filter{}
------------------------------------------------------------------------------------------------------------------------------------------------------- ===================================================================================================================================================================
  
project "FreeImagePlus"
	kind "SharedLib"
	language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Wrapper/FreeImagePlus/",
        "Source",
    }
        
    files 
    { 
        "Wrapper/FreeImagePlus/*.h",
        "Wrapper/FreeImagePlus/src/*.cpp",
    }
    
    defines 
    { 
        "WIN32",
		"_WIN32",
		"_WINDOWS",		

        "_USRDLL",
		"FIP_EXPORTS",
		"_CRT_SECURE_NO_DEPRECATE",
    }
	
	links
	{
		"FreeImage"
	}
    
    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "FreeImagePlus"
      
    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "FreeImagePlus"
	filter{}

    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )

    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )

    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )
	filter{}
-----------------------------------------------------------------------------------------------------------------------------------------------------

project "Zlib"
    kind "StaticLib"
	language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/Zlib"
    }
        
    files 
    { 
        "Source/Zlib/*.h",
        "Source/Zlib/*.c",
    }
    
    excludes
    {
        "Source/Zlib/example.c",
        "Source/Zlib/minigzip.c",
    }
    
    defines 
    { 
      "WIN32",
      "_LIB",
      "_CRT_SECURE_NO_DEPRECATE"
    }
    
    filter{"configurations:Debug"}
        defines { "_DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "Zlib"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "Zlib"
	filter{}      
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
    filter{}  
-----------------------------------------------------------------------------------------------------------------------------------------------------

project "OpenEXR"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/OpenEXR",
        "Source/OpenEXR/IlmImf",
        "Source/OpenEXR/Imath",
        "Source/OpenEXR/iex",
        "Source/OpenEXR/Half",
        "Source/OpenEXR/IlmThread",
        "Source/Zlib",
    }
        
    files 
    { 
        "Source/OpenEXR/Half/Half.h",
        "Source/OpenEXR/Half/Half.cpp",
        
        "Source/OpenEXR/iex/*.h",
        "Source/OpenEXR/iex/iexbaseexc.cpp",
        "Source/OpenEXR/iex/iexthrowerrnoexc.cpp",
      
        "Source/OpenEXR/IlmImf/*.h",
        "Source/OpenEXR/IlmImf/imfattribute.cpp",
        "Source/OpenEXR/IlmImf/imfb44compressor.cpp",
        "Source/OpenEXR/IlmImf/imfboxattribute.cpp",
        "Source/OpenEXR/IlmImf/imfchannellist.cpp",
        "Source/OpenEXR/IlmImf/imfchannellistattribute.cpp",
        "Source/OpenEXR/IlmImf/imfchromaticities.cpp",
        "Source/OpenEXR/IlmImf/imfchromaticitiesattribute.cpp",
        "Source/OpenEXR/IlmImf/imfcompressionattribute.cpp",
        "Source/OpenEXR/IlmImf/imfcompressor.cpp",
        "Source/OpenEXR/IlmImf/imfconvert.cpp",
        "Source/OpenEXR/IlmImf/imfcrgbafile.cpp",
        "Source/OpenEXR/IlmImf/imfdoubleattribute.cpp",
        "Source/OpenEXR/IlmImf/imfenvmap.cpp",
        "Source/OpenEXR/IlmImf/imfenvmapattribute.cpp",
        "Source/OpenEXR/IlmImf/imffloatattribute.cpp",
        "Source/OpenEXR/IlmImf/imfframebuffer.cpp",
        "Source/OpenEXR/IlmImf/imfframespersecond.cpp",
        "Source/OpenEXR/IlmImf/imfheader.cpp",
        "Source/OpenEXR/IlmImf/imfhuf.cpp",
        "Source/OpenEXR/IlmImf/imfinputfile.cpp",
        "Source/OpenEXR/IlmImf/imfintattribute.cpp",
        "Source/OpenEXR/IlmImf/imfio.cpp",
        "Source/OpenEXR/IlmImf/imfkeycode.cpp",
        "Source/OpenEXR/IlmImf/imfkeycodeattribute.cpp",
        "Source/OpenEXR/IlmImf/imflineorderattribute.cpp",
        "Source/OpenEXR/IlmImf/imflut.cpp",
        "Source/OpenEXR/IlmImf/imfmatrixattribute.cpp",
        "Source/OpenEXR/IlmImf/imfmisc.cpp",
        "Source/OpenEXR/IlmImf/imfopaqueattribute.cpp",
        "Source/OpenEXR/IlmImf/imfoutputfile.cpp",
        "Source/OpenEXR/IlmImf/imfpizcompressor.cpp",
        "Source/OpenEXR/IlmImf/imfpreviewimage.cpp",
        "Source/OpenEXR/IlmImf/imfpreviewimageattribute.cpp",
        "Source/OpenEXR/IlmImf/imfpxr24compressor.cpp",
        "Source/OpenEXR/IlmImf/imfrational.cpp",
        "Source/OpenEXR/IlmImf/imfrationalattribute.cpp",
        "Source/OpenEXR/IlmImf/imfrgbafile.cpp",
        "Source/OpenEXR/IlmImf/imfrgbayca.cpp",
        "Source/OpenEXR/IlmImf/imfrlecompressor.cpp",
        "Source/OpenEXR/IlmImf/imfscanlineinputfile.cpp",
        "Source/OpenEXR/IlmImf/imfstandardattributes.cpp",
        "Source/OpenEXR/IlmImf/imfstdio.cpp",
        "Source/OpenEXR/IlmImf/imfstringattribute.cpp",
        "Source/OpenEXR/IlmImf/imfstringvectorattribute.cpp",
        "Source/OpenEXR/IlmImf/imftestfile.cpp",
        "Source/OpenEXR/IlmImf/imfthreading.cpp",
        "Source/OpenEXR/IlmImf/imftiledescriptionattribute.cpp",
        "Source/OpenEXR/IlmImf/imftiledinputfile.cpp",
        "Source/OpenEXR/IlmImf/imftiledmisc.cpp",
        "Source/OpenEXR/IlmImf/imftiledoutputfile.cpp",
        "Source/OpenEXR/IlmImf/imftiledrgbafile.cpp",
        "Source/OpenEXR/IlmImf/imftileoffsets.cpp",
        "Source/OpenEXR/IlmImf/imftimecode.cpp",
        "Source/OpenEXR/IlmImf/imftimecodeattribute.cpp",
        "Source/OpenEXR/IlmImf/imfvecattribute.cpp",
        "Source/OpenEXR/IlmImf/imfversion.cpp",
        "Source/OpenEXR/IlmImf/imfwav.cpp",
        "Source/OpenEXR/IlmImf/imfzipcompressor.cpp",
      
        "Source/OpenEXR/IlmThread/*.h",
        "Source/OpenEXR/IlmThread/IlmThread.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadmutex.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadpool.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadsemaphore.cpp",
      
        "Source/OpenEXR/Imath/*.h",
        "Source/OpenEXR/Imath/Imathbox.cpp",
        "Source/OpenEXR/Imath/Imathcoloralgo.cpp",
        "Source/OpenEXR/Imath/Imathfun.cpp",
        "Source/OpenEXR/Imath/Imathmatrixalgo.cpp",
        "Source/OpenEXR/Imath/Imathrandom.cpp",
        "Source/OpenEXR/Imath/Imathshear.cpp",
        "Source/OpenEXR/Imath/Imathvec.cpp"      
    }
    
    excludes
    {
        "Source/OpenEXR/IlmThread/IlmThreadmutexposix.cpp",      
        "Source/OpenEXR/IlmThread/IlmThreadmutexwin32.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadsemaphoreposix.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadsemaphoreposixcompat.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadsemaphorewin32.cpp",
        "Source/OpenEXR/IlmThread/IlmThreadwin32.cpp",
    }
    
    defines 
    { 
        "WIN32",
        "_LIB",
        "_CRT_SECURE_NO_DEPRECATE"
    }
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "OpenEXR"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "OpenEXR"
	filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
    filter{}
-----------------------------------------------------------------------------------------------------------------------------------------------------

project "LibTIFF4"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibTIFF4",
        "Source/ZLib",
		"Source/LibJPEG",
    }
        
    files 
    { 
        "Source/LibTIFF4/*.h",
        "Source/LibTIFF4/*.c",
    }
    
    excludes
    {
        "Source/LibTIFF4/mkg3states.c",
        "Source/LibTIFF4/mkspans.c",
        "Source/LibTIFF4/tif_acorn.c",
        "Source/LibTIFF4/tif_atari.c",
        "Source/LibTIFF4/tif_apple.c",
        "Source/LibTIFF4/tif_msdos.c",
        "Source/LibTIFF4/tif_unix.c",
        "Source/LibTIFF4/tif_vms.c",
        "Source/LibTIFF4/tif_wince.c",
        "Source/LibTIFF4/tif_win3.c",
        "Source/LibTIFF4/tif_win32.c"
    }
    
    defines 
    { 
        "WIN32",
        "_LIB",
		"_CRT_SECURE_NO_DEPRECATE"
    }
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "libtiff"

	filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "libtiff"
	filter{}

    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )
	filter{}	
-----------------------------------------------------------------------------------------------------------------------------------------------------

project "LibPNG"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibPNG",
        "Source/Zlib"
    }
        
    files 
    { 
        "Source/LibPNG/*.h",
        "Source/LibPNG/*.c",
    }
    
    excludes
    {
    }
    
    defines 
    { 
        "WIN32",
        "_LIB",
        "_CRT_SECURE_NO_DEPRECATE"
    }
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "LibPNG"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "LibPNG"
	filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
	filter{}
-----------------------------------------------------------------------------------------------------------------------------------------------------        

project "LibOpenJpeg"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibOpenJpeg",
    }
        
    files 
    { 
        "Source/LibOpenJpeg/*.h",
        "Source/LibOpenJpeg/*.c",
    }
    
    excludes
    {
		"Source/t1_generate_luts.c"
    }
    
    defines 
    { 
        "WIN32",
        "_LIB",
		
        "OPJ_STATIC",
        "_CRT_SECURE_NO_DEPRECATE",
		"USE_JPIP",
    }
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "LibOpenJpeg"

    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "LibOpenJpeg"
	filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
	filter{}

-----------------------------------------------------------------------------------------------------------------------------------------------------        

project "LibJPEG"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibJPEG",
    }
        
    files 
    { 
        "Source/LibJPEG/*.h",
        "Source/LibJPEG/*.c",
    }
    
    excludes
    {
        "Source/LibJPEG/ansi2knr.c",
        "Source/LibJPEG/cderror.h",
        "Source/LibJPEG/cdjpeg.h",
        "Source/LibJPEG/cdjpeg.c",
        "Source/LibJPEG/cjpeg.c",
        "Source/LibJPEG/ckconfig.c",
        "Source/LibJPEG/djpeg.c",
        "Source/LibJPEG/example.c",
        "Source/LibJPEG/jmemdos.c",
        "Source/LibJPEG/jmemmac.c",
        "Source/LibJPEG/jmemname.c",
        "Source/LibJPEG/rd*.c",
        "Source/LibJPEG/wr*.c"
    }
    
    defines 
    { 
        "WIN32",
        "_LIB",
        "_CRT_SECURE_NO_DEPRECATE"
    }
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "LibJPEG"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "LibJPEG"
	filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
    filter{}  
-----------------------------------------------------------------------------------------------------------------------------------------------------        

project "LibJXR"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibJXR",
		"Source/LibJXR/jxrgluelib",
		"Source/LibJXR/image/sys",
    }
        
    files 
    { 
        "Source/LibJXR/**.h",
        "Source/LibJXR/**.c",
    }
    
    excludes
    {
    }
    
    defines 
    { 
        "WIN32",
        "_LIB",
		"DISABLE_PERF_MEASUREMENT"
    }
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "LibJXR"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "LibJXR"
	filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
    filter{}
-----------------------------------------------------------------------------------------------------------------------------------------------------        

project "LibWebP"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibWebP",
    }
        
    files 
    { 
        "Source/LibWebP/**.h",
        "Source/LibWebP/**.c",
    }
    
    excludes
    {
    }
    
    defines 
    { 
        "WIN32",
		"_WINDOWS",
        "_LIB",
	}
    
    filter{"configurations:Debug"}
        defines { "DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "LibWebP"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "LibWebP"
	filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )		
    filter{}
-----------------------------------------------------------------------------------------------------------------------------------------------------

project "LibRaw"
    kind "StaticLib"
    language "C++"
	cppdialect "C++11"
	characterset("ASCII")
    
    includedirs
    {
        "Source/LibRawLite",
		"Source/LibJPEG",
    }
        
    files 
    { 
        "Source/LibRawLite/internal/*.h",
        "Source/LibRawLite/internal/*.cpp",
        "Source/LibRawLite/libraw/*.h",
        "Source/LibRawLite/libraw/*.cpp",
        "Source/LibRawLite/src/**.h",
		"Source/LibRawLite/src/**.cpp",
    }
    
    excludes
    {
    }
    
    defines 
    { 
        "WIN32",
		"_LIB",
		"LIBRAW_NODLL",
		"USE_JPEG",
		"USE_X3FTOOLS",
		"_CRT_SECURE_NO_WARNINGS",
    }
    
    filter{"configurations:Debug"}
        defines { "_DEBUG" }
        symbols "On" -- Generate debug symbols
        targetname "LibRaw"
      
    filter{"configurations:Release"}
        defines { "NDEBUG" }
        optimize "On" -- Enable optimizations
        targetname "LibRaw"
    filter{}
	
    filter{"configurations:Debug", "architecture:x32" }
        targetdir ( "build/lib/x32/Debug" )

    filter{"configurations:Debug", "architecture:x64" }
        targetdir ( "build/lib/x64/Debug" )
        
    filter{"configurations:Release", "architecture:x32" }
        targetdir ( "build/lib/x32/Release" )
    
    filter{"configurations:Release", "architecture:x64" }
        targetdir ( "build/lib/x64/Release" )
	filter{}
-----------------------------------------------------------------------------------------------------------------------------------------------------
        
newaction 
{
    trigger     = "install",
    description = "Install FreeImage library",
    execute = function ()
        -- copy files, etc. here
        os.mkdir(prefix);
        os.mkdir(prefix .. "/x32");
        os.mkdir(prefix .. "/x64");

        -- Copy header files
        os.copyfile("Source/FreeImage.h", prefix .. "/FreeImage.h");
        os.copyfile("Wrapper/FreeImagePlus/FreeImagePlus.h", prefix .. "/FreeImagePlus.h");
      
        -- Library files created in Dist directory
        files = os.matchfiles("build/lib/x32/Debug/*.lib");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/x32/" .. path.getbasename(f) .. "_d.lib");
        end

        files = os.matchfiles("build/lib/x32/Release/*.lib");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/x32/" .. path.getname(f));
        end

        files = os.matchfiles("build/lib/x64/Debug/*.lib");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/x64/" .. path.getbasename(f) .. "_d.lib");
        end

        files = os.matchfiles("build/lib/x64/Release/*.lib");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/x64/" .. path.getname(f));
        end    

		files = os.matchfiles("build/lib/x64/Debug/*.dll");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/x64/" .. path.getbasename(f) .. "_d.dll");
        end

        files = os.matchfiles("build/lib/x64/Release/*.dll");
        for k, f in pairs(files) do
            os.copyfile(f, prefix .. "/x64/" .. path.getname(f));
        end    		
  end
}
      