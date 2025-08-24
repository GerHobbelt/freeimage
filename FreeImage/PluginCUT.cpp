// ==========================================================
// CUT Loader
//
// Design and implementation by
// - Floris van den Berg (flvdberg@wxs.nl)
//
// This file is part of FreeImage 3
//
// COVERED CODE IS PROVIDED UNDER THIS LICENSE ON AN "AS IS" BASIS, WITHOUT WARRANTY
// OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, WITHOUT LIMITATION, WARRANTIES
// THAT THE COVERED CODE IS FREE OF DEFECTS, MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE
// OR NON-INFRINGING. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE COVERED
// CODE IS WITH YOU. SHOULD ANY COVERED CODE PROVE DEFECTIVE IN ANY RESPECT, YOU (NOT
// THE INITIAL DEVELOPER OR ANY OTHER CONTRIBUTOR) ASSUME THE COST OF ANY NECESSARY
// SERVICING, REPAIR OR CORRECTION. THIS DISCLAIMER OF WARRANTY CONSTITUTES AN ESSENTIAL
// PART OF THIS LICENSE. NO USE OF ANY COVERED CODE IS AUTHORIZED HEREUNDER EXCEPT UNDER
// THIS DISCLAIMER.
//
// Use at your own risk!
// ==========================================================

#include "FreeImage.h"
#include "Utilities.h"

// ----------------------------------------------------------
//   Constants + headers
// ----------------------------------------------------------

#ifdef _WIN32
#pragma pack(push, 1)
#else
#pragma pack(1)
#endif

typedef struct tagCUTHEADER {
	short width;
	short height;
	int dummy;
} CUTHEADER;

#ifdef _WIN32
#pragma pack(pop)
#else
#pragma pack()
#endif

// ==========================================================
// Plugin Interface
// ==========================================================

static int s_format_id;

// ==========================================================
// Plugin Implementation
// ==========================================================

static const char * DLL_CALLCONV
Format() {
	return "CUT";
}

static const char * DLL_CALLCONV
Description() {
	return "Dr. Halo";
}

static const char * DLL_CALLCONV
Extension() {
	return "cut";
}

static const char * DLL_CALLCONV
RegExpr() {
	return nullptr;
}

static const char * DLL_CALLCONV
MimeType() {
	return "image/freeimage-cut";
}

static BOOL DLL_CALLCONV
Validate(FreeImageIO *io, fi_handle handle) {
	return FALSE;
}

static BOOL DLL_CALLCONV
SupportsExportDepth(int depth) {
	return FALSE;
}

static BOOL DLL_CALLCONV 
SupportsExportType(FREE_IMAGE_TYPE type) {
	return FALSE;
}

// ----------------------------------------------------------

static FIBITMAP * DLL_CALLCONV
Load(FreeImageIO *io, fi_handle handle, int page, int flags, void *data) {
	if (handle != nullptr) {
		CUTHEADER header;
		FIBITMAP *dib;

		// read the cut header

		io->read_proc(&header, 1, sizeof(CUTHEADER), handle);
#ifdef FREEIMAGE_BIGENDIAN
		SwapShort((uint16_t *)&header.width);
		SwapShort((uint16_t *)&header.height);
#endif

		if ((header.width == 0) || (header.height == 0))
			return nullptr;

		// allocate a new bitmap

		dib = FreeImage_Allocate(header.width, header.height, 8);

		if (dib == nullptr)
			return nullptr;

		// stuff it with a palette

		RGBQUAD *palette = FreeImage_GetPalette(dib);

		for (int j = 0; j < 256; ++j)
			palette[j].rgbBlue = palette[j].rgbGreen = palette[j].rgbRed = (uint8_t)j;

		// unpack the RLE bitmap bits

		uint8_t *bits = FreeImage_GetScanLine(dib, header.height - 1);

		int i = 0, k = 0;
		int pitch = FreeImage_GetPitch(dib);
		int size = header.width * header.height;
		uint8_t count = 0, run = 0;

		while (i < size) {
			io->read_proc(&count, 1, sizeof(uint8_t), handle);

			if (count == 0) {
				k = 0;
				bits -= pitch;

				// paint shop pro adds two useless bytes here...

				io->read_proc(&count, 1, sizeof(uint8_t), handle);
				io->read_proc(&count, 1, sizeof(uint8_t), handle);

				continue;
			}

			if (count & 0x80) {
				count &= ~(0x80);

				io->read_proc(&run, 1, sizeof(uint8_t), handle);

				memset(bits + k, run, count);
			} else {
				io->read_proc(&bits[k], count, sizeof(uint8_t), handle);
			}

			k += count;
			i += count;
		}

		return dib;		
	}

	return nullptr;
}

// ==========================================================
//   Init
// ==========================================================

void DLL_CALLCONV
InitCUT(Plugin *plugin, int format_id) {
	s_format_id = format_id;

	plugin->format_proc = Format;
	plugin->description_proc = Description;
	plugin->extension_proc = Extension;
	plugin->regexpr_proc = RegExpr;
	plugin->open_proc = nullptr;
	plugin->close_proc = nullptr;
	plugin->pagecount_proc = nullptr;
	plugin->pagecapability_proc = nullptr;
	plugin->load_proc = Load;
	plugin->save_proc = nullptr;
	plugin->validate_proc = Validate;
	plugin->mime_proc = MimeType;
	plugin->supports_export_bpp_proc = SupportsExportDepth;
	plugin->supports_export_type_proc = SupportsExportType;
	plugin->supports_icc_profiles_proc = nullptr;
}
