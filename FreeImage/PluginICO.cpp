// ==========================================================
// ICO Loader and Writer
//
// Design and implementation by
// - Floris van den Berg (flvdberg@wxs.nl)
// - Hervé Drolon (drolon@infonie.fr)
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

// These next two structs represent how the icon information is stored
// in an ICO file.

typedef struct tagICONHEADER {
	uint16_t			idReserved;   // reserved
	uint16_t			idType;       // resource type (1 for icons)
	uint16_t			idCount;      // how many images?
} ICONHEADER;

typedef struct tagICONDIRECTORYENTRY {
	uint8_t	bWidth;               // width of the image
	uint8_t	bHeight;              // height of the image (times 2)
	uint8_t	bColorCount;          // number of colors in image (0 if >=8bpp)
	uint8_t	bReserved;            // reserved
	uint16_t	wPlanes;              // color Planes
	uint16_t	wBitCount;            // bits per pixel
	uint32_t	dwBytesInRes;         // how many bytes in this resource?
	uint32_t	dwImageOffset;        // where in the file is this image
} ICONDIRENTRY;

#ifdef _WIN32
#pragma pack(pop)
#else
#pragma pack()
#endif

// ==========================================================
// Static helpers
// ==========================================================

/**  How wide, in bytes, would this many bits be, uint32_t aligned ?
*/
static int 
WidthBytes(int bits) {
	return ((((bits) + 31)>>5)<<2);
}

/** Calculates the size of a single icon image
@return Returns the size for that image
*/
static uint32_t 
CalculateImageSize(FIBITMAP* icon_dib) {
	uint32_t dwNumBytes = 0;

	unsigned colors		= FreeImage_GetColorsUsed(icon_dib);
	unsigned width		= FreeImage_GetWidth(icon_dib);
	unsigned height		= FreeImage_GetHeight(icon_dib);
	unsigned pitch		= FreeImage_GetPitch(icon_dib);

	dwNumBytes = sizeof( BITMAPINFOHEADER );	// header
	dwNumBytes += colors * sizeof(RGBQUAD);		// palette
	dwNumBytes += height * pitch;				// XOR mask
	dwNumBytes += height * WidthBytes(width);	// AND mask

	return dwNumBytes;
}

/** Calculates the file offset for an icon image
@return Returns the file offset for that image
*/
static uint32_t 
CalculateImageOffset(std::vector<FIBITMAP*>& vPages, int nIndex ) {
	uint32_t	dwSize;

    // calculate the ICO header size
    dwSize = sizeof(ICONHEADER); 
    // add the ICONDIRENTRY's
    dwSize += (uint32_t)( vPages.size() * sizeof(ICONDIRENTRY) );
    // add the sizes of the previous images
    for(int k = 0; k < nIndex; k++) {
		FIBITMAP *icon_dib = (FIBITMAP*)vPages[k];
		dwSize += CalculateImageSize(icon_dib);
	}

    return dwSize;
}

#ifdef FREEIMAGE_BIGENDIAN
static void
SwapInfoHeader(BITMAPINFOHEADER *header) {
	SwapLong(&header->biSize);
	SwapLong((uint32_t *)&header->biWidth);
	SwapLong((uint32_t *)&header->biHeight);
	SwapShort(&header->biPlanes);
	SwapShort(&header->biBitCount);
	SwapLong(&header->biCompression);
	SwapLong(&header->biSizeImage);
	SwapLong((uint32_t *)&header->biXPelsPerMeter);
	SwapLong((uint32_t *)&header->biYPelsPerMeter);
	SwapLong(&header->biClrUsed);
	SwapLong(&header->biClrImportant);
}

static void
SwapIconHeader(ICONHEADER *header) {
	SwapShort(&header->idReserved);
	SwapShort(&header->idType);
	SwapShort(&header->idCount);
}

