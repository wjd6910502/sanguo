#ifndef _CL_UTILITY_
#define _CL_UTILITY_

#define clrand    rand
#define clrand_s  rand_s

template<typename _T1, typename _T2>
inline _T1 clMax(_T1 a, _T2 b)
{
  return a > b ? a : b;
}

template<typename _T1, typename _T2>
inline _T1 clMin(_T1 a, _T2 b)
{
  return (_T1)(a < b ? a : b);
}

template<typename _T>
inline void clSwap(_T& a, _T& b)
{
  _T t = a;
  a = b;
  b = t;
}

template<typename _T>
inline void clSwapX(_T& a, _T& b)
{
  a = a ^ b;
  b = a ^ b;
  a = a ^ b;
}

template<typename _T>
inline void clSwap32(_T& a, _T& b)
{
  (*(u32*)&a) = ((*(u32*)&a) ^ (*(u32*)&b));
  (*(u32*)&b) = ((*(u32*)&a) ^ (*(u32*)&b));
  (*(u32*)&a) = ((*(u32*)&a) ^ (*(u32*)&b));
}

namespace clstd
{
  template <class _TElement>
  void BubbleSort(_TElement* array, int count)
  {
    for(int i = 0; i < count - 1; i++)
    {
      for(int n = 0; n < count - i - 1; n++)
      {
        ASSERT(n + 1 < count);
        if(array[n].SortCompare(array[n + 1]))
        {
          array[n].SortSwap(array[n + 1]);
        }
      }
    }
  }

  template <class _TElement>
  void QuickSortClassic(_TElement* array, int start, int end)  // 循环不包含end
  {
    if(start >= end)
      return;

    const _TElement& x = array[end - 1];
    int i = start;
    for(int j = start; j < end; j++)
    {
      if(x.SortCompare(array[j])) {
        if(i != j) {
          array[i].SortSwap(array[j]);
        }
        i++;
      }
    }
    if(i != end - 1)
    {
      array[i].SortSwap(array[end - 1]);
    }
    QuickSort(array, start, i);
    QuickSort(array, i + 1, end);
  }

  template <class _TElement, typename _Ty>
  void QuickSort(_TElement* array, _Ty start, _Ty end)
  {
    struct CONTEXT{
      _Ty s, e;
    };
    clstack<CONTEXT> aStack;
    CONTEXT ctx;
    while(1) {
      const _TElement& x = array[end - 1];
      _Ty i = start;
      for(_Ty j = start; j < end - 1; j++)
      {
        if(x.SortCompare(array[j]))
        {
          if(j != i)
            array[i].SortSwap(array[j]);
          i++;
        }
      }
      if(i != end - 1)
        array[i].SortSwap(array[end - 1]);

      if(start < i) {
        ctx.s = start;
        ctx.e = i;
        aStack.push(ctx);
      }
      if(i + 1 < end) {
        start = i + 1;
        continue;
      }
      if(aStack.size() > 0) {
        start = aStack.top().s;
        end   = aStack.top().e;
        aStack.pop();
      }
      else break;
    };
  }
  //////////////////////////////////////////////////////////////////////////
  //************************************
  // Method:    ResolveString 分解字符串到一个数组中
  // Parameter: const _String& str 要分解的字符串
  // Parameter: _TCh ch 使用的分隔符
  // Parameter: _StringArray& aStr 数组对象，可以是vector，list等
  //************************************
  template <class _String, typename _TCh, class _StringArray>
  void ResolveString(const _String& str, _TCh ch, _StringArray& aStr)
  {
    size_t start = 0;
    size_t pos;
    size_t len = str.GetLength();
    do {
      pos = str.Find(ch, start);
      if(pos == _String::npos) {
        pos = len;
      }
      _String strPart = str.SubString(start, pos - start);
      aStr.push_back(strPart);
      start = pos + 1;
    }while(pos != len);
  }

  //////////////////////////////////////////////////////////////////////////
  //
  // 高效按照特定符号分解字符串的类
  // 除了修改目标字符串外不会产生多余的对象/内存分配
  //
  template <class _TString>
  class StringCutter
  {
    typedef typename _TString::LPCSTR T_LPCSTR;
    typedef typename _TString::TChar  T_CHAR;
    //size_t      m_start;
    size_t      m_pos;
    size_t      m_length;
    T_LPCSTR    m_str;
      
  public:
    StringCutter() : m_pos(0), m_str(""), m_length(0) {}
    StringCutter(T_LPCSTR str, size_t len = 0) : m_pos(0), m_str(str), m_length(len) {}

    // TODO: 增加一个返回字符串地址和长度，避免构造string的方法

    _TString& Cut(_TString& strOut, T_CHAR ch)
    {
      T_CHAR c;
      const size_t start = m_pos;
      while((m_length == 0 || m_pos < m_length) && (c = m_str[m_pos]) != '\0') {
        if(c == ch) {
          break;
        }
        m_pos++;
      }

      strOut.Clear();
      strOut.Append(&m_str[start], m_pos - start);
      m_pos = (c == '\0' || (m_length != 0 && m_pos == m_length)) ? m_pos : m_pos + 1;
      return strOut;
    }

    void Set(T_LPCSTR str, size_t len = 0)
    {
      m_pos = 0;
      m_str = str;
      m_length = len;
    }

    b32 IsEndOfString()
    {
      return m_str[m_pos] == '\0' || (m_pos == m_length && m_length != 0);
    }

    void Reset()
    {
      m_pos = 0;
    }
  };  

  //////////////////////////////////////////////////////////////////////////

  template <class _String>
  void TranslateEscapeCharacter(_String& str) // 输入/输出
  {
    int i = 0;
    int d = 0;
    typename _String::TChar* pStr = str.GetBuffer();
    do {
      if(pStr[i] == '\\') {
        i++;
        switch(pStr[i])
        {
        case 'n':
          pStr[d++] = '\n'; break;
        case 'r':
          pStr[d++] = '\r'; break;
        case 't':
          pStr[d++] = '\t'; break;
        case '\\':
          pStr[d++] = '\\'; break;
        default:
          pStr[d++] = pStr[i];  break;
        }
      }
      else {
        pStr[d++] = pStr[i];
      }
    } while(pStr[i++] != '\0');

    str.ReleaseBuffer();
  }

} // namespace clstd

#endif // _CL_UTILITY_