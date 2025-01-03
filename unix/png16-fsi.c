/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.9
 *
 * This file is not intended to be easily readable and contains a number of
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG
 * interface file instead.
 * ----------------------------------------------------------------------------- */
#include <stdio.h>
#include <string.h>
#include <stddef.h>
#include <math.h> /* required for special case floating point output */

// Do not edit below this line
// end-of-default-includes


#include <libpng16/png.h>
#ifdef __gnu_linux__
#undef stderr
extern struct _IO_FILE *stderr;
#endif

typedef enum{ NONE = -1, GFORTH = 0, SWIFTFORTH, VFX } SwigTargetSystem;
SwigTargetSystem swigTargetSystem = NONE;

unsigned char swigPrintStackComments = 1;

/* comments */
void swigNewline()
{
	printf( "\n" );
}

void swigComment( char *comment )
{
	printf( "\\ %s", comment );
}

/* generic print */
void swigPrint( char* gforth, char *swiftForth, char *vfx )
{
	if( swigTargetSystem == GFORTH )
		printf( "%s", gforth );
	else if( swigTargetSystem == SWIFTFORTH )
		printf( "%s", swiftForth );
	else if( swigTargetSystem == VFX )
		printf( "%s", vfx );
	printf( "\n" );
}
void swigPrintSystem( SwigTargetSystem targetSystem, char *text )
{
	if( targetSystem == swigTargetSystem )
	    printf( "%s\n", text );
}

/* constants */
void swigIntConstant( long constant, char *name )
{
	printf( "#%ld\tconstant %s\n", constant, name );
}

void swigUnsignedIntConstant( unsigned long constant, char *name )
{
	printf( "#%lu\tconstant %s\n", constant, name );
}

void swigLongConstant( long long constant, char *name )
{
	printf( "#%lld.\t2constant %s\n", constant, name );
}

void swigUnsignedLongConstant( unsigned long long constant, char *name )
{
	printf( "#%llu.\t2constant %s\n", constant, name );
}

void swigFloatConstant( double constant, char *name )
{
	char buffer[128];
	sprintf( buffer, "%f", constant );

	/* if the constant contains no exponent, add one */
	char *s;
	for( s = buffer; *s != 0; s++ )
		if( *s == 'e' || *s == 'E' )
			break;

	/* exponent found */
	if( *s != 0 )
		printf( "%s\tfconstant %s\n", buffer, name );
	/* no exponent */
	else {
		/* special class? */
		int class = fpclassify( constant );
		if( class == FP_INFINITE )
			printf( "%sInf\tfconstant %s\n", constant < 0.0f ? "-" : "+", name );
		else if( class == FP_NAN )
			printf( "NaN\tfconstant %s\n", name );
		else
			/* treat as generic float */
			printf( "%se0\tfconstant %s\n", buffer, name );
        }
}

void swigStringConstant( char* constant, char *name )
{
	char c;
	printf( ": %s s\\\" ", name );
	while(( c = *constant++ ))
	{
		switch(c)
		{
			case '\b': printf( "\\b" ); break;
			case '\n': printf( "\\n" ); break;
			case '\f': printf( "\\f" ); break;
			case '\r': printf( "\\r" ); break;
			case '\t': printf( "\\t" ); break;
			case '"' : printf( "\\q" ); break;
			default:
				if(c < 0x20)
					printf("\\x%02x", c);
				else
					printf("%c", c); break;
		}
	}
	printf(	"\" ;\n" );
}

/* structs */
void swigStructField( char *name, size_t offset, size_t size )
{
	printf( "\tdrop %zu %zu +field %s\n", offset, size, name );
}

/* functions */
void swigFunction( char* gforth, char *swiftForth, char *vfx, char *stackComment )
{
	if( swigTargetSystem == GFORTH )
		printf( "%s", gforth );
	else if( swigTargetSystem == SWIFTFORTH )
		printf( "%s", swiftForth );
	else if( swigTargetSystem == VFX )
		printf( "%s", vfx );

	if( swigPrintStackComments )
		printf( "%s", stackComment );

	printf( "\n" );
}

/* function pointers */
void swigFunctionPointer( char* gforth, char *swiftForth, char *vfx, char *stackComment )
{
	swigFunction( gforth, swiftForth, vfx, stackComment );
}

/* callbacks */
void swigCallback( char* gforth, char *swiftForth, char *vfx, char *stackComment )
{
	swigFunction( gforth, swiftForth, vfx, stackComment );
}

void swigUsage( char **argv )
{
	fprintf( stderr, "Usage: %s [-gforth|-swiftforth|-vfx]\n", argv[0] );
}

