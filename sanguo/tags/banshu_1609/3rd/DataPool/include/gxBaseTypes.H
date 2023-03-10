#ifndef _GRAPX_BASE_TYPES_H_
#define _GRAPX_BASE_TYPES_H_

#if defined(GXDLL_API_EXPORTS)
#define GXDLL       __declspec(dllexport)
#elif defined(GXDLL_API_IMPORTS)
#define GXDLL       __declspec(dllimport)
#elif defined(GXDLL_API_INDEPENDENT)
#define GXDLL
#else
#define GXDLL       __declspec(dllimport)
#endif

#ifdef _WIN32
#define _GXW64                 __w64
#define GXCALLBACK             __stdcall
#define GXAPI                  __stdcall
#elif defined(_IOS)
#define _GXW64
#define GXCALLBACK
#define GXAPI
#elif defined(_ANDROID)
#define _GXW64
#define GXCALLBACK
#define GXAPI
#elif defined(_LINUX)
#define _GXW64
#define GXCALLBACK
#define GXAPI
#else
#define _GXW64
#define GXCALLBACK             
#define GXAPI                  __stdcall
#endif

#define GXDLLAPI               GXDLL GXAPI


#define GXTRUE                 1
#define GXFALSE                0
#define GXNULL                 0
#define GXCONST                const
#define GXPURE                 = 0


typedef char            GXCHAR;
typedef short           GXSHORT;
typedef int             GXINT;
typedef long            GXLONG;
typedef unsigned char   GXUCHAR;
typedef unsigned char   GXBYTE;
typedef unsigned short  GXUSHORT;
typedef i8              GXINT8;
typedef u8              GXUINT8;
typedef i8              GXBOOL8;
typedef i16             GXINT16;
typedef u16             GXUINT16;
typedef i16             GXBOOL16;
typedef wch             GXWCHAR;
typedef u32             GXSIZE_T;
typedef unsigned short  GXWORD;
typedef unsigned int    GXUINT;
typedef unsigned long   GXULONG;
typedef unsigned int    GXDWORD;
typedef unsigned long   GXCOLORREF;
typedef unsigned long   GXCOLOR;
typedef float           GXFLOAT;
typedef void            GXVOID;
typedef void*           GXLPVOID;
typedef GXCONST void*   GXLPCVOID;
typedef int             GXBOOL;

typedef char              *GXLPCHAR, *LPGXCHAR;
typedef GXINT*            GXLPINT;
typedef GXUINT*           GXLPUINT;
typedef GXLONG*           GXLPLONG;
typedef GXBYTE*           GXLPBYTE;
typedef GXSHORT*          GXLPSHORT;
typedef GXDWORD*          GXLPDWORD;
typedef GXBOOL*           GXLPBOOL;

typedef GXCONST GXINT*    GXLPCINT;
typedef GXCONST GXUINT*   GXLPCUINT;
typedef GXCONST GXLONG*   GXLPCLONG;
typedef GXCONST GXBYTE*   GXLPCBYTE;
typedef GXCONST GXSHORT*  GXLPCSHORT;
typedef GXCONST GXDWORD*  GXLPCDWORD;

typedef i64               GXLONGLONG;

// ??????????????????
#ifdef _X86
typedef _GXW64 GXUINT   GXUINT_PTR;
typedef _GXW64 GXINT    GXINT_PTR;
typedef _GXW64 GXLONG   GXLONG_PTR;
typedef _GXW64 GXULONG  GXULONG_PTR;
typedef _GXW64 GXDWORD  GXDWORD_PTR;

#elif _X64
typedef u64             GXUINT_PTR;
typedef i64             GXINT_PTR;
typedef i64             GXLONG_PTR;
typedef u64             GXULONG_PTR;
typedef u64             GXDWORD_PTR;

#elif _ARM
typedef GXUINT          GXUINT_PTR;
typedef GXINT           GXINT_PTR;
typedef GXLONG          GXLONG_PTR;
typedef GXULONG         GXULONG_PTR;
typedef GXDWORD         GXDWORD_PTR;
#else
#error must define instruction platform.
#endif // #ifdef _X86

typedef GXUINT_PTR      GXWPARAM;
typedef GXLONG_PTR      GXLPARAM;
typedef GXLONG_PTR      GXLRESULT;
typedef GXLONG          GXHRESULT;

typedef GXWCHAR         *GXLPWSTR, *LPGXWSTR, *GXLPWCHAR;
typedef GXCHAR          *GXLPSTR, *LPGXSTR, *GXLPCHAR;
typedef GXCONST GXWCHAR *GXLPCWSTR, *LPGXCWSTR;
typedef GXCONST GXCHAR  *GXLPCSTR, *LPGXCSTR;
//typedef void            *HGXRGN;
//typedef void            *HGXMENU,*GXHMENU;

#ifdef _UNICODE
typedef GXLPCWSTR GXLPCTSTR;
typedef GXLPWSTR  GXLPTSTR;
typedef GXWCHAR   GXTCHAR;
#else
typedef GXLPCSTR  GXLPCTSTR;
typedef GXLPSTR   GXLPTSTR;
typedef GXCHAR    GXTCHAR;
#endif // _UNICODE

class GXColor32
{
public:
  union
  {
    GXDWORD color;
    GXDWORD ARGB;
    struct{
      GXBYTE b;
      GXBYTE g;
      GXBYTE r;
      GXBYTE a;
    };
  };
  GXColor32(){}
  GXColor32(int _r, int _g, int _b) : r(_r), g(_g), b(_b), a(255) {}
  GXColor32(int _a, int _r, int _g, int _b) : r(_r), g(_g), b(_b), a(_a) {}
  GXColor32(const GXColor32& clr) : color(clr.color){}
  GXColor32(GXDWORD clr) : color(clr){}

  //operator const GXDWORD() { return color; }
  //operator GXDWORD() { return color; }
  operator const GXCOLORREF() { return color; }
  operator GXCOLORREF() { return color; }
  b32 operator !=(GXDWORD dwVal) const { return color != dwVal; }
  GXCOLORREF operator |(GXCOLORREF clr) const { return color | clr; }
  GXCOLORREF operator &(GXCOLORREF clr) const { return color & clr; }
};

//class GXColor
//{
//
//};

//typedef clstd::COLOR_RGBA_F GXColor;
//////////////////////////////////////////////////////////////////////////
#endif // _GRAPX_BASE_TYPES_H_
