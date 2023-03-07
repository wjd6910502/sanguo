#ifndef UTF16_STRING_H_
#define UTF16_STRING_H_

#include <string>

typedef unsigned short utf16_char;
typedef std::basic_string<utf16_char> utf16string;

inline utf16string make_utf16string(wchar_t const* str)
{
	return utf16string(str, str + wcslen(str));
}

inline utf16string make_utf16string(std::wstring str)
{
	return utf16string(str.begin(), str.end());
}


inline std::wstring make_wstring(utf16_char const* utf16str)
{
	//calc end pos
	utf16_char const* walker = utf16str;
	while (*walker)
		++walker;

	return std::wstring(utf16str, walker);
}

inline std::wstring make_wstring(utf16string str)
{
	return std::wstring(str.begin(), str.end());
}

inline unsigned int utf16_strlen(utf16_char const* str)
{
	unsigned int count = 0;
	while (*str++)
		++count;
	return count;
}

#endif //ndef UTF16_STRING_H_