int main( int argc, char **argv )
{
	int i;

	/* check arguments */
	for( i = 1; i < argc; i++ )
		if( strcmp( argv[i], "-gforth" ) == 0 )
			swigTargetSystem = GFORTH;
		else if( strcmp( argv[i], "-swiftforth" ) == 0 )
			swigTargetSystem = SWIFTFORTH;
		else if( strcmp( argv[i], "-vfx" ) == 0 )
			swigTargetSystem = VFX;

	if( swigTargetSystem == NONE )
	{
		fprintf( stderr, "Error: no target system specified\n" );
		swigUsage( argv );
		return 1;
	}

	/* primer */
	printf( "\\ This file has been generated using SWIG and fsi,\n"
		"\\ and is already platform dependent, search for the corresponding\n"
		"\\ fsi-file to compile it where no one has compiled it before ;)\n"
		"\\ Forth systems have their own own dynamic loader and don't need addional C-Code.\n"
		"\\ That's why this file will just print normal forth-code once compiled\n"
		"\\ and can be used directly with include or require.\n"
		"\\ As all comments are stripped during the compilation, please\n"
		"\\ insert the copyright notice of the original file here.\n"
	);



	swigNewline();

	swigComment("----===< prefix >===-----\n");

	swigPrint( "c-library png16\ns\" png16\" add-lib\n\\c #include <libpng16/png.h>\n\\c #ifdef __gnu_linux__\n\\c #undef stderr\n\\c extern struct _IO_FILE *stderr;\n\\c #endif", "( none )", "( none )" );

	swigNewline();

	swigComment("----===< int constants >===-----\n");
	#ifdef CHAR_BIT
		swigIntConstant( CHAR_BIT, "CHAR_BIT" );
	#endif
	#ifdef UCHAR_MAX
		swigIntConstant( UCHAR_MAX, "UCHAR_MAX" );
	#endif
	#ifdef SHORT_MIN
		swigIntConstant( SHORT_MIN, "SHORT_MIN" );
	#endif
	#ifdef SHORT_MAX
		swigIntConstant( SHORT_MAX, "SHORT_MAX" );
	#endif
	#ifdef USHRT_MAX
		swigIntConstant( USHRT_MAX, "USHRT_MAX" );
	#endif
	#ifdef INT_MIN
		swigIntConstant( INT_MIN, "INT_MIN" );
	#endif
	#ifdef INT_MAX
		swigIntConstant( INT_MAX, "INT_MAX" );
	#endif
	#ifdef UINT_MAX
		swigUnsignedIntConstant( UINT_MAX, "UINT_MAX" );
	#endif
	#ifdef PNG_LIBPNG_VER_SHAREDLIB
		swigIntConstant( PNG_LIBPNG_VER_SHAREDLIB, "PNG_LIBPNG_VER_SHAREDLIB" );
	#endif
	#ifdef PNG_LIBPNG_VER_SONUM
		swigIntConstant( PNG_LIBPNG_VER_SONUM, "PNG_LIBPNG_VER_SONUM" );
	#endif
	#ifdef PNG_LIBPNG_VER_DLLNUM
		swigIntConstant( PNG_LIBPNG_VER_DLLNUM, "PNG_LIBPNG_VER_DLLNUM" );
	#endif
	#ifdef PNG_LIBPNG_VER_MAJOR
		swigIntConstant( PNG_LIBPNG_VER_MAJOR, "PNG_LIBPNG_VER_MAJOR" );
	#endif
	#ifdef PNG_LIBPNG_VER_MINOR
		swigIntConstant( PNG_LIBPNG_VER_MINOR, "PNG_LIBPNG_VER_MINOR" );
	#endif
	#ifdef PNG_LIBPNG_VER_RELEASE
		swigIntConstant( PNG_LIBPNG_VER_RELEASE, "PNG_LIBPNG_VER_RELEASE" );
	#endif
	#ifdef PNG_LIBPNG_VER_BUILD
		swigIntConstant( PNG_LIBPNG_VER_BUILD, "PNG_LIBPNG_VER_BUILD" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_ALPHA
		swigIntConstant( PNG_LIBPNG_BUILD_ALPHA, "PNG_LIBPNG_BUILD_ALPHA" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_BETA
		swigIntConstant( PNG_LIBPNG_BUILD_BETA, "PNG_LIBPNG_BUILD_BETA" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_RC
		swigIntConstant( PNG_LIBPNG_BUILD_RC, "PNG_LIBPNG_BUILD_RC" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_STABLE
		swigIntConstant( PNG_LIBPNG_BUILD_STABLE, "PNG_LIBPNG_BUILD_STABLE" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_RELEASE_STATUS_MASK
		swigIntConstant( PNG_LIBPNG_BUILD_RELEASE_STATUS_MASK, "PNG_LIBPNG_BUILD_RELEASE_STATUS_MASK" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_PATCH
		swigIntConstant( PNG_LIBPNG_BUILD_PATCH, "PNG_LIBPNG_BUILD_PATCH" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_PRIVATE
		swigIntConstant( PNG_LIBPNG_BUILD_PRIVATE, "PNG_LIBPNG_BUILD_PRIVATE" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_SPECIAL
		swigIntConstant( PNG_LIBPNG_BUILD_SPECIAL, "PNG_LIBPNG_BUILD_SPECIAL" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_BASE_TYPE
		swigIntConstant( PNG_LIBPNG_BUILD_BASE_TYPE, "PNG_LIBPNG_BUILD_BASE_TYPE" );
	#endif
	#ifdef PNG_LIBPNG_VER
		swigIntConstant( PNG_LIBPNG_VER, "PNG_LIBPNG_VER" );
	#endif
	#ifdef PNG_LIBPNG_BUILD_TYPE
		swigIntConstant( PNG_LIBPNG_BUILD_TYPE, "PNG_LIBPNG_BUILD_TYPE" );
	#endif
	#ifdef PNG_TEXT_COMPRESSION_NONE_WR
		swigIntConstant( PNG_TEXT_COMPRESSION_NONE_WR, "PNG_TEXT_COMPRESSION_NONE_WR" );
	#endif
	#ifdef PNG_TEXT_COMPRESSION_zTXt_WR
		swigIntConstant( PNG_TEXT_COMPRESSION_zTXt_WR, "PNG_TEXT_COMPRESSION_zTXt_WR" );
	#endif
	#ifdef PNG_TEXT_COMPRESSION_NONE
		swigIntConstant( PNG_TEXT_COMPRESSION_NONE, "PNG_TEXT_COMPRESSION_NONE" );
	#endif
	#ifdef PNG_TEXT_COMPRESSION_zTXt
		swigIntConstant( PNG_TEXT_COMPRESSION_zTXt, "PNG_TEXT_COMPRESSION_zTXt" );
	#endif
	#ifdef PNG_ITXT_COMPRESSION_NONE
		swigIntConstant( PNG_ITXT_COMPRESSION_NONE, "PNG_ITXT_COMPRESSION_NONE" );
	#endif
	#ifdef PNG_ITXT_COMPRESSION_zTXt
		swigIntConstant( PNG_ITXT_COMPRESSION_zTXt, "PNG_ITXT_COMPRESSION_zTXt" );
	#endif
	#ifdef PNG_TEXT_COMPRESSION_LAST
		swigIntConstant( PNG_TEXT_COMPRESSION_LAST, "PNG_TEXT_COMPRESSION_LAST" );
	#endif
	#ifdef PNG_HAVE_IHDR
		swigIntConstant( PNG_HAVE_IHDR, "PNG_HAVE_IHDR" );
	#endif
	#ifdef PNG_HAVE_PLTE
		swigIntConstant( PNG_HAVE_PLTE, "PNG_HAVE_PLTE" );
	#endif
	#ifdef PNG_AFTER_IDAT
		swigIntConstant( PNG_AFTER_IDAT, "PNG_AFTER_IDAT" );
	#endif
	#ifdef PNG_FP_1
		swigIntConstant( PNG_FP_1, "PNG_FP_1" );
	#endif
	#ifdef PNG_FP_HALF
		swigIntConstant( PNG_FP_HALF, "PNG_FP_HALF" );
	#endif
	#ifdef PNG_COLOR_MASK_PALETTE
		swigIntConstant( PNG_COLOR_MASK_PALETTE, "PNG_COLOR_MASK_PALETTE" );
	#endif
	#ifdef PNG_COLOR_MASK_COLOR
		swigIntConstant( PNG_COLOR_MASK_COLOR, "PNG_COLOR_MASK_COLOR" );
	#endif
	#ifdef PNG_COLOR_MASK_ALPHA
		swigIntConstant( PNG_COLOR_MASK_ALPHA, "PNG_COLOR_MASK_ALPHA" );
	#endif
	#ifdef PNG_COLOR_TYPE_GRAY
		swigIntConstant( PNG_COLOR_TYPE_GRAY, "PNG_COLOR_TYPE_GRAY" );
	#endif
	#ifdef PNG_COLOR_TYPE_PALETTE
		swigIntConstant( PNG_COLOR_TYPE_PALETTE, "PNG_COLOR_TYPE_PALETTE" );
	#endif
	#ifdef PNG_COLOR_TYPE_RGB
		swigIntConstant( PNG_COLOR_TYPE_RGB, "PNG_COLOR_TYPE_RGB" );
	#endif
	#ifdef PNG_COLOR_TYPE_RGB_ALPHA
		swigIntConstant( PNG_COLOR_TYPE_RGB_ALPHA, "PNG_COLOR_TYPE_RGB_ALPHA" );
	#endif
	#ifdef PNG_COLOR_TYPE_GRAY_ALPHA
		swigIntConstant( PNG_COLOR_TYPE_GRAY_ALPHA, "PNG_COLOR_TYPE_GRAY_ALPHA" );
	#endif
	#ifdef PNG_COLOR_TYPE_RGBA
		swigIntConstant( PNG_COLOR_TYPE_RGBA, "PNG_COLOR_TYPE_RGBA" );
	#endif
	#ifdef PNG_COLOR_TYPE_GA
		swigIntConstant( PNG_COLOR_TYPE_GA, "PNG_COLOR_TYPE_GA" );
	#endif
	#ifdef PNG_COMPRESSION_TYPE_BASE
		swigIntConstant( PNG_COMPRESSION_TYPE_BASE, "PNG_COMPRESSION_TYPE_BASE" );
	#endif
	#ifdef PNG_COMPRESSION_TYPE_DEFAULT
		swigIntConstant( PNG_COMPRESSION_TYPE_DEFAULT, "PNG_COMPRESSION_TYPE_DEFAULT" );
	#endif
	#ifdef PNG_FILTER_TYPE_BASE
		swigIntConstant( PNG_FILTER_TYPE_BASE, "PNG_FILTER_TYPE_BASE" );
	#endif
	#ifdef PNG_INTRAPIXEL_DIFFERENCING
		swigIntConstant( PNG_INTRAPIXEL_DIFFERENCING, "PNG_INTRAPIXEL_DIFFERENCING" );
	#endif
	#ifdef PNG_FILTER_TYPE_DEFAULT
		swigIntConstant( PNG_FILTER_TYPE_DEFAULT, "PNG_FILTER_TYPE_DEFAULT" );
	#endif
	#ifdef PNG_INTERLACE_NONE
		swigIntConstant( PNG_INTERLACE_NONE, "PNG_INTERLACE_NONE" );
	#endif
	#ifdef PNG_INTERLACE_ADAM7
		swigIntConstant( PNG_INTERLACE_ADAM7, "PNG_INTERLACE_ADAM7" );
	#endif
	#ifdef PNG_INTERLACE_LAST
		swigIntConstant( PNG_INTERLACE_LAST, "PNG_INTERLACE_LAST" );
	#endif
	#ifdef PNG_OFFSET_PIXEL
		swigIntConstant( PNG_OFFSET_PIXEL, "PNG_OFFSET_PIXEL" );
	#endif
	#ifdef PNG_OFFSET_MICROMETER
		swigIntConstant( PNG_OFFSET_MICROMETER, "PNG_OFFSET_MICROMETER" );
	#endif
	#ifdef PNG_OFFSET_LAST
		swigIntConstant( PNG_OFFSET_LAST, "PNG_OFFSET_LAST" );
	#endif
	#ifdef PNG_EQUATION_LINEAR
		swigIntConstant( PNG_EQUATION_LINEAR, "PNG_EQUATION_LINEAR" );
	#endif
	#ifdef PNG_EQUATION_BASE_E
		swigIntConstant( PNG_EQUATION_BASE_E, "PNG_EQUATION_BASE_E" );
	#endif
	#ifdef PNG_EQUATION_ARBITRARY
		swigIntConstant( PNG_EQUATION_ARBITRARY, "PNG_EQUATION_ARBITRARY" );
	#endif
	#ifdef PNG_EQUATION_HYPERBOLIC
		swigIntConstant( PNG_EQUATION_HYPERBOLIC, "PNG_EQUATION_HYPERBOLIC" );
	#endif
	#ifdef PNG_EQUATION_LAST
		swigIntConstant( PNG_EQUATION_LAST, "PNG_EQUATION_LAST" );
	#endif
	#ifdef PNG_SCALE_UNKNOWN
		swigIntConstant( PNG_SCALE_UNKNOWN, "PNG_SCALE_UNKNOWN" );
	#endif
	#ifdef PNG_SCALE_METER
		swigIntConstant( PNG_SCALE_METER, "PNG_SCALE_METER" );
	#endif
	#ifdef PNG_SCALE_RADIAN
		swigIntConstant( PNG_SCALE_RADIAN, "PNG_SCALE_RADIAN" );
	#endif
	#ifdef PNG_SCALE_LAST
		swigIntConstant( PNG_SCALE_LAST, "PNG_SCALE_LAST" );
	#endif
	#ifdef PNG_RESOLUTION_UNKNOWN
		swigIntConstant( PNG_RESOLUTION_UNKNOWN, "PNG_RESOLUTION_UNKNOWN" );
	#endif
	#ifdef PNG_RESOLUTION_METER
		swigIntConstant( PNG_RESOLUTION_METER, "PNG_RESOLUTION_METER" );
	#endif
	#ifdef PNG_RESOLUTION_LAST
		swigIntConstant( PNG_RESOLUTION_LAST, "PNG_RESOLUTION_LAST" );
	#endif
	#ifdef PNG_sRGB_INTENT_PERCEPTUAL
		swigIntConstant( PNG_sRGB_INTENT_PERCEPTUAL, "PNG_sRGB_INTENT_PERCEPTUAL" );
	#endif
	#ifdef PNG_sRGB_INTENT_RELATIVE
		swigIntConstant( PNG_sRGB_INTENT_RELATIVE, "PNG_sRGB_INTENT_RELATIVE" );
	#endif
	#ifdef PNG_sRGB_INTENT_SATURATION
		swigIntConstant( PNG_sRGB_INTENT_SATURATION, "PNG_sRGB_INTENT_SATURATION" );
	#endif
	#ifdef PNG_sRGB_INTENT_ABSOLUTE
		swigIntConstant( PNG_sRGB_INTENT_ABSOLUTE, "PNG_sRGB_INTENT_ABSOLUTE" );
	#endif
	#ifdef PNG_sRGB_INTENT_LAST
		swigIntConstant( PNG_sRGB_INTENT_LAST, "PNG_sRGB_INTENT_LAST" );
	#endif
	#ifdef PNG_KEYWORD_MAX_LENGTH
		swigIntConstant( PNG_KEYWORD_MAX_LENGTH, "PNG_KEYWORD_MAX_LENGTH" );
	#endif
	#ifdef PNG_MAX_PALETTE_LENGTH
		swigIntConstant( PNG_MAX_PALETTE_LENGTH, "PNG_MAX_PALETTE_LENGTH" );
	#endif
	#ifdef PNG_INFO_gAMA
		swigUnsignedIntConstant( PNG_INFO_gAMA, "PNG_INFO_gAMA" );
	#endif
	#ifdef PNG_INFO_sBIT
		swigUnsignedIntConstant( PNG_INFO_sBIT, "PNG_INFO_sBIT" );
	#endif
	#ifdef PNG_INFO_cHRM
		swigUnsignedIntConstant( PNG_INFO_cHRM, "PNG_INFO_cHRM" );
	#endif
	#ifdef PNG_INFO_PLTE
		swigUnsignedIntConstant( PNG_INFO_PLTE, "PNG_INFO_PLTE" );
	#endif
	#ifdef PNG_INFO_tRNS
		swigUnsignedIntConstant( PNG_INFO_tRNS, "PNG_INFO_tRNS" );
	#endif
	#ifdef PNG_INFO_bKGD
		swigUnsignedIntConstant( PNG_INFO_bKGD, "PNG_INFO_bKGD" );
	#endif
	#ifdef PNG_INFO_hIST
		swigUnsignedIntConstant( PNG_INFO_hIST, "PNG_INFO_hIST" );
	#endif
	#ifdef PNG_INFO_pHYs
		swigUnsignedIntConstant( PNG_INFO_pHYs, "PNG_INFO_pHYs" );
	#endif
	#ifdef PNG_INFO_oFFs
		swigUnsignedIntConstant( PNG_INFO_oFFs, "PNG_INFO_oFFs" );
	#endif
	#ifdef PNG_INFO_tIME
		swigUnsignedIntConstant( PNG_INFO_tIME, "PNG_INFO_tIME" );
	#endif
	#ifdef PNG_INFO_pCAL
		swigUnsignedIntConstant( PNG_INFO_pCAL, "PNG_INFO_pCAL" );
	#endif
	#ifdef PNG_INFO_sRGB
		swigUnsignedIntConstant( PNG_INFO_sRGB, "PNG_INFO_sRGB" );
	#endif
	#ifdef PNG_INFO_iCCP
		swigUnsignedIntConstant( PNG_INFO_iCCP, "PNG_INFO_iCCP" );
	#endif
	#ifdef PNG_INFO_sPLT
		swigUnsignedIntConstant( PNG_INFO_sPLT, "PNG_INFO_sPLT" );
	#endif
	#ifdef PNG_INFO_sCAL
		swigUnsignedIntConstant( PNG_INFO_sCAL, "PNG_INFO_sCAL" );
	#endif
	#ifdef PNG_INFO_IDAT
		swigUnsignedIntConstant( PNG_INFO_IDAT, "PNG_INFO_IDAT" );
	#endif
	#ifdef PNG_INFO_eXIf
		swigUnsignedIntConstant( PNG_INFO_eXIf, "PNG_INFO_eXIf" );
	#endif
	#ifdef PNG_TRANSFORM_IDENTITY
		swigIntConstant( PNG_TRANSFORM_IDENTITY, "PNG_TRANSFORM_IDENTITY" );
	#endif
	#ifdef PNG_TRANSFORM_STRIP_16
		swigIntConstant( PNG_TRANSFORM_STRIP_16, "PNG_TRANSFORM_STRIP_16" );
	#endif
	#ifdef PNG_TRANSFORM_STRIP_ALPHA
		swigIntConstant( PNG_TRANSFORM_STRIP_ALPHA, "PNG_TRANSFORM_STRIP_ALPHA" );
	#endif
	#ifdef PNG_TRANSFORM_PACKING
		swigIntConstant( PNG_TRANSFORM_PACKING, "PNG_TRANSFORM_PACKING" );
	#endif
	#ifdef PNG_TRANSFORM_PACKSWAP
		swigIntConstant( PNG_TRANSFORM_PACKSWAP, "PNG_TRANSFORM_PACKSWAP" );
	#endif
	#ifdef PNG_TRANSFORM_EXPAND
		swigIntConstant( PNG_TRANSFORM_EXPAND, "PNG_TRANSFORM_EXPAND" );
	#endif
	#ifdef PNG_TRANSFORM_INVERT_MONO
		swigIntConstant( PNG_TRANSFORM_INVERT_MONO, "PNG_TRANSFORM_INVERT_MONO" );
	#endif
	#ifdef PNG_TRANSFORM_SHIFT
		swigIntConstant( PNG_TRANSFORM_SHIFT, "PNG_TRANSFORM_SHIFT" );
	#endif
	#ifdef PNG_TRANSFORM_BGR
		swigIntConstant( PNG_TRANSFORM_BGR, "PNG_TRANSFORM_BGR" );
	#endif
	#ifdef PNG_TRANSFORM_SWAP_ALPHA
		swigIntConstant( PNG_TRANSFORM_SWAP_ALPHA, "PNG_TRANSFORM_SWAP_ALPHA" );
	#endif
	#ifdef PNG_TRANSFORM_SWAP_ENDIAN
		swigIntConstant( PNG_TRANSFORM_SWAP_ENDIAN, "PNG_TRANSFORM_SWAP_ENDIAN" );
	#endif
	#ifdef PNG_TRANSFORM_INVERT_ALPHA
		swigIntConstant( PNG_TRANSFORM_INVERT_ALPHA, "PNG_TRANSFORM_INVERT_ALPHA" );
	#endif
	#ifdef PNG_TRANSFORM_STRIP_FILLER
		swigIntConstant( PNG_TRANSFORM_STRIP_FILLER, "PNG_TRANSFORM_STRIP_FILLER" );
	#endif
	#ifdef PNG_TRANSFORM_STRIP_FILLER_BEFORE
		swigIntConstant( PNG_TRANSFORM_STRIP_FILLER_BEFORE, "PNG_TRANSFORM_STRIP_FILLER_BEFORE" );
	#endif
	#ifdef PNG_TRANSFORM_STRIP_FILLER_AFTER
		swigIntConstant( PNG_TRANSFORM_STRIP_FILLER_AFTER, "PNG_TRANSFORM_STRIP_FILLER_AFTER" );
	#endif
	#ifdef PNG_TRANSFORM_GRAY_TO_RGB
		swigIntConstant( PNG_TRANSFORM_GRAY_TO_RGB, "PNG_TRANSFORM_GRAY_TO_RGB" );
	#endif
	#ifdef PNG_TRANSFORM_EXPAND_16
		swigIntConstant( PNG_TRANSFORM_EXPAND_16, "PNG_TRANSFORM_EXPAND_16" );
	#endif
	#ifdef PNG_FLAG_MNG_EMPTY_PLTE
		swigIntConstant( PNG_FLAG_MNG_EMPTY_PLTE, "PNG_FLAG_MNG_EMPTY_PLTE" );
	#endif
	#ifdef PNG_FLAG_MNG_FILTER_64
		swigIntConstant( PNG_FLAG_MNG_FILTER_64, "PNG_FLAG_MNG_FILTER_64" );
	#endif
	#ifdef PNG_ALL_MNG_FEATURES
		swigIntConstant( PNG_ALL_MNG_FEATURES, "PNG_ALL_MNG_FEATURES" );
	#endif
	#ifdef PNG_CRC_DEFAULT
		swigIntConstant( PNG_CRC_DEFAULT, "PNG_CRC_DEFAULT" );
	#endif
	#ifdef PNG_CRC_ERROR_QUIT
		swigIntConstant( PNG_CRC_ERROR_QUIT, "PNG_CRC_ERROR_QUIT" );
	#endif
	#ifdef PNG_CRC_WARN_DISCARD
		swigIntConstant( PNG_CRC_WARN_DISCARD, "PNG_CRC_WARN_DISCARD" );
	#endif
	#ifdef PNG_CRC_WARN_USE
		swigIntConstant( PNG_CRC_WARN_USE, "PNG_CRC_WARN_USE" );
	#endif
	#ifdef PNG_CRC_QUIET_USE
		swigIntConstant( PNG_CRC_QUIET_USE, "PNG_CRC_QUIET_USE" );
	#endif
	#ifdef PNG_CRC_NO_CHANGE
		swigIntConstant( PNG_CRC_NO_CHANGE, "PNG_CRC_NO_CHANGE" );
	#endif
	#ifdef PNG_NO_FILTERS
		swigIntConstant( PNG_NO_FILTERS, "PNG_NO_FILTERS" );
	#endif
	#ifdef PNG_FILTER_NONE
		swigIntConstant( PNG_FILTER_NONE, "PNG_FILTER_NONE" );
	#endif
	#ifdef PNG_FILTER_SUB
		swigIntConstant( PNG_FILTER_SUB, "PNG_FILTER_SUB" );
	#endif
	#ifdef PNG_FILTER_UP
		swigIntConstant( PNG_FILTER_UP, "PNG_FILTER_UP" );
	#endif
	#ifdef PNG_FILTER_AVG
		swigIntConstant( PNG_FILTER_AVG, "PNG_FILTER_AVG" );
	#endif
	#ifdef PNG_FILTER_PAETH
		swigIntConstant( PNG_FILTER_PAETH, "PNG_FILTER_PAETH" );
	#endif
	#ifdef PNG_FAST_FILTERS
		swigIntConstant( PNG_FAST_FILTERS, "PNG_FAST_FILTERS" );
	#endif
	#ifdef PNG_ALL_FILTERS
		swigIntConstant( PNG_ALL_FILTERS, "PNG_ALL_FILTERS" );
	#endif
	#ifdef PNG_FILTER_VALUE_NONE
		swigIntConstant( PNG_FILTER_VALUE_NONE, "PNG_FILTER_VALUE_NONE" );
	#endif
	#ifdef PNG_FILTER_VALUE_SUB
		swigIntConstant( PNG_FILTER_VALUE_SUB, "PNG_FILTER_VALUE_SUB" );
	#endif
	#ifdef PNG_FILTER_VALUE_UP
		swigIntConstant( PNG_FILTER_VALUE_UP, "PNG_FILTER_VALUE_UP" );
	#endif
	#ifdef PNG_FILTER_VALUE_AVG
		swigIntConstant( PNG_FILTER_VALUE_AVG, "PNG_FILTER_VALUE_AVG" );
	#endif
	#ifdef PNG_FILTER_VALUE_PAETH
		swigIntConstant( PNG_FILTER_VALUE_PAETH, "PNG_FILTER_VALUE_PAETH" );
	#endif
	#ifdef PNG_FILTER_VALUE_LAST
		swigIntConstant( PNG_FILTER_VALUE_LAST, "PNG_FILTER_VALUE_LAST" );
	#endif
	#ifdef PNG_DESTROY_WILL_FREE_DATA
		swigIntConstant( PNG_DESTROY_WILL_FREE_DATA, "PNG_DESTROY_WILL_FREE_DATA" );
	#endif
	#ifdef PNG_SET_WILL_FREE_DATA
		swigIntConstant( PNG_SET_WILL_FREE_DATA, "PNG_SET_WILL_FREE_DATA" );
	#endif
	#ifdef PNG_USER_WILL_FREE_DATA
		swigIntConstant( PNG_USER_WILL_FREE_DATA, "PNG_USER_WILL_FREE_DATA" );
	#endif
	#ifdef PNG_FREE_HIST
		swigUnsignedIntConstant( PNG_FREE_HIST, "PNG_FREE_HIST" );
	#endif
	#ifdef PNG_FREE_ICCP
		swigUnsignedIntConstant( PNG_FREE_ICCP, "PNG_FREE_ICCP" );
	#endif
	#ifdef PNG_FREE_SPLT
		swigUnsignedIntConstant( PNG_FREE_SPLT, "PNG_FREE_SPLT" );
	#endif
	#ifdef PNG_FREE_ROWS
		swigUnsignedIntConstant( PNG_FREE_ROWS, "PNG_FREE_ROWS" );
	#endif
	#ifdef PNG_FREE_PCAL
		swigUnsignedIntConstant( PNG_FREE_PCAL, "PNG_FREE_PCAL" );
	#endif
	#ifdef PNG_FREE_SCAL
		swigUnsignedIntConstant( PNG_FREE_SCAL, "PNG_FREE_SCAL" );
	#endif
	#ifdef PNG_FREE_PLTE
		swigUnsignedIntConstant( PNG_FREE_PLTE, "PNG_FREE_PLTE" );
	#endif
	#ifdef PNG_FREE_TRNS
		swigUnsignedIntConstant( PNG_FREE_TRNS, "PNG_FREE_TRNS" );
	#endif
	#ifdef PNG_FREE_TEXT
		swigUnsignedIntConstant( PNG_FREE_TEXT, "PNG_FREE_TEXT" );
	#endif
	#ifdef PNG_FREE_EXIF
		swigUnsignedIntConstant( PNG_FREE_EXIF, "PNG_FREE_EXIF" );
	#endif
	#ifdef PNG_FREE_ALL
		swigUnsignedIntConstant( PNG_FREE_ALL, "PNG_FREE_ALL" );
	#endif
	#ifdef PNG_FREE_MUL
		swigUnsignedIntConstant( PNG_FREE_MUL, "PNG_FREE_MUL" );
	#endif
	#ifdef PNG_HANDLE_CHUNK_AS_DEFAULT
		swigIntConstant( PNG_HANDLE_CHUNK_AS_DEFAULT, "PNG_HANDLE_CHUNK_AS_DEFAULT" );
	#endif
	#ifdef PNG_HANDLE_CHUNK_NEVER
		swigIntConstant( PNG_HANDLE_CHUNK_NEVER, "PNG_HANDLE_CHUNK_NEVER" );
	#endif
	#ifdef PNG_HANDLE_CHUNK_IF_SAFE
		swigIntConstant( PNG_HANDLE_CHUNK_IF_SAFE, "PNG_HANDLE_CHUNK_IF_SAFE" );
	#endif
	#ifdef PNG_HANDLE_CHUNK_ALWAYS
		swigIntConstant( PNG_HANDLE_CHUNK_ALWAYS, "PNG_HANDLE_CHUNK_ALWAYS" );
	#endif
	#ifdef PNG_HANDLE_CHUNK_LAST
		swigIntConstant( PNG_HANDLE_CHUNK_LAST, "PNG_HANDLE_CHUNK_LAST" );
	#endif
	#ifdef PNG_INTERLACE_ADAM7_PASSES
		swigIntConstant( PNG_INTERLACE_ADAM7_PASSES, "PNG_INTERLACE_ADAM7_PASSES" );
	#endif

	swigNewline();

	swigComment("-------===< structs >===--------\n");

	swigComment("struct png_color_struct\n");
	printf( "begin-structure png_color\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_color_struct ) );

	swigComment("struct png_color_16_struct\n");
	printf( "begin-structure png_color_16\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_color_16_struct ) );

	swigComment("struct png_color_8_struct\n");
	printf( "begin-structure png_color_8\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_color_8_struct ) );

	swigComment("struct png_sPLT_entry_struct\n");
	printf( "begin-structure png_sPLT_entry\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_sPLT_entry_struct ) );

	swigComment("struct png_sPLT_struct\n");
	printf( "begin-structure png_sPLT_t\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_sPLT_struct ) );

	swigComment("struct png_time_struct\n");
	printf( "begin-structure png_time\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_time_struct ) );

	swigComment("struct png_row_info_struct\n");
	printf( "begin-structure png_row_info\n" );
	printf( "drop %zu end-structure\n", sizeof( struct png_row_info_struct ) );

	swigNewline();

	swigComment("------===< callbacks >===-------\n");
	swigCallback( "c-callback png_error_ptr: a s -- void", "", "", "	( <noname> <noname> -- )" );
	swigCallback( "c-callback png_rw_ptr: a a u -- void", "", "", "	( <noname> <noname> <noname> -- )" );
	swigCallback( "c-callback png_flush_ptr: a -- void", "", "", "	( <noname> -- )" );
	swigCallback( "c-callback png_read_status_ptr: a u n -- void", "", "", "	( <noname> <noname> <noname> -- )" );
	swigCallback( "c-callback png_write_status_ptr: a u n -- void", "", "", "	( <noname> <noname> <noname> -- )" );
	swigCallback( "c-callback png_malloc_ptr: a u -- a", "", "", "	( <noname> <noname> -- )" );
	swigCallback( "c-callback png_free_ptr: a a -- void", "", "", "	( <noname> <noname> -- )" );

	swigNewline();

	swigComment("------===< functions >===-------\n");
	swigFunction( "c-function png_access_version_number png_access_version_number  -- u", "FUNCTION: png_access_version_number (  -- u )", "EXTERN: \"C\" int png_access_version_number(  );", "	( -- )" );
	swigFunction( "c-function png_set_sig_bytes png_set_sig_bytes a n -- void", "FUNCTION: png_set_sig_bytes ( png_ptr num_bytes -- void )", "EXTERN: \"C\" void png_set_sig_bytes( void * png_ptr, int num_bytes );", "	( png_ptr num_bytes -- )" );
	swigFunction( "c-function png_sig_cmp png_sig_cmp a u u -- n", "FUNCTION: png_sig_cmp ( sig start num_to_check -- n )", "EXTERN: \"C\" int png_sig_cmp( void * sig, long start, long num_to_check );", "	( sig start num_to_check -- )" );
	swigFunction( "c-function png_create_read_struct png_create_read_struct s a a a -- a", "FUNCTION: png_create_read_struct ( user_png_ver error_ptr error_fn warn_fn -- a )", "EXTERN: \"C\" void * png_create_read_struct( char * user_png_ver, void * error_ptr, void * error_fn, void * warn_fn );", "	( user_png_ver error_ptr error_fn warn_fn -- )" );
	swigFunction( "c-function png_create_write_struct png_create_write_struct s a a a -- a", "FUNCTION: png_create_write_struct ( user_png_ver error_ptr error_fn warn_fn -- a )", "EXTERN: \"C\" void * png_create_write_struct( char * user_png_ver, void * error_ptr, void * error_fn, void * warn_fn );", "	( user_png_ver error_ptr error_fn warn_fn -- )" );
	swigFunction( "c-function png_get_compression_buffer_size png_get_compression_buffer_size a -- u", "FUNCTION: png_get_compression_buffer_size ( png_ptr -- u )", "EXTERN: \"C\" long png_get_compression_buffer_size( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_set_compression_buffer_size png_set_compression_buffer_size a u -- void", "FUNCTION: png_set_compression_buffer_size ( png_ptr size -- void )", "EXTERN: \"C\" void png_set_compression_buffer_size( void * png_ptr, long size );", "	( png_ptr size -- )" );
	swigFunction( "c-function png_longjmp png_longjmp a n -- void", "FUNCTION: png_longjmp ( png_ptr val -- void )", "EXTERN: \"C\" void png_longjmp( void * png_ptr, int val );", "	( png_ptr val -- )" );
	swigFunction( "c-function png_write_sig png_write_sig a -- void", "FUNCTION: png_write_sig ( png_ptr -- void )", "EXTERN: \"C\" void png_write_sig( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_write_chunk png_write_chunk a a a u -- void", "FUNCTION: png_write_chunk ( png_ptr chunk_name data length -- void )", "EXTERN: \"C\" void png_write_chunk( void * png_ptr, void * chunk_name, void * data, long length );", "	( png_ptr chunk_name data length -- )" );
	swigFunction( "c-function png_write_chunk_start png_write_chunk_start a a u -- void", "FUNCTION: png_write_chunk_start ( png_ptr chunk_name length -- void )", "EXTERN: \"C\" void png_write_chunk_start( void * png_ptr, void * chunk_name, int length );", "	( png_ptr chunk_name length -- )" );
	swigFunction( "c-function png_write_chunk_data png_write_chunk_data a a u -- void", "FUNCTION: png_write_chunk_data ( png_ptr data length -- void )", "EXTERN: \"C\" void png_write_chunk_data( void * png_ptr, void * data, long length );", "	( png_ptr data length -- )" );
	swigFunction( "c-function png_write_chunk_end png_write_chunk_end a -- void", "FUNCTION: png_write_chunk_end ( png_ptr -- void )", "EXTERN: \"C\" void png_write_chunk_end( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_create_info_struct png_create_info_struct a -- a", "FUNCTION: png_create_info_struct ( png_ptr -- a )", "EXTERN: \"C\" void * png_create_info_struct( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_info_init_3 png_info_init_3 a u -- void", "FUNCTION: png_info_init_3 ( info_ptr png_info_struct_size -- void )", "EXTERN: \"C\" void png_info_init_3( void * info_ptr, long png_info_struct_size );", "	( info_ptr png_info_struct_size -- )" );
	swigFunction( "c-function png_write_info_before_PLTE png_write_info_before_PLTE a a -- void", "FUNCTION: png_write_info_before_PLTE ( png_ptr info_ptr -- void )", "EXTERN: \"C\" void png_write_info_before_PLTE( void * png_ptr, void * info_ptr );", "	( png_ptr info_ptr -- )" );
	swigFunction( "c-function png_write_info png_write_info a a -- void", "FUNCTION: png_write_info ( png_ptr info_ptr -- void )", "EXTERN: \"C\" void png_write_info( void * png_ptr, void * info_ptr );", "	( png_ptr info_ptr -- )" );
	swigFunction( "c-function png_start_read_image png_start_read_image a -- void", "FUNCTION: png_start_read_image ( png_ptr -- void )", "EXTERN: \"C\" void png_start_read_image( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_read_update_info png_read_update_info a a -- void", "FUNCTION: png_read_update_info ( png_ptr info_ptr -- void )", "EXTERN: \"C\" void png_read_update_info( void * png_ptr, void * info_ptr );", "	( png_ptr info_ptr -- )" );
	swigFunction( "c-function png_write_row png_write_row a a -- void", "FUNCTION: png_write_row ( png_ptr row -- void )", "EXTERN: \"C\" void png_write_row( void * png_ptr, void * row );", "	( png_ptr row -- )" );
	swigFunction( "c-function png_write_rows png_write_rows a a u -- void", "FUNCTION: png_write_rows ( png_ptr row num_rows -- void )", "EXTERN: \"C\" void png_write_rows( void * png_ptr, void * row, int num_rows );", "	( png_ptr row num_rows -- )" );
	swigFunction( "c-function png_write_image png_write_image a a -- void", "FUNCTION: png_write_image ( png_ptr image -- void )", "EXTERN: \"C\" void png_write_image( void * png_ptr, void * image );", "	( png_ptr image -- )" );
	swigFunction( "c-function png_write_end png_write_end a a -- void", "FUNCTION: png_write_end ( png_ptr info_ptr -- void )", "EXTERN: \"C\" void png_write_end( void * png_ptr, void * info_ptr );", "	( png_ptr info_ptr -- )" );
	swigFunction( "c-function png_destroy_info_struct png_destroy_info_struct a a -- void", "FUNCTION: png_destroy_info_struct ( png_ptr info_ptr_ptr -- void )", "EXTERN: \"C\" void png_destroy_info_struct( void * png_ptr, void * info_ptr_ptr );", "	( png_ptr info_ptr_ptr -- )" );
	swigFunction( "c-function png_destroy_read_struct png_destroy_read_struct a a a -- void", "FUNCTION: png_destroy_read_struct ( png_ptr_ptr info_ptr_ptr end_info_ptr_ptr -- void )", "EXTERN: \"C\" void png_destroy_read_struct( void * png_ptr_ptr, void * info_ptr_ptr, void * end_info_ptr_ptr );", "	( png_ptr_ptr info_ptr_ptr end_info_ptr_ptr -- )" );
	swigFunction( "c-function png_destroy_write_struct png_destroy_write_struct a a -- void", "FUNCTION: png_destroy_write_struct ( png_ptr_ptr info_ptr_ptr -- void )", "EXTERN: \"C\" void png_destroy_write_struct( void * png_ptr_ptr, void * info_ptr_ptr );", "	( png_ptr_ptr info_ptr_ptr -- )" );
	swigFunction( "c-function png_set_crc_action png_set_crc_action a n n -- void", "FUNCTION: png_set_crc_action ( png_ptr crit_action ancil_action -- void )", "EXTERN: \"C\" void png_set_crc_action( void * png_ptr, int crit_action, int ancil_action );", "	( png_ptr crit_action ancil_action -- )" );
	swigFunction( "c-function png_set_error_fn png_set_error_fn a a a a -- void", "FUNCTION: png_set_error_fn ( png_ptr error_ptr error_fn warning_fn -- void )", "EXTERN: \"C\" void png_set_error_fn( void * png_ptr, void * error_ptr, void * error_fn, void * warning_fn );", "	( png_ptr error_ptr error_fn warning_fn -- )" );
	swigFunction( "c-function png_get_error_ptr png_get_error_ptr a -- a", "FUNCTION: png_get_error_ptr ( png_ptr -- a )", "EXTERN: \"C\" void * png_get_error_ptr( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_set_write_fn png_set_write_fn a a a a -- void", "FUNCTION: png_set_write_fn ( png_ptr io_ptr write_data_fn output_flush_fn -- void )", "EXTERN: \"C\" void png_set_write_fn( void * png_ptr, void * io_ptr, void * write_data_fn, void * output_flush_fn );", "	( png_ptr io_ptr write_data_fn output_flush_fn -- )" );
	swigFunction( "c-function png_set_read_fn png_set_read_fn a a a -- void", "FUNCTION: png_set_read_fn ( png_ptr io_ptr read_data_fn -- void )", "EXTERN: \"C\" void png_set_read_fn( void * png_ptr, void * io_ptr, void * read_data_fn );", "	( png_ptr io_ptr read_data_fn -- )" );
	swigFunction( "c-function png_get_io_ptr png_get_io_ptr a -- a", "FUNCTION: png_get_io_ptr ( png_ptr -- a )", "EXTERN: \"C\" void * png_get_io_ptr( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_set_read_status_fn png_set_read_status_fn a a -- void", "FUNCTION: png_set_read_status_fn ( png_ptr read_row_fn -- void )", "EXTERN: \"C\" void png_set_read_status_fn( void * png_ptr, void * read_row_fn );", "	( png_ptr read_row_fn -- )" );
	swigFunction( "c-function png_set_write_status_fn png_set_write_status_fn a a -- void", "FUNCTION: png_set_write_status_fn ( png_ptr write_row_fn -- void )", "EXTERN: \"C\" void png_set_write_status_fn( void * png_ptr, void * write_row_fn );", "	( png_ptr write_row_fn -- )" );
	swigFunction( "c-function png_malloc png_malloc a u -- a", "FUNCTION: png_malloc ( png_ptr size -- a )", "EXTERN: \"C\" void * png_malloc( void * png_ptr, long size );", "	( png_ptr size -- )" );
	swigFunction( "c-function png_calloc png_calloc a u -- a", "FUNCTION: png_calloc ( png_ptr size -- a )", "EXTERN: \"C\" void * png_calloc( void * png_ptr, long size );", "	( png_ptr size -- )" );
	swigFunction( "c-function png_malloc_warn png_malloc_warn a u -- a", "FUNCTION: png_malloc_warn ( png_ptr size -- a )", "EXTERN: \"C\" void * png_malloc_warn( void * png_ptr, long size );", "	( png_ptr size -- )" );
	swigFunction( "c-function png_free png_free a a -- void", "FUNCTION: png_free ( png_ptr ptr -- void )", "EXTERN: \"C\" void png_free( void * png_ptr, void * ptr );", "	( png_ptr ptr -- )" );
	swigFunction( "c-function png_free_data png_free_data a a u n -- void", "FUNCTION: png_free_data ( png_ptr info_ptr free_me num -- void )", "EXTERN: \"C\" void png_free_data( void * png_ptr, void * info_ptr, int free_me, int num );", "	( png_ptr info_ptr free_me num -- )" );
	swigFunction( "c-function png_data_freer png_data_freer a a n u -- void", "FUNCTION: png_data_freer ( png_ptr info_ptr freer mask -- void )", "EXTERN: \"C\" void png_data_freer( void * png_ptr, void * info_ptr, int freer, int mask );", "	( png_ptr info_ptr freer mask -- )" );
	swigFunction( "c-function png_error png_error a s -- void", "FUNCTION: png_error ( png_ptr error_message -- void )", "EXTERN: \"C\" void png_error( void * png_ptr, char * error_message );", "	( png_ptr error_message -- )" );
	swigFunction( "c-function png_chunk_error png_chunk_error a s -- void", "FUNCTION: png_chunk_error ( png_ptr error_message -- void )", "EXTERN: \"C\" void png_chunk_error( void * png_ptr, char * error_message );", "	( png_ptr error_message -- )" );
	swigFunction( "c-function png_get_valid png_get_valid a a u -- u", "FUNCTION: png_get_valid ( png_ptr info_ptr flag -- u )", "EXTERN: \"C\" int png_get_valid( void * png_ptr, void * info_ptr, int flag );", "	( png_ptr info_ptr flag -- )" );
	swigFunction( "c-function png_get_rowbytes png_get_rowbytes a a -- u", "FUNCTION: png_get_rowbytes ( png_ptr info_ptr -- u )", "EXTERN: \"C\" long png_get_rowbytes( void * png_ptr, void * info_ptr );", "	( png_ptr info_ptr -- )" );
	swigFunction( "c-function png_get_channels png_get_channels a a -- u", "FUNCTION: png_get_channels ( png_ptr info_ptr -- u )", "EXTERN: \"C\" char png_get_channels( void * png_ptr, void * info_ptr );", "	( png_ptr info_ptr -- )" );
	swigFunction( "c-function png_get_IHDR png_get_IHDR a a a a a a a a a -- u", "FUNCTION: png_get_IHDR ( png_ptr info_ptr width height bit_depth color_type interlace_method compression_method filter_method -- u )", "EXTERN: \"C\" int png_get_IHDR( void * png_ptr, void * info_ptr, void * width, void * height, void * bit_depth, void * color_type, void * interlace_method, void * compression_method, void * filter_method );", "	( png_ptr info_ptr width height bit_depth color_type interlace_method compression_method filter_method -- )" );
	swigFunction( "c-function png_set_IHDR png_set_IHDR a a u u n n n n n -- void", "FUNCTION: png_set_IHDR ( png_ptr info_ptr width height bit_depth color_type interlace_method compression_method filter_method -- void )", "EXTERN: \"C\" void png_set_IHDR( void * png_ptr, void * info_ptr, int width, int height, int bit_depth, int color_type, int interlace_method, int compression_method, int filter_method );", "	( png_ptr info_ptr width height bit_depth color_type interlace_method compression_method filter_method -- )" );
	swigFunction( "c-function png_get_PLTE png_get_PLTE a a a a -- u", "FUNCTION: png_get_PLTE ( png_ptr info_ptr palette num_palette -- u )", "EXTERN: \"C\" int png_get_PLTE( void * png_ptr, void * info_ptr, void * palette, void * num_palette );", "	( png_ptr info_ptr palette num_palette -- )" );
	swigFunction( "c-function png_set_PLTE png_set_PLTE a a a n -- void", "FUNCTION: png_set_PLTE ( png_ptr info_ptr palette num_palette -- void )", "EXTERN: \"C\" void png_set_PLTE( void * png_ptr, void * info_ptr, void * palette, int num_palette );", "	( png_ptr info_ptr palette num_palette -- )" );
	swigFunction( "c-function png_set_invalid png_set_invalid a a n -- void", "FUNCTION: png_set_invalid ( png_ptr info_ptr mask -- void )", "EXTERN: \"C\" void png_set_invalid( void * png_ptr, void * info_ptr, int mask );", "	( png_ptr info_ptr mask -- )" );
	swigFunction( "c-function png_get_copyright png_get_copyright a -- s", "FUNCTION: png_get_copyright ( png_ptr -- s )", "EXTERN: \"C\" char * png_get_copyright( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_get_header_ver png_get_header_ver a -- s", "FUNCTION: png_get_header_ver ( png_ptr -- s )", "EXTERN: \"C\" char * png_get_header_ver( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_get_header_version png_get_header_version a -- s", "FUNCTION: png_get_header_version ( png_ptr -- s )", "EXTERN: \"C\" char * png_get_header_version( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_get_libpng_ver png_get_libpng_ver a -- s", "FUNCTION: png_get_libpng_ver ( png_ptr -- s )", "EXTERN: \"C\" char * png_get_libpng_ver( void * png_ptr );", "	( png_ptr -- )" );
	swigFunction( "c-function png_get_uint_31 png_get_uint_31 a a -- u", "FUNCTION: png_get_uint_31 ( png_ptr buf -- u )", "EXTERN: \"C\" int png_get_uint_31( void * png_ptr, void * buf );", "	( png_ptr buf -- )" );

	swigNewline();

	swigComment("----===< postfix >===-----\n");

	swigPrint( "end-c-library", "( none )", "( none )" );
	
	return 0;
} /* end of main */



