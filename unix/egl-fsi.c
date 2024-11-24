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


#define EGL_EGLEXT_PROTOTYPES
#include <EGL/egl.h>
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

	swigPrint( "c-library egl\ns\" EGL\" add-lib\n\\c #define EGL_EGLEXT_PROTOTYPES\n\\c #include <EGL/egl.h>\n\\c #ifdef __gnu_linux__\n\\c #undef stderr\n\\c extern struct _IO_FILE *stderr;\n\\c #endif", "( none )", "( none )" );

	swigNewline();

	swigComment("----===< int constants >===-----\n");
	#ifdef __egl_h_
		swigIntConstant( __egl_h_, "__egl_h_" );
	#endif
	#ifdef EGL_EGL_PROTOTYPES
		swigIntConstant( EGL_EGL_PROTOTYPES, "EGL_EGL_PROTOTYPES" );
	#endif
	#ifdef EGL_VERSION_1_0
		swigIntConstant( EGL_VERSION_1_0, "EGL_VERSION_1_0" );
	#endif
	#ifdef EGL_ALPHA_SIZE
		swigIntConstant( EGL_ALPHA_SIZE, "EGL_ALPHA_SIZE" );
	#endif
	#ifdef EGL_BAD_ACCESS
		swigIntConstant( EGL_BAD_ACCESS, "EGL_BAD_ACCESS" );
	#endif
	#ifdef EGL_BAD_ALLOC
		swigIntConstant( EGL_BAD_ALLOC, "EGL_BAD_ALLOC" );
	#endif
	#ifdef EGL_BAD_ATTRIBUTE
		swigIntConstant( EGL_BAD_ATTRIBUTE, "EGL_BAD_ATTRIBUTE" );
	#endif
	#ifdef EGL_BAD_CONFIG
		swigIntConstant( EGL_BAD_CONFIG, "EGL_BAD_CONFIG" );
	#endif
	#ifdef EGL_BAD_CONTEXT
		swigIntConstant( EGL_BAD_CONTEXT, "EGL_BAD_CONTEXT" );
	#endif
	#ifdef EGL_BAD_CURRENT_SURFACE
		swigIntConstant( EGL_BAD_CURRENT_SURFACE, "EGL_BAD_CURRENT_SURFACE" );
	#endif
	#ifdef EGL_BAD_DISPLAY
		swigIntConstant( EGL_BAD_DISPLAY, "EGL_BAD_DISPLAY" );
	#endif
	#ifdef EGL_BAD_MATCH
		swigIntConstant( EGL_BAD_MATCH, "EGL_BAD_MATCH" );
	#endif
	#ifdef EGL_BAD_NATIVE_PIXMAP
		swigIntConstant( EGL_BAD_NATIVE_PIXMAP, "EGL_BAD_NATIVE_PIXMAP" );
	#endif
	#ifdef EGL_BAD_NATIVE_WINDOW
		swigIntConstant( EGL_BAD_NATIVE_WINDOW, "EGL_BAD_NATIVE_WINDOW" );
	#endif
	#ifdef EGL_BAD_PARAMETER
		swigIntConstant( EGL_BAD_PARAMETER, "EGL_BAD_PARAMETER" );
	#endif
	#ifdef EGL_BAD_SURFACE
		swigIntConstant( EGL_BAD_SURFACE, "EGL_BAD_SURFACE" );
	#endif
	#ifdef EGL_BLUE_SIZE
		swigIntConstant( EGL_BLUE_SIZE, "EGL_BLUE_SIZE" );
	#endif
	#ifdef EGL_BUFFER_SIZE
		swigIntConstant( EGL_BUFFER_SIZE, "EGL_BUFFER_SIZE" );
	#endif
	#ifdef EGL_CONFIG_CAVEAT
		swigIntConstant( EGL_CONFIG_CAVEAT, "EGL_CONFIG_CAVEAT" );
	#endif
	#ifdef EGL_CONFIG_ID
		swigIntConstant( EGL_CONFIG_ID, "EGL_CONFIG_ID" );
	#endif
	#ifdef EGL_CORE_NATIVE_ENGINE
		swigIntConstant( EGL_CORE_NATIVE_ENGINE, "EGL_CORE_NATIVE_ENGINE" );
	#endif
	#ifdef EGL_DEPTH_SIZE
		swigIntConstant( EGL_DEPTH_SIZE, "EGL_DEPTH_SIZE" );
	#endif
	#ifdef EGL_DRAW
		swigIntConstant( EGL_DRAW, "EGL_DRAW" );
	#endif
	#ifdef EGL_EXTENSIONS
		swigIntConstant( EGL_EXTENSIONS, "EGL_EXTENSIONS" );
	#endif
	#ifdef EGL_FALSE
		swigIntConstant( EGL_FALSE, "EGL_FALSE" );
	#endif
	#ifdef EGL_GREEN_SIZE
		swigIntConstant( EGL_GREEN_SIZE, "EGL_GREEN_SIZE" );
	#endif
	#ifdef EGL_HEIGHT
		swigIntConstant( EGL_HEIGHT, "EGL_HEIGHT" );
	#endif
	#ifdef EGL_LARGEST_PBUFFER
		swigIntConstant( EGL_LARGEST_PBUFFER, "EGL_LARGEST_PBUFFER" );
	#endif
	#ifdef EGL_LEVEL
		swigIntConstant( EGL_LEVEL, "EGL_LEVEL" );
	#endif
	#ifdef EGL_MAX_PBUFFER_HEIGHT
		swigIntConstant( EGL_MAX_PBUFFER_HEIGHT, "EGL_MAX_PBUFFER_HEIGHT" );
	#endif
	#ifdef EGL_MAX_PBUFFER_PIXELS
		swigIntConstant( EGL_MAX_PBUFFER_PIXELS, "EGL_MAX_PBUFFER_PIXELS" );
	#endif
	#ifdef EGL_MAX_PBUFFER_WIDTH
		swigIntConstant( EGL_MAX_PBUFFER_WIDTH, "EGL_MAX_PBUFFER_WIDTH" );
	#endif
	#ifdef EGL_NATIVE_RENDERABLE
		swigIntConstant( EGL_NATIVE_RENDERABLE, "EGL_NATIVE_RENDERABLE" );
	#endif
	#ifdef EGL_NATIVE_VISUAL_ID
		swigIntConstant( EGL_NATIVE_VISUAL_ID, "EGL_NATIVE_VISUAL_ID" );
	#endif
	#ifdef EGL_NATIVE_VISUAL_TYPE
		swigIntConstant( EGL_NATIVE_VISUAL_TYPE, "EGL_NATIVE_VISUAL_TYPE" );
	#endif
	#ifdef EGL_NONE
		swigIntConstant( EGL_NONE, "EGL_NONE" );
	#endif
	#ifdef EGL_NON_CONFORMANT_CONFIG
		swigIntConstant( EGL_NON_CONFORMANT_CONFIG, "EGL_NON_CONFORMANT_CONFIG" );
	#endif
	#ifdef EGL_NOT_INITIALIZED
		swigIntConstant( EGL_NOT_INITIALIZED, "EGL_NOT_INITIALIZED" );
	#endif
	#ifdef EGL_PBUFFER_BIT
		swigIntConstant( EGL_PBUFFER_BIT, "EGL_PBUFFER_BIT" );
	#endif
	#ifdef EGL_PIXMAP_BIT
		swigIntConstant( EGL_PIXMAP_BIT, "EGL_PIXMAP_BIT" );
	#endif
	#ifdef EGL_READ
		swigIntConstant( EGL_READ, "EGL_READ" );
	#endif
	#ifdef EGL_RED_SIZE
		swigIntConstant( EGL_RED_SIZE, "EGL_RED_SIZE" );
	#endif
	#ifdef EGL_SAMPLES
		swigIntConstant( EGL_SAMPLES, "EGL_SAMPLES" );
	#endif
	#ifdef EGL_SAMPLE_BUFFERS
		swigIntConstant( EGL_SAMPLE_BUFFERS, "EGL_SAMPLE_BUFFERS" );
	#endif
	#ifdef EGL_SLOW_CONFIG
		swigIntConstant( EGL_SLOW_CONFIG, "EGL_SLOW_CONFIG" );
	#endif
	#ifdef EGL_STENCIL_SIZE
		swigIntConstant( EGL_STENCIL_SIZE, "EGL_STENCIL_SIZE" );
	#endif
	#ifdef EGL_SUCCESS
		swigIntConstant( EGL_SUCCESS, "EGL_SUCCESS" );
	#endif
	#ifdef EGL_SURFACE_TYPE
		swigIntConstant( EGL_SURFACE_TYPE, "EGL_SURFACE_TYPE" );
	#endif
	#ifdef EGL_TRANSPARENT_BLUE_VALUE
		swigIntConstant( EGL_TRANSPARENT_BLUE_VALUE, "EGL_TRANSPARENT_BLUE_VALUE" );
	#endif
	#ifdef EGL_TRANSPARENT_GREEN_VALUE
		swigIntConstant( EGL_TRANSPARENT_GREEN_VALUE, "EGL_TRANSPARENT_GREEN_VALUE" );
	#endif
	#ifdef EGL_TRANSPARENT_RED_VALUE
		swigIntConstant( EGL_TRANSPARENT_RED_VALUE, "EGL_TRANSPARENT_RED_VALUE" );
	#endif
	#ifdef EGL_TRANSPARENT_RGB
		swigIntConstant( EGL_TRANSPARENT_RGB, "EGL_TRANSPARENT_RGB" );
	#endif
	#ifdef EGL_TRANSPARENT_TYPE
		swigIntConstant( EGL_TRANSPARENT_TYPE, "EGL_TRANSPARENT_TYPE" );
	#endif
	#ifdef EGL_TRUE
		swigIntConstant( EGL_TRUE, "EGL_TRUE" );
	#endif
	#ifdef EGL_VENDOR
		swigIntConstant( EGL_VENDOR, "EGL_VENDOR" );
	#endif
	#ifdef EGL_VERSION
		swigIntConstant( EGL_VERSION, "EGL_VERSION" );
	#endif
	#ifdef EGL_WIDTH
		swigIntConstant( EGL_WIDTH, "EGL_WIDTH" );
	#endif
	#ifdef EGL_WINDOW_BIT
		swigIntConstant( EGL_WINDOW_BIT, "EGL_WINDOW_BIT" );
	#endif
	#ifdef EGL_VERSION_1_1
		swigIntConstant( EGL_VERSION_1_1, "EGL_VERSION_1_1" );
	#endif
	#ifdef EGL_BACK_BUFFER
		swigIntConstant( EGL_BACK_BUFFER, "EGL_BACK_BUFFER" );
	#endif
	#ifdef EGL_BIND_TO_TEXTURE_RGB
		swigIntConstant( EGL_BIND_TO_TEXTURE_RGB, "EGL_BIND_TO_TEXTURE_RGB" );
	#endif
	#ifdef EGL_BIND_TO_TEXTURE_RGBA
		swigIntConstant( EGL_BIND_TO_TEXTURE_RGBA, "EGL_BIND_TO_TEXTURE_RGBA" );
	#endif
	#ifdef EGL_CONTEXT_LOST
		swigIntConstant( EGL_CONTEXT_LOST, "EGL_CONTEXT_LOST" );
	#endif
	#ifdef EGL_MIN_SWAP_INTERVAL
		swigIntConstant( EGL_MIN_SWAP_INTERVAL, "EGL_MIN_SWAP_INTERVAL" );
	#endif
	#ifdef EGL_MAX_SWAP_INTERVAL
		swigIntConstant( EGL_MAX_SWAP_INTERVAL, "EGL_MAX_SWAP_INTERVAL" );
	#endif
	#ifdef EGL_MIPMAP_TEXTURE
		swigIntConstant( EGL_MIPMAP_TEXTURE, "EGL_MIPMAP_TEXTURE" );
	#endif
	#ifdef EGL_MIPMAP_LEVEL
		swigIntConstant( EGL_MIPMAP_LEVEL, "EGL_MIPMAP_LEVEL" );
	#endif
	#ifdef EGL_NO_TEXTURE
		swigIntConstant( EGL_NO_TEXTURE, "EGL_NO_TEXTURE" );
	#endif
	#ifdef EGL_TEXTURE_2D
		swigIntConstant( EGL_TEXTURE_2D, "EGL_TEXTURE_2D" );
	#endif
	#ifdef EGL_TEXTURE_FORMAT
		swigIntConstant( EGL_TEXTURE_FORMAT, "EGL_TEXTURE_FORMAT" );
	#endif
	#ifdef EGL_TEXTURE_RGB
		swigIntConstant( EGL_TEXTURE_RGB, "EGL_TEXTURE_RGB" );
	#endif
	#ifdef EGL_TEXTURE_RGBA
		swigIntConstant( EGL_TEXTURE_RGBA, "EGL_TEXTURE_RGBA" );
	#endif
	#ifdef EGL_TEXTURE_TARGET
		swigIntConstant( EGL_TEXTURE_TARGET, "EGL_TEXTURE_TARGET" );
	#endif
	#ifdef EGL_VERSION_1_2
		swigIntConstant( EGL_VERSION_1_2, "EGL_VERSION_1_2" );
	#endif
	#ifdef EGL_ALPHA_FORMAT
		swigIntConstant( EGL_ALPHA_FORMAT, "EGL_ALPHA_FORMAT" );
	#endif
	#ifdef EGL_ALPHA_FORMAT_NONPRE
		swigIntConstant( EGL_ALPHA_FORMAT_NONPRE, "EGL_ALPHA_FORMAT_NONPRE" );
	#endif
	#ifdef EGL_ALPHA_FORMAT_PRE
		swigIntConstant( EGL_ALPHA_FORMAT_PRE, "EGL_ALPHA_FORMAT_PRE" );
	#endif
	#ifdef EGL_ALPHA_MASK_SIZE
		swigIntConstant( EGL_ALPHA_MASK_SIZE, "EGL_ALPHA_MASK_SIZE" );
	#endif
	#ifdef EGL_BUFFER_PRESERVED
		swigIntConstant( EGL_BUFFER_PRESERVED, "EGL_BUFFER_PRESERVED" );
	#endif
	#ifdef EGL_BUFFER_DESTROYED
		swigIntConstant( EGL_BUFFER_DESTROYED, "EGL_BUFFER_DESTROYED" );
	#endif
	#ifdef EGL_CLIENT_APIS
		swigIntConstant( EGL_CLIENT_APIS, "EGL_CLIENT_APIS" );
	#endif
	#ifdef EGL_COLORSPACE
		swigIntConstant( EGL_COLORSPACE, "EGL_COLORSPACE" );
	#endif
	#ifdef EGL_COLORSPACE_sRGB
		swigIntConstant( EGL_COLORSPACE_sRGB, "EGL_COLORSPACE_sRGB" );
	#endif
	#ifdef EGL_COLORSPACE_LINEAR
		swigIntConstant( EGL_COLORSPACE_LINEAR, "EGL_COLORSPACE_LINEAR" );
	#endif
	#ifdef EGL_COLOR_BUFFER_TYPE
		swigIntConstant( EGL_COLOR_BUFFER_TYPE, "EGL_COLOR_BUFFER_TYPE" );
	#endif
	#ifdef EGL_CONTEXT_CLIENT_TYPE
		swigIntConstant( EGL_CONTEXT_CLIENT_TYPE, "EGL_CONTEXT_CLIENT_TYPE" );
	#endif
	#ifdef EGL_DISPLAY_SCALING
		swigIntConstant( EGL_DISPLAY_SCALING, "EGL_DISPLAY_SCALING" );
	#endif
	#ifdef EGL_HORIZONTAL_RESOLUTION
		swigIntConstant( EGL_HORIZONTAL_RESOLUTION, "EGL_HORIZONTAL_RESOLUTION" );
	#endif
	#ifdef EGL_LUMINANCE_BUFFER
		swigIntConstant( EGL_LUMINANCE_BUFFER, "EGL_LUMINANCE_BUFFER" );
	#endif
	#ifdef EGL_LUMINANCE_SIZE
		swigIntConstant( EGL_LUMINANCE_SIZE, "EGL_LUMINANCE_SIZE" );
	#endif
	#ifdef EGL_OPENGL_ES_BIT
		swigIntConstant( EGL_OPENGL_ES_BIT, "EGL_OPENGL_ES_BIT" );
	#endif
	#ifdef EGL_OPENVG_BIT
		swigIntConstant( EGL_OPENVG_BIT, "EGL_OPENVG_BIT" );
	#endif
	#ifdef EGL_OPENGL_ES_API
		swigIntConstant( EGL_OPENGL_ES_API, "EGL_OPENGL_ES_API" );
	#endif
	#ifdef EGL_OPENVG_API
		swigIntConstant( EGL_OPENVG_API, "EGL_OPENVG_API" );
	#endif
	#ifdef EGL_OPENVG_IMAGE
		swigIntConstant( EGL_OPENVG_IMAGE, "EGL_OPENVG_IMAGE" );
	#endif
	#ifdef EGL_PIXEL_ASPECT_RATIO
		swigIntConstant( EGL_PIXEL_ASPECT_RATIO, "EGL_PIXEL_ASPECT_RATIO" );
	#endif
	#ifdef EGL_RENDERABLE_TYPE
		swigIntConstant( EGL_RENDERABLE_TYPE, "EGL_RENDERABLE_TYPE" );
	#endif
	#ifdef EGL_RENDER_BUFFER
		swigIntConstant( EGL_RENDER_BUFFER, "EGL_RENDER_BUFFER" );
	#endif
	#ifdef EGL_RGB_BUFFER
		swigIntConstant( EGL_RGB_BUFFER, "EGL_RGB_BUFFER" );
	#endif
	#ifdef EGL_SINGLE_BUFFER
		swigIntConstant( EGL_SINGLE_BUFFER, "EGL_SINGLE_BUFFER" );
	#endif
	#ifdef EGL_SWAP_BEHAVIOR
		swigIntConstant( EGL_SWAP_BEHAVIOR, "EGL_SWAP_BEHAVIOR" );
	#endif
	#ifdef EGL_VERTICAL_RESOLUTION
		swigIntConstant( EGL_VERTICAL_RESOLUTION, "EGL_VERTICAL_RESOLUTION" );
	#endif
	#ifdef EGL_VERSION_1_3
		swigIntConstant( EGL_VERSION_1_3, "EGL_VERSION_1_3" );
	#endif
	#ifdef EGL_CONFORMANT
		swigIntConstant( EGL_CONFORMANT, "EGL_CONFORMANT" );
	#endif
	#ifdef EGL_CONTEXT_CLIENT_VERSION
		swigIntConstant( EGL_CONTEXT_CLIENT_VERSION, "EGL_CONTEXT_CLIENT_VERSION" );
	#endif
	#ifdef EGL_MATCH_NATIVE_PIXMAP
		swigIntConstant( EGL_MATCH_NATIVE_PIXMAP, "EGL_MATCH_NATIVE_PIXMAP" );
	#endif
	#ifdef EGL_OPENGL_ES2_BIT
		swigIntConstant( EGL_OPENGL_ES2_BIT, "EGL_OPENGL_ES2_BIT" );
	#endif
	#ifdef EGL_VG_ALPHA_FORMAT
		swigIntConstant( EGL_VG_ALPHA_FORMAT, "EGL_VG_ALPHA_FORMAT" );
	#endif
	#ifdef EGL_VG_ALPHA_FORMAT_NONPRE
		swigIntConstant( EGL_VG_ALPHA_FORMAT_NONPRE, "EGL_VG_ALPHA_FORMAT_NONPRE" );
	#endif
	#ifdef EGL_VG_ALPHA_FORMAT_PRE
		swigIntConstant( EGL_VG_ALPHA_FORMAT_PRE, "EGL_VG_ALPHA_FORMAT_PRE" );
	#endif
	#ifdef EGL_VG_ALPHA_FORMAT_PRE_BIT
		swigIntConstant( EGL_VG_ALPHA_FORMAT_PRE_BIT, "EGL_VG_ALPHA_FORMAT_PRE_BIT" );
	#endif
	#ifdef EGL_VG_COLORSPACE
		swigIntConstant( EGL_VG_COLORSPACE, "EGL_VG_COLORSPACE" );
	#endif
	#ifdef EGL_VG_COLORSPACE_sRGB
		swigIntConstant( EGL_VG_COLORSPACE_sRGB, "EGL_VG_COLORSPACE_sRGB" );
	#endif
	#ifdef EGL_VG_COLORSPACE_LINEAR
		swigIntConstant( EGL_VG_COLORSPACE_LINEAR, "EGL_VG_COLORSPACE_LINEAR" );
	#endif
	#ifdef EGL_VG_COLORSPACE_LINEAR_BIT
		swigIntConstant( EGL_VG_COLORSPACE_LINEAR_BIT, "EGL_VG_COLORSPACE_LINEAR_BIT" );
	#endif
	#ifdef EGL_VERSION_1_4
		swigIntConstant( EGL_VERSION_1_4, "EGL_VERSION_1_4" );
	#endif
	#ifdef EGL_MULTISAMPLE_RESOLVE_BOX_BIT
		swigIntConstant( EGL_MULTISAMPLE_RESOLVE_BOX_BIT, "EGL_MULTISAMPLE_RESOLVE_BOX_BIT" );
	#endif
	#ifdef EGL_MULTISAMPLE_RESOLVE
		swigIntConstant( EGL_MULTISAMPLE_RESOLVE, "EGL_MULTISAMPLE_RESOLVE" );
	#endif
	#ifdef EGL_MULTISAMPLE_RESOLVE_DEFAULT
		swigIntConstant( EGL_MULTISAMPLE_RESOLVE_DEFAULT, "EGL_MULTISAMPLE_RESOLVE_DEFAULT" );
	#endif
	#ifdef EGL_MULTISAMPLE_RESOLVE_BOX
		swigIntConstant( EGL_MULTISAMPLE_RESOLVE_BOX, "EGL_MULTISAMPLE_RESOLVE_BOX" );
	#endif
	#ifdef EGL_OPENGL_API
		swigIntConstant( EGL_OPENGL_API, "EGL_OPENGL_API" );
	#endif
	#ifdef EGL_OPENGL_BIT
		swigIntConstant( EGL_OPENGL_BIT, "EGL_OPENGL_BIT" );
	#endif
	#ifdef EGL_SWAP_BEHAVIOR_PRESERVED_BIT
		swigIntConstant( EGL_SWAP_BEHAVIOR_PRESERVED_BIT, "EGL_SWAP_BEHAVIOR_PRESERVED_BIT" );
	#endif
	#ifdef EGL_VERSION_1_5
		swigIntConstant( EGL_VERSION_1_5, "EGL_VERSION_1_5" );
	#endif
	#ifdef EGL_CONTEXT_MAJOR_VERSION
		swigIntConstant( EGL_CONTEXT_MAJOR_VERSION, "EGL_CONTEXT_MAJOR_VERSION" );
	#endif
	#ifdef EGL_CONTEXT_MINOR_VERSION
		swigIntConstant( EGL_CONTEXT_MINOR_VERSION, "EGL_CONTEXT_MINOR_VERSION" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_PROFILE_MASK
		swigIntConstant( EGL_CONTEXT_OPENGL_PROFILE_MASK, "EGL_CONTEXT_OPENGL_PROFILE_MASK" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY
		swigIntConstant( EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY, "EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY" );
	#endif
	#ifdef EGL_NO_RESET_NOTIFICATION
		swigIntConstant( EGL_NO_RESET_NOTIFICATION, "EGL_NO_RESET_NOTIFICATION" );
	#endif
	#ifdef EGL_LOSE_CONTEXT_ON_RESET
		swigIntConstant( EGL_LOSE_CONTEXT_ON_RESET, "EGL_LOSE_CONTEXT_ON_RESET" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT
		swigIntConstant( EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT, "EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_COMPATIBILITY_PROFILE_BIT
		swigIntConstant( EGL_CONTEXT_OPENGL_COMPATIBILITY_PROFILE_BIT, "EGL_CONTEXT_OPENGL_COMPATIBILITY_PROFILE_BIT" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_DEBUG
		swigIntConstant( EGL_CONTEXT_OPENGL_DEBUG, "EGL_CONTEXT_OPENGL_DEBUG" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE
		swigIntConstant( EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE, "EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE" );
	#endif
	#ifdef EGL_CONTEXT_OPENGL_ROBUST_ACCESS
		swigIntConstant( EGL_CONTEXT_OPENGL_ROBUST_ACCESS, "EGL_CONTEXT_OPENGL_ROBUST_ACCESS" );
	#endif
	#ifdef EGL_OPENGL_ES3_BIT
		swigIntConstant( EGL_OPENGL_ES3_BIT, "EGL_OPENGL_ES3_BIT" );
	#endif
	#ifdef EGL_CL_EVENT_HANDLE
		swigIntConstant( EGL_CL_EVENT_HANDLE, "EGL_CL_EVENT_HANDLE" );
	#endif
	#ifdef EGL_SYNC_CL_EVENT
		swigIntConstant( EGL_SYNC_CL_EVENT, "EGL_SYNC_CL_EVENT" );
	#endif
	#ifdef EGL_SYNC_CL_EVENT_COMPLETE
		swigIntConstant( EGL_SYNC_CL_EVENT_COMPLETE, "EGL_SYNC_CL_EVENT_COMPLETE" );
	#endif
	#ifdef EGL_SYNC_PRIOR_COMMANDS_COMPLETE
		swigIntConstant( EGL_SYNC_PRIOR_COMMANDS_COMPLETE, "EGL_SYNC_PRIOR_COMMANDS_COMPLETE" );
	#endif
	#ifdef EGL_SYNC_TYPE
		swigIntConstant( EGL_SYNC_TYPE, "EGL_SYNC_TYPE" );
	#endif
	#ifdef EGL_SYNC_STATUS
		swigIntConstant( EGL_SYNC_STATUS, "EGL_SYNC_STATUS" );
	#endif
	#ifdef EGL_SYNC_CONDITION
		swigIntConstant( EGL_SYNC_CONDITION, "EGL_SYNC_CONDITION" );
	#endif
	#ifdef EGL_SIGNALED
		swigIntConstant( EGL_SIGNALED, "EGL_SIGNALED" );
	#endif
	#ifdef EGL_UNSIGNALED
		swigIntConstant( EGL_UNSIGNALED, "EGL_UNSIGNALED" );
	#endif
	#ifdef EGL_SYNC_FLUSH_COMMANDS_BIT
		swigIntConstant( EGL_SYNC_FLUSH_COMMANDS_BIT, "EGL_SYNC_FLUSH_COMMANDS_BIT" );
	#endif
	#ifdef EGL_TIMEOUT_EXPIRED
		swigIntConstant( EGL_TIMEOUT_EXPIRED, "EGL_TIMEOUT_EXPIRED" );
	#endif
	#ifdef EGL_CONDITION_SATISFIED
		swigIntConstant( EGL_CONDITION_SATISFIED, "EGL_CONDITION_SATISFIED" );
	#endif
	#ifdef EGL_SYNC_FENCE
		swigIntConstant( EGL_SYNC_FENCE, "EGL_SYNC_FENCE" );
	#endif
	#ifdef EGL_GL_COLORSPACE
		swigIntConstant( EGL_GL_COLORSPACE, "EGL_GL_COLORSPACE" );
	#endif
	#ifdef EGL_GL_COLORSPACE_SRGB
		swigIntConstant( EGL_GL_COLORSPACE_SRGB, "EGL_GL_COLORSPACE_SRGB" );
	#endif
	#ifdef EGL_GL_COLORSPACE_LINEAR
		swigIntConstant( EGL_GL_COLORSPACE_LINEAR, "EGL_GL_COLORSPACE_LINEAR" );
	#endif
	#ifdef EGL_GL_RENDERBUFFER
		swigIntConstant( EGL_GL_RENDERBUFFER, "EGL_GL_RENDERBUFFER" );
	#endif
	#ifdef EGL_GL_TEXTURE_2D
		swigIntConstant( EGL_GL_TEXTURE_2D, "EGL_GL_TEXTURE_2D" );
	#endif
	#ifdef EGL_GL_TEXTURE_LEVEL
		swigIntConstant( EGL_GL_TEXTURE_LEVEL, "EGL_GL_TEXTURE_LEVEL" );
	#endif
	#ifdef EGL_GL_TEXTURE_3D
		swigIntConstant( EGL_GL_TEXTURE_3D, "EGL_GL_TEXTURE_3D" );
	#endif
	#ifdef EGL_GL_TEXTURE_ZOFFSET
		swigIntConstant( EGL_GL_TEXTURE_ZOFFSET, "EGL_GL_TEXTURE_ZOFFSET" );
	#endif
	#ifdef EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X
		swigIntConstant( EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X, "EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X" );
	#endif
	#ifdef EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X
		swigIntConstant( EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X, "EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X" );
	#endif
	#ifdef EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y
		swigIntConstant( EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y, "EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y" );
	#endif
	#ifdef EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y
		swigIntConstant( EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, "EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y" );
	#endif
	#ifdef EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z
		swigIntConstant( EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z, "EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z" );
	#endif
	#ifdef EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
		swigIntConstant( EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, "EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z" );
	#endif
	#ifdef EGL_IMAGE_PRESERVED
		swigIntConstant( EGL_IMAGE_PRESERVED, "EGL_IMAGE_PRESERVED" );
	#endif

	swigNewline();

	swigComment("----===< long constants >===-----\n");
	#ifdef EGL_FOREVER
		swigUnsignedLongConstant( EGL_FOREVER, "EGL_FOREVER" );
	#endif

	swigNewline();

	swigComment("------===< functions >===-------\n");
	swigFunction( "c-function eglChooseConfig eglChooseConfig a a a n a -- u", "FUNCTION: eglChooseConfig ( dpy attrib_list configs config_size num_config -- u )", "EXTERN: \"C\" int eglChooseConfig( void * dpy, void * attrib_list, void * configs, int config_size, void * num_config );", "	( dpy attrib_list configs config_size num_config -- )" );
	swigFunction( "c-function eglCopyBuffers eglCopyBuffers a a n -- u", "FUNCTION: eglCopyBuffers ( dpy surface target -- u )", "EXTERN: \"C\" int eglCopyBuffers( void * dpy, void * surface, long target );", "	( dpy surface target -- )" );
	swigFunction( "c-function eglCreateContext eglCreateContext a a a a -- a", "FUNCTION: eglCreateContext ( dpy config share_context attrib_list -- a )", "EXTERN: \"C\" void * eglCreateContext( void * dpy, void * config, void * share_context, void * attrib_list );", "	( dpy config share_context attrib_list -- )" );
	swigFunction( "c-function eglCreatePbufferSurface eglCreatePbufferSurface a a a -- a", "FUNCTION: eglCreatePbufferSurface ( dpy config attrib_list -- a )", "EXTERN: \"C\" void * eglCreatePbufferSurface( void * dpy, void * config, void * attrib_list );", "	( dpy config attrib_list -- )" );
	swigFunction( "c-function eglCreatePixmapSurface eglCreatePixmapSurface a a n a -- a", "FUNCTION: eglCreatePixmapSurface ( dpy config pixmap attrib_list -- a )", "EXTERN: \"C\" void * eglCreatePixmapSurface( void * dpy, void * config, long pixmap, void * attrib_list );", "	( dpy config pixmap attrib_list -- )" );
	swigFunction( "c-function eglCreateWindowSurface eglCreateWindowSurface a a n a -- a", "FUNCTION: eglCreateWindowSurface ( dpy config win attrib_list -- a )", "EXTERN: \"C\" void * eglCreateWindowSurface( void * dpy, void * config, long win, void * attrib_list );", "	( dpy config win attrib_list -- )" );
	swigFunction( "c-function eglDestroyContext eglDestroyContext a a -- u", "FUNCTION: eglDestroyContext ( dpy ctx -- u )", "EXTERN: \"C\" int eglDestroyContext( void * dpy, void * ctx );", "	( dpy ctx -- )" );
	swigFunction( "c-function eglDestroySurface eglDestroySurface a a -- u", "FUNCTION: eglDestroySurface ( dpy surface -- u )", "EXTERN: \"C\" int eglDestroySurface( void * dpy, void * surface );", "	( dpy surface -- )" );
	swigFunction( "c-function eglGetConfigAttrib eglGetConfigAttrib a a n a -- u", "FUNCTION: eglGetConfigAttrib ( dpy config attribute value -- u )", "EXTERN: \"C\" int eglGetConfigAttrib( void * dpy, void * config, int attribute, void * value );", "	( dpy config attribute value -- )" );
	swigFunction( "c-function eglGetConfigs eglGetConfigs a a n a -- u", "FUNCTION: eglGetConfigs ( dpy configs config_size num_config -- u )", "EXTERN: \"C\" int eglGetConfigs( void * dpy, void * configs, int config_size, void * num_config );", "	( dpy configs config_size num_config -- )" );
	swigFunction( "c-function eglGetCurrentDisplay eglGetCurrentDisplay  -- a", "FUNCTION: eglGetCurrentDisplay (  -- a )", "EXTERN: \"C\" void * eglGetCurrentDisplay(  );", "	( -- )" );
	swigFunction( "c-function eglGetCurrentSurface eglGetCurrentSurface n -- a", "FUNCTION: eglGetCurrentSurface ( readdraw -- a )", "EXTERN: \"C\" void * eglGetCurrentSurface( int readdraw );", "	( readdraw -- )" );
	swigFunction( "c-function eglGetDisplay eglGetDisplay a -- a", "FUNCTION: eglGetDisplay ( display_id -- a )", "EXTERN: \"C\" void * eglGetDisplay( void * display_id );", "	( display_id -- )" );
	swigFunction( "c-function eglGetError eglGetError  -- n", "FUNCTION: eglGetError (  -- n )", "EXTERN: \"C\" int eglGetError(  );", "	( -- )" );
	swigFunction( "c-function eglGetProcAddress eglGetProcAddress s -- a", "FUNCTION: eglGetProcAddress ( procname -- a )", "EXTERN: \"C\" void * eglGetProcAddress( char * procname );", "	( procname -- )" );
	swigFunction( "c-function eglInitialize eglInitialize a a a -- u", "FUNCTION: eglInitialize ( dpy major minor -- u )", "EXTERN: \"C\" int eglInitialize( void * dpy, void * major, void * minor );", "	( dpy major minor -- )" );
	swigFunction( "c-function eglMakeCurrent eglMakeCurrent a a a a -- u", "FUNCTION: eglMakeCurrent ( dpy draw read ctx -- u )", "EXTERN: \"C\" int eglMakeCurrent( void * dpy, void * draw, void * read, void * ctx );", "	( dpy draw read ctx -- )" );
	swigFunction( "c-function eglQueryContext eglQueryContext a a n a -- u", "FUNCTION: eglQueryContext ( dpy ctx attribute value -- u )", "EXTERN: \"C\" int eglQueryContext( void * dpy, void * ctx, int attribute, void * value );", "	( dpy ctx attribute value -- )" );
	swigFunction( "c-function eglQueryString eglQueryString a n -- s", "FUNCTION: eglQueryString ( dpy name -- s )", "EXTERN: \"C\" char * eglQueryString( void * dpy, int name );", "	( dpy name -- )" );
	swigFunction( "c-function eglQuerySurface eglQuerySurface a a n a -- u", "FUNCTION: eglQuerySurface ( dpy surface attribute value -- u )", "EXTERN: \"C\" int eglQuerySurface( void * dpy, void * surface, int attribute, void * value );", "	( dpy surface attribute value -- )" );
	swigFunction( "c-function eglSwapBuffers eglSwapBuffers a a -- u", "FUNCTION: eglSwapBuffers ( dpy surface -- u )", "EXTERN: \"C\" int eglSwapBuffers( void * dpy, void * surface );", "	( dpy surface -- )" );
	swigFunction( "c-function eglTerminate eglTerminate a -- u", "FUNCTION: eglTerminate ( dpy -- u )", "EXTERN: \"C\" int eglTerminate( void * dpy );", "	( dpy -- )" );
	swigFunction( "c-function eglWaitGL eglWaitGL  -- u", "FUNCTION: eglWaitGL (  -- u )", "EXTERN: \"C\" int eglWaitGL(  );", "	( -- )" );
	swigFunction( "c-function eglWaitNative eglWaitNative n -- u", "FUNCTION: eglWaitNative ( engine -- u )", "EXTERN: \"C\" int eglWaitNative( int engine );", "	( engine -- )" );
	swigFunction( "c-function eglBindTexImage eglBindTexImage a a n -- u", "FUNCTION: eglBindTexImage ( dpy surface buffer -- u )", "EXTERN: \"C\" int eglBindTexImage( void * dpy, void * surface, int buffer );", "	( dpy surface buffer -- )" );
	swigFunction( "c-function eglReleaseTexImage eglReleaseTexImage a a n -- u", "FUNCTION: eglReleaseTexImage ( dpy surface buffer -- u )", "EXTERN: \"C\" int eglReleaseTexImage( void * dpy, void * surface, int buffer );", "	( dpy surface buffer -- )" );
	swigFunction( "c-function eglSurfaceAttrib eglSurfaceAttrib a a n n -- u", "FUNCTION: eglSurfaceAttrib ( dpy surface attribute value -- u )", "EXTERN: \"C\" int eglSurfaceAttrib( void * dpy, void * surface, int attribute, int value );", "	( dpy surface attribute value -- )" );
	swigFunction( "c-function eglSwapInterval eglSwapInterval a n -- u", "FUNCTION: eglSwapInterval ( dpy interval -- u )", "EXTERN: \"C\" int eglSwapInterval( void * dpy, int interval );", "	( dpy interval -- )" );
	swigFunction( "c-function eglBindAPI eglBindAPI u -- u", "FUNCTION: eglBindAPI ( api -- u )", "EXTERN: \"C\" int eglBindAPI( int api );", "	( api -- )" );
	swigFunction( "c-function eglQueryAPI eglQueryAPI  -- u", "FUNCTION: eglQueryAPI (  -- u )", "EXTERN: \"C\" int eglQueryAPI(  );", "	( -- )" );
	swigFunction( "c-function eglCreatePbufferFromClientBuffer eglCreatePbufferFromClientBuffer a u a a a -- a", "FUNCTION: eglCreatePbufferFromClientBuffer ( dpy buftype buffer config attrib_list -- a )", "EXTERN: \"C\" void * eglCreatePbufferFromClientBuffer( void * dpy, int buftype, void * buffer, void * config, void * attrib_list );", "	( dpy buftype buffer config attrib_list -- )" );
	swigFunction( "c-function eglReleaseThread eglReleaseThread  -- u", "FUNCTION: eglReleaseThread (  -- u )", "EXTERN: \"C\" int eglReleaseThread(  );", "	( -- )" );
	swigFunction( "c-function eglWaitClient eglWaitClient  -- u", "FUNCTION: eglWaitClient (  -- u )", "EXTERN: \"C\" int eglWaitClient(  );", "	( -- )" );
	swigFunction( "c-function eglGetCurrentContext eglGetCurrentContext  -- a", "FUNCTION: eglGetCurrentContext (  -- a )", "EXTERN: \"C\" void * eglGetCurrentContext(  );", "	( -- )" );
	swigFunction( "c-function eglCreateSync eglCreateSync a u a -- a", "FUNCTION: eglCreateSync ( dpy type attrib_list -- a )", "EXTERN: \"C\" void * eglCreateSync( void * dpy, int type, void * attrib_list );", "	( dpy type attrib_list -- )" );
	swigFunction( "c-function eglDestroySync eglDestroySync a a -- u", "FUNCTION: eglDestroySync ( dpy sync -- u )", "EXTERN: \"C\" int eglDestroySync( void * dpy, void * sync );", "	( dpy sync -- )" );
	swigFunction( "c-function eglClientWaitSync eglClientWaitSync a a n d -- n", "FUNCTION: eglClientWaitSync ( dpy sync flags timeout -- n )", "EXTERN: \"C\" int eglClientWaitSync( void * dpy, void * sync, int flags, long long timeout );", "	( dpy sync flags timeout -- )" );
	swigFunction( "c-function eglGetSyncAttrib eglGetSyncAttrib a a n a -- u", "FUNCTION: eglGetSyncAttrib ( dpy sync attribute value -- u )", "EXTERN: \"C\" int eglGetSyncAttrib( void * dpy, void * sync, int attribute, void * value );", "	( dpy sync attribute value -- )" );
	swigFunction( "c-function eglCreateImage eglCreateImage a a u a a -- a", "FUNCTION: eglCreateImage ( dpy ctx target buffer attrib_list -- a )", "EXTERN: \"C\" void * eglCreateImage( void * dpy, void * ctx, int target, void * buffer, void * attrib_list );", "	( dpy ctx target buffer attrib_list -- )" );
	swigFunction( "c-function eglDestroyImage eglDestroyImage a a -- u", "FUNCTION: eglDestroyImage ( dpy image -- u )", "EXTERN: \"C\" int eglDestroyImage( void * dpy, void * image );", "	( dpy image -- )" );
	swigFunction( "c-function eglGetPlatformDisplay eglGetPlatformDisplay u a a -- a", "FUNCTION: eglGetPlatformDisplay ( platform native_display attrib_list -- a )", "EXTERN: \"C\" void * eglGetPlatformDisplay( int platform, void * native_display, void * attrib_list );", "	( platform native_display attrib_list -- )" );
	swigFunction( "c-function eglCreatePlatformWindowSurface eglCreatePlatformWindowSurface a a a a -- a", "FUNCTION: eglCreatePlatformWindowSurface ( dpy config native_window attrib_list -- a )", "EXTERN: \"C\" void * eglCreatePlatformWindowSurface( void * dpy, void * config, void * native_window, void * attrib_list );", "	( dpy config native_window attrib_list -- )" );
	swigFunction( "c-function eglCreatePlatformPixmapSurface eglCreatePlatformPixmapSurface a a a a -- a", "FUNCTION: eglCreatePlatformPixmapSurface ( dpy config native_pixmap attrib_list -- a )", "EXTERN: \"C\" void * eglCreatePlatformPixmapSurface( void * dpy, void * config, void * native_pixmap, void * attrib_list );", "	( dpy config native_pixmap attrib_list -- )" );
	swigFunction( "c-function eglWaitSync eglWaitSync a a n -- u", "FUNCTION: eglWaitSync ( dpy sync flags -- u )", "EXTERN: \"C\" int eglWaitSync( void * dpy, void * sync, int flags );", "	( dpy sync flags -- )" );

	swigNewline();

	swigComment("----===< postfix >===-----\n");

	swigPrint( "end-c-library", "( none )", "( none )" );
	
	return 0;
} /* end of main */