static void
SwapIconDirEntries(ICONDIRENTRY *ent, int num) {
	while(num) {
		SwapShort(&ent->wPlanes);
		SwapShort(&ent->wBitCount);
		SwapLong(&ent->dwBytesInRes);
		SwapLong(&ent->dwImageOffset);
		num--;
		ent++;
	}
}
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
	return "ICO";
}

static const char * DLL_CALLCONV
Description() {
	return "Windows Icon";
}

static const char * DLL_CALLCONV
Extension() {
	return "ico";
}

static const char * DLL_CALLCONV
RegExpr() {
	return nullptr;
}

static const char * DLL_CALLCONV
MimeType() {
	return "image/x-icon";
}

static BOOL DLL_CALLCONV
Validate(FreeImageIO *io, fi_handle handle) {
	ICONHEADER icon_header;

	io->read_proc(&icon_header, sizeof(ICONHEADER), 1, handle);
#ifdef FREEIMAGE_BIGENDIAN
	SwapIconHeader(&icon_header);
#endif

	return ((icon_header.idReserved == 0) && (icon_header.idType == 1) && (icon_header.idCount > 0));
}

static BOOL DLL_CALLCONV
SupportsExportDepth(int depth) {
	return (
			(depth == 1) ||
			(depth == 4) ||
			(depth == 8) ||
			(depth == 16) ||
			(depth == 24) ||
			(depth == 32)
		);
}

static BOOL DLL_CALLCONV 
SupportsExportType(FREE_IMAGE_TYPE type) {
	return (type == FIT_BITMAP) ? TRUE : FALSE;
}

// ----------------------------------------------------------

static void * DLL_CALLCONV
Open(FreeImageIO *io, fi_handle handle, BOOL read) {
	ICONHEADER *lpIH = nullptr;

	// Allocate memory for the header structure
	if((lpIH = (ICONHEADER*)malloc( sizeof(ICONHEADER) )) == nullptr) 
		return nullptr;

	if (read) {
		// Read in the header
		io->read_proc(lpIH, 1, sizeof(ICONHEADER), handle);
#ifdef FREEIMAGE_BIGENDIAN
	SwapIconHeader(lpIH);
#endif

		if(!(lpIH->idReserved == 0) || !(lpIH->idType == 1)) {
			// Not an ICO file
			free(lpIH);
			return nullptr;
		}
	}
	else {
		// Fill the header
		lpIH->idReserved = 0;
		lpIH->idType = 1;
		lpIH->idCount = 0;
	}
	return lpIH;
}

static void DLL_CALLCONV
Close(FreeImageIO *io, fi_handle handle, void *data) {
	// free the header structure
	ICONHEADER *lpIH = (ICONHEADER*)data;
	free(lpIH);
}

// ----------------------------------------------------------

static int DLL_CALLCONV
PageCount(FreeImageIO *io, fi_handle handle, void *data) {
	ICONHEADER *lpIH = (ICONHEADER*)data;

	if(lpIH) {
		return lpIH->idCount;
	}
	return 1;
}

// ----------------------------------------------------------

static FIBITMAP * DLL_CALLCONV
Load(FreeImageIO *io, fi_handle handle, int page, int flags, void *data) {
	if (page == -1)
		page = 0;

	if (handle != nullptr) {
		FIBITMAP *dib = nullptr;

		// get the icon header
		ICONHEADER *icon_header = (ICONHEADER*)data;

		if (icon_header) {
			// load the icon descriptions
			ICONDIRENTRY *icon_list = (ICONDIRENTRY*)malloc(icon_header->idCount * sizeof(ICONDIRENTRY));
			io->seek_proc(handle, sizeof(ICONHEADER), SEEK_SET);
			io->read_proc(icon_list, icon_header->idCount * sizeof(ICONDIRENTRY), 1, handle);
#ifdef FREEIMAGE_BIGENDIAN
			SwapIconDirEntries(icon_list, icon_header->idCount);
#endif

			// load the requested icon
			if (page < icon_header->idCount) {
				// seek to the start of the bitmap data for the icon
				io->seek_proc(handle, 0, SEEK_SET);
				io->seek_proc(handle, icon_list[page].dwImageOffset, SEEK_CUR);

				// Vista icon support
				if((icon_list[page].bWidth == 0) && (icon_list[page].bHeight == 0)) {
					dib = FreeImage_LoadFromHandle(FIF_PNG, io, handle, 0);
					free(icon_list);
					return dib;
				}

				free(icon_list);

				// load the BITMAPINFOHEADER
				BITMAPINFOHEADER bmih;
				io->read_proc(&bmih, sizeof(BITMAPINFOHEADER), 1, handle);
#ifdef FREEIMAGE_BIGENDIAN
				SwapInfoHeader(&bmih);
#endif

				// allocate the bitmap
				int width  = bmih.biWidth;
				int height = bmih.biHeight / 2; // height == xor + and mask
				int bit_count = bmih.biBitCount;
				int line   = CalculateLine(width, bit_count);
				int pitch  = CalculatePitch(line);

				// allocate memory for one icon

				dib = FreeImage_Allocate(width, height, bit_count);

				if (dib == nullptr) {
					return nullptr;
				}

				if( bmih.biBitCount <= 8 ) {
					// read the palette data
					io->read_proc(FreeImage_GetPalette(dib), CalculateUsedPaletteEntries(bit_count) * sizeof(RGBQUAD), 1, handle);
#if FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_RGB
					RGBQUAD *pal = FreeImage_GetPalette(dib);
					for(int i = 0; i < CalculateUsedPaletteEntries(bit_count); i++) {
						INPLACESWAP(pal[i].rgbRed, pal[i].rgbBlue);
					}
#endif
				}

				// read the icon
				io->read_proc(FreeImage_GetBits(dib), height * pitch, 1, handle);

#ifdef FREEIMAGE_BIGENDIAN
				if (bit_count == 16) {
					for(int y = 0; y < height; y++) {
						uint16_t *pixel = (uint16_t *)FreeImage_GetScanLine(dib, y);
						for(int x = 0; x < width; x++) {
							SwapShort(pixel);
							pixel++;
						}
					}
				}
#endif
#if FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_RGB
				if (bit_count == 24 || bit_count == 32) {
					for(int y = 0; y < height; y++) {
						uint8_t *pixel = FreeImage_GetScanLine(dib, y);
						for(int x = 0; x < width; x++) {
							INPLACESWAP(pixel[0], pixel[2]);
							pixel += (bit_count>>3);
						}
					}
				}
#endif
				// bitmap has been loaded successfully!

				// convert to 32bpp and generate an alpha channel
				if((flags & ICO_MAKEALPHA) == ICO_MAKEALPHA) {
					FIBITMAP *dib32 = FreeImage_ConvertTo32Bits(dib);
					FreeImage_Unload(dib);

					if (dib32 == nullptr) {
						return nullptr;
					}

					int width_and	= WidthBytes(width);
					uint8_t *line_and	= (uint8_t *)malloc(width_and);

					if( line_and == nullptr ) {
						FreeImage_Unload(dib32);
						return nullptr;
					}

					//loop through each line of the AND-mask generating the alpha channel, invert XOR-mask
					for(int y = 0; y < height; y++) {
						RGBQUAD *quad = (RGBQUAD *)FreeImage_GetScanLine(dib32, y);
						io->read_proc(line_and, width_and, 1, handle);
						for(int x = 0; x < width; x++) {
							quad->rgbReserved = (line_and[x>>3] & (0x80 >> (x & 0x07))) != 0 ? 0 : 0xFF;
							if( quad->rgbReserved == 0 ) {
								quad->rgbBlue ^= 0xFF;
								quad->rgbGreen ^= 0xFF;
								quad->rgbRed ^= 0xFF;
							}
							quad++;
						}
					}
					free(line_and);

					return dib32;
				}

				return (FIBITMAP *)dib;

			} else {
				free(icon_list);
				FreeImage_OutputMessageProc(s_format_id, "Page doesn't exist");
			}
		} else {
			FreeImage_OutputMessageProc(s_format_id, "File is not an ICO file");
		}
	}

	return nullptr;
}

static BOOL DLL_CALLCONV
Save(FreeImageIO *io, FIBITMAP *dib, fi_handle handle, int page, int flags, void *data) {
	int k;

	if(dib) {
		// check format limits
		int w = FreeImage_GetWidth(dib);
		int h = FreeImage_GetHeight(dib);
		if((w < 16) || (w > 128) || (h < 16) || (h > 128)) {
			FreeImage_OutputMessageProc(s_format_id, "Unsupported icon size");
			return FALSE;
		}
	} else {
		return FALSE;
	}

	if (page == -1)
		page = 0;

	// get the icon header
	ICONHEADER *icon_header = (ICONHEADER*)data;

	if(icon_header) {

		std::vector<FIBITMAP*> vPages;
		FIBITMAP  *icon_dib = nullptr;

		// load all icons
		for(k = 0; k < icon_header->idCount; k++) {
			icon_dib = Load(io, handle, k, flags, data);
			vPages.push_back(icon_dib);
		}

		// add the page
		icon_dib = FreeImage_Clone(dib);
		vPages.push_back(icon_dib);
		icon_header->idCount++;

		// write the header
		io->seek_proc(handle, 0, SEEK_SET);
#ifdef FREEIMAGE_BIGENDIAN
		SwapIconHeader(icon_header);
#endif
		io->write_proc(icon_header, sizeof(ICONHEADER), 1, handle);
#ifdef FREEIMAGE_BIGENDIAN
		SwapIconHeader(icon_header);
#endif

		// write all icons
		// ...

		// save the icon descriptions
		ICONDIRENTRY *icon_list = (ICONDIRENTRY *)malloc(icon_header->idCount * sizeof(ICONDIRENTRY));
		memset(icon_list, 0, icon_header->idCount * sizeof(ICONDIRENTRY));
		BITMAPINFOHEADER *bmih;
		for(k = 0; k < icon_header->idCount; k++) {
			icon_dib = (FIBITMAP*)vPages[k];

			// convert internal format to ICONDIRENTRY
			bmih = FreeImage_GetInfoHeader(icon_dib);
			icon_list[k].bWidth			= (uint8_t)bmih->biWidth;
			icon_list[k].bHeight		= (uint8_t)bmih->biHeight;
			icon_list[k].bReserved		= 0;
			icon_list[k].wPlanes		= bmih->biPlanes;
			icon_list[k].wBitCount		= bmih->biBitCount;
			if( (icon_list[k].wPlanes * icon_list[k].wBitCount) >= 8 ) {
				icon_list[k].bColorCount = 0;
			} else {
				icon_list[k].bColorCount = (uint8_t)(1 << (icon_list[k].wPlanes * icon_list[k].wBitCount));
			}
			icon_list[k].dwBytesInRes	= CalculateImageSize(icon_dib);
			icon_list[k].dwImageOffset = CalculateImageOffset(vPages, k);
		}
#ifdef FREEIMAGE_BIGENDIAN
		SwapIconDirEntries(icon_list, icon_header->idCount);
#endif
		io->write_proc(icon_list, sizeof(ICONDIRENTRY) * icon_header->idCount, 1, handle);
		free(icon_list);

		// write the image bits for each image
		for(k = 0; k < icon_header->idCount; k++) {
			icon_dib = (FIBITMAP*)vPages[k];

			// write the BITMAPINFOHEADER
			bmih = FreeImage_GetInfoHeader(icon_dib);
			bmih->biHeight *= 2;	// height == xor + and mask
#ifdef FREEIMAGE_BIGENDIAN
			SwapInfoHeader(bmih);
#endif
			io->write_proc(bmih, sizeof(BITMAPINFOHEADER), 1, handle);
#ifdef FREEIMAGE_BIGENDIAN
			SwapInfoHeader(bmih);
#endif
			bmih->biHeight /= 2;

			// write the palette data
			if (FreeImage_GetPalette(icon_dib) != nullptr) {
				RGBQUAD *pal = FreeImage_GetPalette(icon_dib);
				FILE_BGRA bgra;
				for(unsigned i = 0; i < FreeImage_GetColorsUsed(icon_dib); i++) {
					bgra.b = pal[i].rgbBlue;
					bgra.g = pal[i].rgbGreen;
					bgra.r = pal[i].rgbRed;
					bgra.a = pal[i].rgbReserved;
					io->write_proc(&bgra, sizeof(FILE_BGRA), 1, handle);
				}
			}

			// write the bits
			int width		= bmih->biWidth;
			int height		= bmih->biHeight;
			int bit_count	= bmih->biBitCount;
			int line		= CalculateLine(width, bit_count);
			int pitch		= CalculatePitch(line);
			int size_xor	= height * pitch;
			int size_and	= height * WidthBytes(width);

			// XOR mask
#ifdef FREEIMAGE_BIGENDIAN
			if (bit_count == 16) {
				uint16_t pixel;
				for(int y = 0; y < FreeImage_GetHeight(icon_dib); y++) {
					uint8_t *line = FreeImage_GetScanLine(icon_dib, y);
					for(int x = 0; x < FreeImage_GetWidth(icon_dib); x++) {
						pixel = ((uint16_t *)line)[x];
						SwapShort(&pixel);
						if (io->write_proc(&pixel, sizeof(uint16_t), 1, handle) != 1)
							return FALSE;
					}
				}
			} else
#endif
#if FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_RGB
			if (bit_count == 24) {
				FILE_BGR bgr;
				for(int y = 0; y < FreeImage_GetHeight(icon_dib); y++) {
					uint8_t *line = FreeImage_GetScanLine(icon_dib, y);
					for(int x = 0; x < FreeImage_GetWidth(icon_dib); x++) {
						RGBTRIPLE *triple = ((RGBTRIPLE *)line)+x;
						bgr.b = triple->rgbtBlue;
						bgr.g = triple->rgbtGreen;
						bgr.r = triple->rgbtRed;
						if (io->write_proc(&bgr, sizeof(FILE_BGR), 1, handle) != 1)
							return FALSE;
					}
				}
			} else if (bit_count == 32) {
				FILE_BGRA bgra;
				for(int y = 0; y < FreeImage_GetHeight(icon_dib); y++) {
					uint8_t *line = FreeImage_GetScanLine(icon_dib, y);
					for(int x = 0; x < FreeImage_GetWidth(icon_dib); x++) {
						RGBQUAD *quad = ((RGBQUAD *)line)+x;
						bgra.b = quad->rgbBlue;
						bgra.g = quad->rgbGreen;
						bgra.r = quad->rgbRed;
						bgra.a = quad->rgbReserved;
						if (io->write_proc(&bgra, sizeof(FILE_BGRA), 1, handle) != 1)
							return FALSE;
					}
				}
			} else
#endif
#if defined(FREEIMAGE_BIGENDIAN) || FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_RGB
			{
#endif
				uint8_t *xor_mask = FreeImage_GetBits(icon_dib);
				io->write_proc(xor_mask, size_xor, 1, handle);
#if defined(FREEIMAGE_BIGENDIAN) || FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_RGB
			}
#endif
			// AND mask
			uint8_t *and_mask = (uint8_t*)malloc(size_and);

			if(FreeImage_IsTransparent(dib)) {

				if(bit_count == 32) {
					// create the AND mask from the alpha channel

					int width_and  = WidthBytes(width);
					uint8_t *and_bits = and_mask;

					// clear the mask
					memset(and_mask, 0, size_and);

					for(int y = 0; y < height; y++) {
						RGBQUAD *bits = (RGBQUAD*)FreeImage_GetScanLine(dib, y);

						for(int x = 0; x < width; x++) {
							if(bits[x].rgbReserved != 0xFF) {
								// set any transparent color to full transparency
								and_bits[x >> 3] |= (0x80 >> (x & 0x7)); 
							}
						}

						and_bits += width_and;
					}
				} 
				else if(bit_count <= 8) {
					// create the AND mask from the transparency table

					uint8_t *trns = FreeImage_GetTransparencyTable(dib);

					int width_and  = WidthBytes(width);
					uint8_t *and_bits = and_mask;

					// clear the mask
					memset(and_mask, 0, size_and);

					switch(FreeImage_GetBPP(dib)) {
						case 1:
						{
							for(int y = 0; y < height; y++) {
								uint8_t *bits = (uint8_t*)FreeImage_GetScanLine(dib, y);
								for(int x = 0; x < width; x++) {
									// get pixel at (x, y)
									uint8_t index = (bits[x >> 3] & (0x80 >> (x & 0x07))) != 0;
									if(trns[index] != 0xFF) {
										// set any transparent color to full transparency
										and_bits[x >> 3] |= (0x80 >> (x & 0x7)); 
									}
								}
								and_bits += width_and;
							}
						}
						break;

						case 4:
						{
							for(int y = 0; y < height; y++) {
								uint8_t *bits = (uint8_t*)FreeImage_GetScanLine(dib, y);
								for(int x = 0; x < width; x++) {
									// get pixel at (x, y)
									uint8_t shift = (uint8_t)((1 - x % 2) << 2);
									uint8_t index = (bits[x >> 1] & (0x0F << shift)) >> shift;
									if(trns[index] != 0xFF) {
										// set any transparent color to full transparency
										and_bits[x >> 3] |= (0x80 >> (x & 0x7)); 
									}
								}
								and_bits += width_and;
							}
						}
						break;

						case 8:
						{
							for(int y = 0; y < height; y++) {
								uint8_t *bits = (uint8_t*)FreeImage_GetScanLine(dib, y);
								for(int x = 0; x < width; x++) {
									// get pixel at (x, y)
									uint8_t index = bits[x];
									if(trns[index] != 0xFF) {
										// set any transparent color to full transparency
										and_bits[x >> 3] |= (0x80 >> (x & 0x7)); 
									}
								}
								and_bits += width_and;
							}
						}
						break;

					}
				}
			}
			else {
				// empty AND mask
				memset(and_mask, 0, size_and);
			}

			io->write_proc(and_mask, size_and, 1, handle);
			free(and_mask);

		}

		// free the vector class
		for(k = 0; k < icon_header->idCount; k++) {
			icon_dib = (FIBITMAP*)vPages[k];
			FreeImage_Unload(icon_dib);
		}

		return TRUE;
	}

	return FALSE;
}

// ==========================================================
//   Init
// ==========================================================

void DLL_CALLCONV
InitICO(Plugin *plugin, int format_id) {
	s_format_id = format_id;

	plugin->format_proc = Format;
	plugin->description_proc = Description;
	plugin->extension_proc = Extension;
	plugin->regexpr_proc = RegExpr;
	plugin->open_proc = Open;
	plugin->close_proc = Close;
	plugin->pagecount_proc = PageCount;
	plugin->pagecapability_proc = nullptr;
	plugin->load_proc = Load;
	plugin->save_proc = Save;
	plugin->validate_proc = Validate;
	plugin->mime_proc = MimeType;
	plugin->supports_export_bpp_proc = SupportsExportDepth;
	plugin->supports_export_type_proc = SupportsExportType;
	plugin->supports_icc_profiles_proc = nullptr;
}
