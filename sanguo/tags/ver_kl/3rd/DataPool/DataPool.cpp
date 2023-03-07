#include "clstd.h"
#include "clString.H"
#include "smartstream.h"
#include "clStringSet.h"
#include "clPathFile.h"
#include "clBuffer.H"
#include "clFile.H"
#include "clUtility.H"
#include "SmartStock.h"
#include "GrapX.H"
//#include "GrapX.Hxx"
//#include "clstd/Smart/smartstream.h"
//#include "clstd/clPathFile.h"
//#include "clstd/clStringSet.h"
//#include "clstd/Smart/SmartStock.h"
//#include "clstd/clTextLines.h"
#include "include/GUnknown.H"
#include "include/DataPool.H"
#include "include/DataPoolIterator.h"
#include "include/DataPoolVariable.H"
//#include "Include/GXKernel.H"
//#include "Include/GXUser.H"
//#include "gxError.H"
#include "AFile.h"

#include "DataPoolVariableVtbl.h"
using namespace clstd;

// TODO:
// [C]1.无符号类型是：“unsigned_int” 要改为 “unsigned int”
// [C]2.IsFixed应该使用更简易的方法判断
// [C]3.暂不支持object类型
// [C]4.“SetAsXXXXXX”想一个更美观的名字
// 5.DataPoolVariable考虑重构为指针
// [F]6.动态数组要额外分配一个class ArrayBuffer : public clBuffer指针，要考虑改为实体，减少可能的内存碎片
// 7.考虑支持typedef关键字
// [C]8.动态数组去掉‘#’方式的记录
// 9.支持const方式
// [C]10.编译行号，编译时语法检查
// 11.获得全称如“var[139].left”
// [C]12.描述结构是否也能添加定址，和数据放在一个内存块里
// [C]13.遍历接口 iterator
// [C]14.消除 struct A{ A a; } 这种自引用问题
// 15.Remove需要增加一个接口可以删除若干成员，删除成员还有遍历，清理object，string和动态数组
// 16.动态数组目前只增不减
// 17.增加参考类型，相当于指针指向有效的变量
// [C]18.save时的指针重定位，功能与load重定位合并，封装为标准函数
// [C]19.64位加载问题
// [C]20.迭代器分为具名和匿名两种实现
// 21.clStringA 的支持
// 22.多编码支持

#define GSIT_Variables (m_aGSIT)
#define GSIT_Members   (m_aGSIT + m_nNumOfVar)
#define GSIT_Enums     (m_aGSIT + m_nNumOfVar + m_nNumOfMember)

#define V_WRITE(_FUNC, _TIPS) if( ! (_FUNC)) { CLOG_ERROR(_TIPS); return FALSE; }
#define V_READ(_FUNC, _TIPS)  if( ! (_FUNC)) { CLOG_ERROR(_TIPS); return FALSE; }
#define SIZEOF_PTR          sizeof(void*)
#define SIZEOF_PTR32        sizeof(GXDWORD)
#define SIZEOF_PTR64        sizeof(GXQWORD)
#define TYPE_CHANGED_FLAG   0x80000000  // 类型扩展或者缩减时的标记，记在TYPE_DESC::Cate上，用后要清除!

#ifdef _DEBUG
# define INC_DBGNUMOFSTRING ++m_nDbgNumOfString
# define INC_DBGNUMOFARRAY  ++m_nDbgNumOfArray
#else
# define INC_DBGNUMOFSTRING
# define INC_DBGNUMOFARRAY
#endif // 

#ifdef _X86
# define ASSERT_X86(x)   ASSERT(x)
# define ASSERT_X64(x)
#elif defined(_X64)
# define ASSERT_X86(x)
# define ASSERT_X64(x)   ASSERT(x)
#else
# define ASSERT_X86(x)
# define ASSERT_X64(x)
#endif // #ifdef _X86

//#ifdef _X86
//  STATIC_ASSERT(sizeof(DataPool::TYPE_DESC) == 20);
//#else _X64
//  STATIC_ASSERT(sizeof(DataPool::TYPE_DESC) == 24);
//#endif

  typedef DataPoolVariable              Variable;
  typedef const DataPool::VARIABLE_DESC DPVDD;

  //
  // 保存用的内部结构体
  //
  typedef clvector<GXUINT>      UIntArray;
  struct BUFFER_SAVELOAD_DESC // 用于读写时临时储存的buffer描述
  {
    enum RelocalizeType // 重定位表附加描述（32位）
    {
      RelocalizeType_Array   = (0 << 28),
      RelocalizeType_String  = (1 << 28),
      RelocalizeType_StringA = (2 << 28),
      RelocalizeTypeMask     = 0xf0000000,
      RelocalizeOffsetMask   = ~RelocalizeTypeMask,
    };

    clBufferBase* _pBuffer;
    //UIntArray     RelTable;   // 重定位表, 参考RelocalizeType
    // 2号重定位表，用来开发从函数收集的方法，这个成熟后去掉1号表，去掉文件记录
    UIntArray     RelTable;  // 重定位表, 参考RelocalizeType, 这个是平台无关的，指针按照32位计算
    DataPool::LPCTD    pTypeDesc;

    // 模板函数原型： fn(RelocalizeType type, GXUINT nOffset, GXLPBYTE& pDest, GXLPCBYTE& pSrc); 注意最后两个要是引用
    template<class _Fn>
    GXUINT_PTR RelocalizePtr(clBufferBase* pDestBuffer, const clBufferBase* pSourceBuffer, _Fn fn)
    {
      clsize nCopy;

      if(RelTable.empty()) {
        // 不含指针的buffer大小一定相等
        ASSERT(pDestBuffer->GetSize() == pSourceBuffer->GetSize());

        nCopy = pSourceBuffer->GetSize();
        memcpy(pDestBuffer->GetPtr(), pSourceBuffer->GetPtr(), nCopy);
        return nCopy;
      }
      GXLPBYTE pDest = (GXLPBYTE)pDestBuffer->GetPtr();
      GXLPCBYTE pSrc = (GXLPCBYTE)pSourceBuffer->GetPtr();
      GXSIZE_T nRelOffset = 0; // 这个是平台相关的，要注意64bits下的修改

      for(auto itRel = RelTable.begin(); itRel != RelTable.end(); ++itRel)
      {
        auto& offset = *itRel;
        nCopy = (offset & RelocalizeOffsetMask) - nRelOffset;
        if(nCopy)
        {
          memcpy(pDest, pSrc, nCopy);
          pDest += nCopy;
          pSrc += nCopy;
        }

        fn((RelocalizeType)(offset & RelocalizeTypeMask),
          offset & RelocalizeOffsetMask, pDest, pSrc);

        nRelOffset += (nCopy + sizeof(GXUINT));
        //nRelOffset += (nCopy + SIZEOF_PTR);
      }

      nCopy = (clsize)pSourceBuffer->GetPtr() + pSourceBuffer->GetSize() - (clsize)pSrc;
      if(nCopy) {
        memcpy(pDest, pSrc, nCopy);
      }

      return ((GXUINT_PTR)pDest - (GXUINT_PTR)pDestBuffer->GetPtr() + nCopy);
    }

    static clsize GetPtrAdjustSize(clsize nCountOfRelTab) // 指针修正尺寸
    {
      // 磁盘上指针都被转换为32位无符号整数
      return (SIZEOF_PTR - sizeof(GXUINT)) * nCountOfRelTab;
    }

    clsize GetPtrAdjustSize() const // 指针修正尺寸
    {
      return GetPtrAdjustSize(RelTable.size());
    }

    clsize GetDiskBufferSize() const
    {
      // 最终尺寸应该考虑减去把所有指针转换为4字节整数的差值
      return _pBuffer->GetSize() - GetPtrAdjustSize();
    }

    void GenerateRelocalizeTable(DataPool::LPCTD pTypeDesc)
    {
      // 外部保证这个, 全局变量使用另一个重载方法
      ASSERT(pTypeDesc != NULL);

      // 使用这个缓冲上的动态数组必须匹配, 大小也肯定是类型长度的整数倍, 空的话表示这个是全局变量
      ASSERT((_pBuffer->GetSize() % pTypeDesc->_cbSize) == 0);

      const GXUINT nCount = _pBuffer->GetSize() / pTypeDesc->_cbSize;

      GXUINT nBase = 0; // 基础偏移
      switch(pTypeDesc->Cate)
      {
      case T_STRUCT:
        for(GXUINT i = 0; i < nCount; ++i) {
          nBase = GenerateRelocalizeTable(nBase, pTypeDesc->GetMembers(), pTypeDesc->nMemberCount);
        }
        break;
      case T_STRING:  GenerateRelocalizeTable(nBase, RelocalizeType_String, nCount);   break;
      case T_STRINGA: GenerateRelocalizeTable(nBase, RelocalizeType_StringA, nCount);  break;
      }
    }

    GXUINT GenerateRelocalizeTable(GXUINT nBase, RelocalizeType eRelType, GXUINT nCount)
    {
      for(GXUINT n = 0; n < nCount; ++n) {
        RelTable.push_back(nBase | eRelType);
        nBase += SIZEOF_PTR32;
      }
      return nBase;
    }

    // 迭代收集重定位表,平台无关，指针按照4字节计算
    GXUINT GenerateRelocalizeTable(GXUINT nBase, DataPool::LPCVD pVarDesc, GXUINT nCount)
    {
      for(GXUINT i = 0; i < nCount; ++i)
      {
        const DataPool::VARIABLE_DESC& vd = pVarDesc[i];
        if(vd.IsDynamicArray())
        {
          RelTable.push_back(nBase | RelocalizeType_Array);
          nBase += SIZEOF_PTR32;
        }
        else
        {
          ASSERT(vd.nCount >= 1);

          switch(vd.GetTypeCategory())
          {
          case T_STRUCT:
            for(GXUINT n = 0; n < vd.nCount; ++n) {
              nBase = GenerateRelocalizeTable(nBase, vd.MemberBeginPtr(), vd.MemberCount());
            }
            break;

          case T_STRING:  nBase = GenerateRelocalizeTable(nBase, RelocalizeType_String, vd.nCount);   break;
          case T_STRINGA: nBase = GenerateRelocalizeTable(nBase, RelocalizeType_StringA, vd.nCount);  break;
          default:        nBase += vd.GetSize();  break;
          } // switch
        }
      } // for
      return nBase;
    }

    //void DbgCheck() // 验证文件记录和自己收集的重定位表一致性，收集算法稳定后去掉表1
    //{
    //  ASSERT(RelTable.size() == RelTable2.size());

    //  clsize count = RelTable.size();
    //  for(clsize i = 0; i < count; ++i)
    //  {
    //    ASSERT(RelTable[i] == RelTable2[i]);
    //  }
    //}
  };
  typedef clvector<BUFFER_SAVELOAD_DESC> BufDescArray;

  namespace Implement
  {
    extern TYPE_DECLARATION c_InternalTypeDefine[];
    extern DataPoolVariable::VTBL* s_pPrimaryVtbl;
    extern DataPoolVariable::VTBL* s_pEnumVtbl;
    extern DataPoolVariable::VTBL* s_pFlagVtbl;
    extern DataPoolVariable::VTBL* s_pStringVtbl;
    extern DataPoolVariable::VTBL* s_pStringAVtbl;
    extern DataPoolVariable::VTBL* s_pStructVtbl;
    extern DataPoolVariable::VTBL* s_pStaticArrayVtbl;
    //extern DataPoolVariable::VTBL* s_pDynamicPrimaryVtbl;
    //extern DataPoolVariable::VTBL* s_pDynamicObjectVtbl;
    //extern DataPoolVariable::VTBL* s_pDynamicStructVtbl;
    extern DataPoolVariable::VTBL* s_pDynamicArrayVtbl;
  } // namespace Implement



  GXBOOL DataPool::Initialize(LPCTYPEDECL pTypeDecl, LPCVARDECL pVarDecl)
  {
    if(pVarDecl == NULL) {
      return FALSE;
    }
    //FloatVarTypeDict FloatDict; // 很多事情还没有确定下来的类型表, 浮动的
    DataPoolBuildTime sBuildTime;   // 构建时使用的结构

    // 创建浮动类型表
    // -- 内置类型表示是被信任的,不进行合法性检查,Debug版还是要稍微检查下的
#ifdef _DEBUG
    if( ! sBuildTime.IntCheckTypeDecl(Implement::c_InternalTypeDefine, TRUE))
      return FALSE;
#else
    if( ! sBuildTime.IntCheckTypeDecl(Implement::c_InternalTypeDefine, FALSE))
      return FALSE;
#endif // #ifdef _DEBUG9
    if(pTypeDecl != NULL) {
      if( ! sBuildTime.IntCheckTypeDecl(pTypeDecl, TRUE))
        return FALSE;
    }

    // 检查变量类型
    if( ! sBuildTime.CheckVarList(pVarDecl)) {
      return FALSE;
    }

    GXINT nBufferSize = sBuildTime.CalculateVarSize(pVarDecl, sBuildTime.m_aVar);
    if(nBufferSize == 0) {
      CLOG_ERROR("%s: Empty data pool.\n", __FUNCTION__);
      return FALSE;
    }

    // 定位各种描述表
    LocalizeTables(sBuildTime, nBufferSize);
    
    InitializeValue(0, pVarDecl);

    //m_bFixedPool = IntIsRawPool();
    return TRUE;
  }



  GXBOOL DataPool::Clear(GXLPVOID lpBuffer, LPCVD pVarDesc, int nVarCount)
  {
    GXBYTE* pData = (GXBYTE*)lpBuffer;//m_pBuffer->GetPtr() + nBaseOffset;
    for(int i = 0; i < nVarCount; i++)
    {
      const VARIABLE_DESC& VARDesc = pVarDesc[i];
      GXBOOL bDynamicArray = VARDesc.IsDynamicArray();
      DataPoolArray** ppBuffer = NULL;

      GXLPVOID ptr;
      int nCount = 0;

      if(bDynamicArray) // 动态字符串数组
      {
        ppBuffer = VARDesc.GetAsBufferPtr(pData);
        if(*ppBuffer == NULL) {
          continue;
        }
        ptr = (*ppBuffer)->GetPtr();
        nCount = (int)((*ppBuffer)->GetSize() / VARDesc.TypeSize());
      }
      else // 字符串数组
      {
        ptr = VARDesc.GetAsPtr(pData);
        nCount = VARDesc.nCount;
      }

      switch(VARDesc.GetTypeCategory())
      {
      case T_STRING:
        {
          clStringW* pString = reinterpret_cast<clStringW*>(ptr);

          // 依次调用析构函数
          for(int nStringIndex = 0; nStringIndex < nCount; nStringIndex++)
          {
            if(pString[nStringIndex]) {
              pString[nStringIndex].~clStringX();
#ifdef _DEBUG
              m_nDbgNumOfString--;
#endif // #ifdef _DEBUG
            }
          }
        }
        break;

      case T_STRINGA:
        {
          clStringA* pString = reinterpret_cast<clStringA*>(ptr);

          // 依次调用析构函数
          for(int nStringIndex = 0; nStringIndex < nCount; nStringIndex++)
          {
            if(pString[nStringIndex]) {
              pString[nStringIndex].~clStringX();
#ifdef _DEBUG
              m_nDbgNumOfString--;
#endif // #ifdef _DEBUG
            }
          }
        }
        break;

      case T_STRUCT:
        {
          for(int nStructIndex = 0; nStructIndex < nCount; nStructIndex++)
          {
            Clear(ptr, VARDesc.MemberBeginPtr(),//&m_aMembers[VARDesc.MemberBegin()], 
              VARDesc.MemberCount());
            ptr = (GXLPBYTE)ptr + VARDesc.TypeSize();
          }
          //if(bDynamicArray) {
          //  SAFE_DELETE(*ppBuffer);
          //}
        }
        break;
      }
      
      if(bDynamicArray)
      {
        // ppBuffer 可能在上面的判断中已经设置，如果没设置就是基础类型动态数组。
        ASSERT(ppBuffer == NULL || ppBuffer == VARDesc.GetAsBufferPtr(pData));

        ppBuffer = VARDesc.GetAsBufferPtr(pData); // (clBuffer**)(pData + VARDesc.nOffset);
        if(*ppBuffer)
        {
          delete (*ppBuffer);
          *ppBuffer = NULL;
#ifdef _DEBUG
          m_nDbgNumOfArray--;
#endif // #ifdef _DEBUG
        }
      }

    }
    return TRUE;
  }

  DataPool::LPCVD DataPool::IntGetVariable(LPCVD pVdd, GXLPCSTR szName/*, int nIndex*/)
  {
    // TODO: 这里可以改为比较Name Id的方式，Name Id可以就是m_Buffer中的偏移
    LPCVD pDesc = NULL;
    int begin = 0, end;
    if(pVdd != NULL) {

      // 只有结构体才有成员, 其他情况直接返回
      if(pVdd->GetTypeCategory() != T_STRUCT) {
        return NULL;
      }
      end   = pVdd->MemberCount();
      pDesc = pVdd->MemberBeginPtr();
      //ASSERT(nEnd <= (int)m_nNumOfMember);
    }
    else {
      end   = m_nNumOfVar;
      pDesc = m_aVariables;
    }

    SortedIndexType* p = m_aGSIT + (pDesc - m_aVariables);

#ifdef _DEBUG
    GXUINT count = (GXUINT)end;
    //for(int i = begin; i < end; ++i)
    //{
    //  TRACE("%2d %*s %s\n", i, -32, pDesc[i].VariableName(), pDesc[p[i]].VariableName());
    //}
#endif // #ifdef _DEBUG
    //*
    while(begin <= end - 1)
    {
      int mid = (begin + end) >> 1;
      ASSERT(p[mid] < count); // 索引肯定低于总大小
      LPCVD pCurDesc = pDesc + p[mid];
      //TRACE("%s\n", pCurDesc->VariableName());
      int result = GXSTRCMP(szName, pCurDesc->VariableName());
      if(result < 0) {
        end = mid;
      }
      else if(result > 0){
        if(begin == mid) {
          break;
        }
        begin = mid;
      }
      else {
        return pCurDesc;
      }
    }//*/
#ifdef _DEBUG
    for(int i = begin; i < (int)count; i++)
    {
      if(GXSTRCMP(pDesc[i].VariableName(), szName) == 0) {
        CLBREAK;
        return &pDesc[i];
      }
    }
#endif // #ifdef _DEBUG
    return NULL;
  }

  GXVOID DataPool::InitializeValue(GXUINT nBaseOffset, LPCVARDECL pVarDecl)
  {
    int nVarIndex = 0;
    GXBYTE* pData = (GXBYTE*)m_VarBuffer.GetPtr();
    for(;; nVarIndex++)
    {
      // 下面两个开头故意写成不一样的, 否则不太容易区分, 太像了!
      const VARIABLE_DECLARATION& varDecl = pVarDecl[nVarIndex];
      if(varDecl.Type == NULL || varDecl.Name == NULL) {
        break;
      }
      const VARIABLE_DESC& VARDesc = m_aVariables[nVarIndex];

      GXBOOL bDynamicArray = VARDesc.IsDynamicArray();
      ASSERT(GXSTRCMPI(VARDesc.VariableName(), varDecl.Name) == 0);
      switch(VARDesc.GetTypeCategory())
      {
      case T_STRUCT:
        {
          int nMemberIndex;
          //int nStart = VARDesc.MemberBegin();
          int nEnd = VARDesc.MemberCount();
          auto pMembers = VARDesc.MemberBeginPtr();

          // 对于含有动态数组和字符串的结构体是不能直接赋值的
          for(nMemberIndex = 0; nMemberIndex < nEnd; nMemberIndex++)
          {
            if(pMembers[nMemberIndex].GetTypeCategory() == T_STRING || 
              pMembers[nMemberIndex].GetTypeCategory() == T_STRINGA || 
              pMembers[nMemberIndex].IsDynamicArray())
              break;
          }
          if(nMemberIndex != nEnd)
            break;
        } // 这里没有 break, 如果 Struct 中没有动态数组和字符串声明, 支持初始数据.
      case T_BYTE:
      case T_WORD:
      case T_DWORD:
      case T_QWORD:
      case T_SBYTE:
      case T_SWORD:
      case T_SDWORD:
      case T_SQWORD:
      case T_FLOAT:
        if(varDecl.Init != NULL)
        {
          if(bDynamicArray)
          {
            ASSERT(varDecl.Count < 0);
            clBuffer* pBuffer = VARDesc.CreateAsBuffer(this, pData, varDecl.Init == NULL ? 0 : -varDecl.Count);
            memcpy(pBuffer->GetPtr(), varDecl.Init, pBuffer->GetSize());
          }
          else
          {
            memcpy(VARDesc.GetAsPtr(pData), varDecl.Init, VARDesc.GetSize());
          }
        }
        break;
        //case T_Struct:
        //  //if(varDecl.Init != NULL)
        //  break;
      case T_STRING:
        {
          GXLPCWSTR  pStrInit = (GXLPCWSTR)varDecl.Init;
          clStringW* pStrPool = NULL;
          int nCount = varDecl.Init == NULL ? 0 : varDecl.Count;
          if(bDynamicArray)
          {
            ASSERT(VARDesc.TypeSize() == sizeof(clStringW));

            // 如果没有初始化数据, 则初始维度设置为0
            ASSERT((varDecl.Init != NULL && nCount < 0) || 
              (varDecl.Init == NULL && nCount == 0));

            pStrPool = (clStringW*)VARDesc.CreateAsBuffer(this, pData, -nCount)->GetPtr();
            nCount = -nCount;
          }
          else
          {
            pStrPool = VARDesc.GetAsStringW(pData);
          }

          // 这个写的太变态了!!
          for(int i = 0; i < nCount; i++)
          {
            clStringW& str = pStrPool[i];
            new(&str) clStringW;
            INC_DBGNUMOFSTRING;
            if(pStrInit != NULL)
            {
              str = pStrInit;
              pStrInit += str.GetLength() + 1;
            }
          }
        } // case
        break;
      }
    }
  }

  GXBOOL DataPool::IsIllegalName(GXLPCSTR szName)
  {
    int i = 0;
    while(szName[i] != '\0')
    {
      if( ! (szName[i] == '_' || 
        (szName[i] >= 'a' && szName[i] <= 'z') ||
        (szName[i] >= 'A' && szName[i] <= 'Z') ||
        (szName[i] >= '0' && szName[i] <= '9' && i > 0)) ) {
          return FALSE;
      }
      i++;
    }
    return i > 0;
  }

  DataPool::DataPool()
    : m_nNumOfTypes (0)
    , m_aTypes      (NULL)
    , m_nNumOfVar   (0)
    , m_aVariables  (NULL)
    , m_nNumOfMember(0)
    , m_aMembers    (NULL)
    , m_nNumOfEnums (0)
    , m_aEnums      (NULL)
    , m_aGSIT       (NULL)
    //, m_StringBase  (0)
    , m_bFixedPool  (1)
    , m_bReadOnly   (0)
#ifdef _DEBUG
    , m_nDbgNumOfArray (0)
    , m_nDbgNumOfString(0)
#endif // #ifdef _DEBUG
  {
  }

  DataPool::~DataPool()
  {
    // 清理池中的数据
    // 主要是清理动态数组，字符串，对象和结构体
    // 结构体会产生递归，遍历其下的数据类型
    if(m_nNumOfVar && ( ! m_bReadOnly)) {
      Clear(m_VarBuffer.GetPtr(), m_aVariables, (int)m_nNumOfVar);
      ASSERT(m_nDbgNumOfArray == 0);
      ASSERT(m_nDbgNumOfString == 0);
    }

//#ifdef DATAPOOLCOMPILER_PROJECT
//#else
//    if(m_Name.IsNotEmpty())
//    {
//      GXLPSTATION lpStation = GXSTATION_PTR(GXUIGetStation());
//      GXSTATION::NamedInterfaceDict::iterator it = lpStation->m_NamedPool.find(m_Name);
//      if(it != lpStation->m_NamedPool.end()) {
//        lpStation->m_NamedPool.erase(it);
//      }
//      else {
//        CLBREAK; // 不应该啊, 肿么找不到了呢?
//      }
//    }
//#endif // #ifdef DATAPOOLCOMPILER_PROJECT


    //SAFE_DELETE(m_pBuffer);
  }

#ifdef ENABLE_VIRTUALIZE_ADDREF_RELEASE

  GXHRESULT DataPool::AddRef()
  {
    return ++m_nRefCount;
  }

  GXHRESULT DataPool::Release()
  {
    GXLONG nRefCount = --m_nRefCount;
    if(nRefCount == 0) {
      delete this;
      return GX_OK;
    }
    return m_uRefCount;
  }

#endif // #ifdef ENABLE_VIRTUALIZE_ADDREF_RELEASE

  GXLPCSTR DataPool::GetVariableName(GXUINT nIndex) const
  {
    if(nIndex >= m_nNumOfVar) {
      return NULL;
    }

    return (m_aVariables[nIndex].VariableName());
  }

  const DataPool::TYPE_DESC* DataPool::FindType(GXLPCSTR szTypeName) const
  {
    for(GXUINT i = 0; i < m_nNumOfTypes; ++i)
    {
      if(GXSTRCMP(m_aTypes[i].GetName(), szTypeName) == 0) {
        return &m_aTypes[i];
      }
    }
    return NULL;
  }

#ifdef DATAPOOLCOMPILER_PROJECT
#else
  GXHRESULT DataPool::GetLayout(GXLPCSTR szStructName, DataLayoutArray* pLayout)
  {
    LPCVD   pVarDesc = m_aVariables;
    GXUINT  nCount = (GXUINT)m_nNumOfVar;

    if(szStructName != NULL)
    {
      //TypeDict::const_iterator itType = m_TypeDict.find(szStructName);
      //if(itType == m_TypeDict.end()) {
      //  CLBREAK;
      //  return GX_FAIL;
      //}
      LPCTD pDesc = FindType(szStructName);
      pVarDesc = pDesc->GetMembers(); //&m_aMembers[pDesc->nMemberIndex];
      nCount   = pDesc->nMemberCount;
    }

    for(GXUINT i = 0; i < nCount; i++)
    {
      DATALAYOUT DataLayout;
      DataLayout.eType = GXUB_UNDEFINED;
      DataLayout.pName = pVarDesc->VariableName();
      DataLayout.uOffset = pVarDesc->nOffset;
      DataLayout.uSize = pVarDesc->TypeSize();
      pLayout->push_back(DataLayout);
      pVarDesc++;
    }

    return GX_OK;
  }
#endif // #ifdef DATAPOOLCOMPILER_PROJECT

  GXBOOL DataPool::IsFixedPool()
  {
    return (GXBOOL)m_bFixedPool;
  }

  GXLPVOID DataPool::GetFixedDataPtr()
  {
    return m_bFixedPool ? m_VarBuffer.GetPtr() : NULL;
  }

  GXBOOL DataPool::QueryByName(GXLPCSTR szName, Variable* pVar)
  {
    VARIABLE var = {0};
    // 这是什么鬼啊，当时为什么判断它有效？ if(pVar->IsValid() || ( ! IntQuery(&m_VarBuffer, NULL, szName, 0, &var))) {
    if( ! IntQuery(&m_VarBuffer, NULL, szName, 0, &var)) {
      pVar->Free();
      return FALSE;
    }

    if(pVar->GetPoolUnsafe() == this) {
      new(pVar) DataPoolVariable((DataPoolVariable::VTBL*)var.vtbl, var.pVdd, var.pBuffer, var.AbsOffset);
    } else {
      pVar->Free();
      new(pVar) DataPoolVariable((DataPoolVariable::VTBL*)var.vtbl, this, var.pVdd, var.pBuffer, var.AbsOffset);
    }
    return TRUE;
  }

  GXBOOL DataPool::IntQueryByExpression(GXLPCSTR szExpression, VARIABLE* pVar)
  {
    GXLPCSTR  szName;         // 用来查找的名字
    GXUINT    nIndex = (GXUINT)-1;
    clStringA str;
    clStringA strName; // 用来暂存带下标时的变量名
    GXBOOL result = TRUE;

    // 分解表达式
    clstd::StringCutter<clStringA> sExpression(szExpression);

    do {
      sExpression.Cut(str, '.');

      if(str.EndsWith(']')) // 带下标的情况
      {
        size_t pos = str.Find('[', 0);
        if(pos == clStringA::npos) {
          CLBREAK;
          result = FALSE;
          break;
        }
        clStringA strIndex = str.SubString(pos + 1, str.GetLength() - pos - 2);
        strName = str.Left(pos);
        nIndex = GXATOI((GXLPCSTR)strIndex);
        szName = strName;
      }
      else {
        nIndex = -1;
        szName = str;
      }

      if( ! pVar->IsValid()) {
        result = IntQuery(&m_VarBuffer, NULL, szName, 0, pVar);
      }
      else {
        result = IntQuery(pVar->pBuffer, pVar->pVdd, szName, pVar->AbsOffset, pVar);
        //stVariable = stVariable.MemberOf(szName);
      }

      // 这里没有检查stVariable有效性，要保证即使无效IndexOf()也不会崩溃
      if(result && nIndex != (GXUINT)-1) {
        // 这段就是实现了DataPoolVariable::GetLength()
        const GXBOOL bDynamic = pVar->pVdd->IsDynamicArray();
        if(( ! bDynamic && nIndex < pVar->pVdd->nCount) ||
          (bDynamic && nIndex < pVar->pBuffer->GetSize() / pVar->pVdd->TypeSize()))
        {
          // pVar->nOffset 包含了 pVar->pVdd->nOffset
          //IntCreateUnary(pVar->pBuffer, pVar->pVdd, 
          //  pVar->nOffset - pVar->pVdd->nOffset + nIndex * pVar->pVdd->TypeSize(), pVar);
          IntCreateUnary(pVar->pBuffer, pVar->pVdd, nIndex * pVar->pVdd->TypeSize(), pVar);
        }
        else {
          result = FALSE;
        }
      }

      if(( ! result) || ( ! pVar->IsValid())) {
        result = FALSE;
        break;
      }
    } while( ! sExpression.IsEndOfString());

    return result;
  }

  GXBOOL DataPool::QueryByExpression(GXLPCSTR szExpression, Variable* pVar)
  {
    VARIABLE var = {0};

    GXBOOL bval = IntQueryByExpression(szExpression, &var);

    if( ! bval) {
      pVar->Free();
    }
    else {
      //if( ! pVar->IsValid()) {
      //  pVar->Free();
      //}
      pVar->~DataPoolVariable();
      new(pVar) DataPoolVariable((DataPoolVariable::VTBL*)var.vtbl, this, var.pVdd, var.pBuffer, var.AbsOffset);
    }
    return bval;
  }

  DataPool::LPCVD DataPool::IntFindVariable(LPCVD pVarDesc, int nCount, GXUINT nOffset)
  {
    int begin = 0;
    int end = nCount - 1;
    auto nEndOffset = pVarDesc[end].nOffset + pVarDesc[end].GetUsageSize();
    while(1)
    {
      const int mid = (begin + end) >> 1;
      if(pVarDesc[begin].nOffset <= nOffset && nOffset < pVarDesc[mid].nOffset) {
        end = mid;
        nEndOffset = pVarDesc[end].nOffset + pVarDesc[end].GetUsageSize();
      }
      else if(pVarDesc[mid].nOffset <= nOffset && nOffset <= nEndOffset) {
        if(begin == mid) {
          break;
        }
        begin = mid;
      }
    }

    if(pVarDesc[end].nOffset >= nOffset) {
      return pVarDesc + end;
    }
    else if(pVarDesc[begin].nOffset >= nOffset) {
      return pVarDesc + begin;
    }

    return NULL;
  }

  GXBOOL DataPool::FindFullName( clStringA* str, LPCVD pVarDesc, clBufferBase* pBuffer, GXUINT nOffset )
  {
    LPCVD pVar;
    if(pBuffer == &m_VarBuffer) {
      pVar = IntFindVariable(m_aVariables, m_nNumOfVar, nOffset);
      if(pVarDesc == pVar) {
        *str = pVar->VariableName();
        return TRUE;
      }
      //CLNOP;
    }
    return FALSE;
  }



  GXBOOL DataPool::IntCreateUnary(clBufferBase* pBufferBase, LPCVD pThisVdd, int nOffsetAdd, VARIABLE* pVar)
  {
    using namespace Implement;
    GXBYTE* pDataBuffer = (GXBYTE*)pBufferBase->GetPtr();
    const GXBOOL bRootBuf = ((GXLPCVOID)pBufferBase == (GXLPCVOID)&m_VarBuffer);
    ASSERT(nOffsetAdd >= 0 && pThisVdd->TypeSize() != 0);
    //ASSERT(bRootBuf || (! bRootBuf && pThisVdd->IsDynamicArray()));

    VARIABLE::VTBL* pVtbl = NULL;
    if( ! pThisVdd->IsDynamicArray()) {
      //nOffsetAdd += pThisVdd->nOffset;
      nOffsetAdd += pVar->AbsOffset;
    }

    pVtbl = pThisVdd->GetUnaryMethod();
    ASSERT(pVtbl != NULL);

    pVar->Set((VARIABLE::VTBL*)pVtbl, pThisVdd, pBufferBase, nOffsetAdd);
    //new(pVar) DataPoolVariable(pVtbl, this, pThisVdd, pBufferBase, nOffsetAdd);
    return TRUE;
  }

  GXBOOL DataPool::IntQuery(clBufferBase* pBufferBase, DPVDD* pParentVdd, GXLPCSTR szVariable, int nOffsetAdd, VARIABLE* pVar)
  {
    // 内部函数中不改变pVar->m_pDataPool的引用计数
    using namespace Implement;
    GXBYTE* pDataBuffer = (GXBYTE*)pBufferBase->GetPtr();
    DPVDD* pVdd = IntGetVariable(pParentVdd, szVariable);
    const GXBOOL bRootBuf = ((GXLPCVOID)pBufferBase == (GXLPCVOID)&m_VarBuffer);
    ASSERT(bRootBuf || ( ! bRootBuf && pParentVdd != NULL));
    //ASSERT( ! pVar->IsValid());
    if(pVdd == NULL) {
      return FALSE;
    }
    /*
    if(pVdd->IsDynamicArray()) {
      clBuffer* pElementBuffer = pVdd->CreateAsBuffer((GXBYTE*)m_pBuffer->GetPtr() + nOffsetAdd, 0);
      pVar->Set((VARIABLE::VTBL*)s_pDynamicArrayVtbl, pVdd, pElementBuffer, 0);
      return GX_OK;
    }
    else if(pVdd->nCount > 1) {
      if(bRootBuf) {
        pVar->Set((VARIABLE::VTBL*)s_pStaticArrayVtbl, pVdd, m_pBuffer, pVdd->nOffset + nOffsetAdd);
        return GX_OK;
      }
      else {
        CLBREAK;
      }
    }
    /*/
    if(pVdd->IsDynamicArray()) {
      clBuffer* pElementBuffer = pVdd->CreateAsBuffer(this, (GXBYTE*)pBufferBase->GetPtr() + nOffsetAdd, 0);
      pVar->Set((VARIABLE::VTBL*)s_pDynamicArrayVtbl, pVdd, pElementBuffer, 0);
      return TRUE;
    }
    else if(pVdd->nCount > 1) {
      pVar->Set((VARIABLE::VTBL*)s_pStaticArrayVtbl, pVdd, pBufferBase, pVdd->nOffset + nOffsetAdd);
      return TRUE;
    }//*/
    else {
      ASSERT(pVdd->nCount == 1);
      pVar->AbsOffset = pVdd->nOffset;
      return IntCreateUnary(pBufferBase, pVdd, nOffsetAdd, pVar);
    }
    return FALSE;
  }


#define IS_VALID_NAME(_NAME)  (_NAME != NULL && clstd::strlenT(_NAME) > 0)


  GXHRESULT DataPool::CreateFromResolver(DataPool** ppDataPool, DataPoolCompiler* pResolver)
  {    
    if(pResolver) {
      DataPoolCompiler::MANIFEST sManifest;
      if(GXSUCCEEDED(pResolver->GetManifest(&sManifest)) &&
         GXSUCCEEDED(CreateDataPool(ppDataPool, sManifest.pTypes, sManifest.pVariables)))
      {
        if(sManifest.pImportFiles)
        {
          for(auto it = sManifest.pImportFiles->begin(); it != sManifest.pImportFiles->end(); ++it)
          {
            // 出错也继续导入
            (*ppDataPool)->ImportDataFromFileW((GXLPCWSTR)*it);
          }
        }
        return GX_OK;
      }
      return GX_FAIL;
    }
    else {
      return CreateDataPool(ppDataPool, NULL, NULL);
    }
    return GX_FAIL;
  }

  GXHRESULT DataPool::CompileFromMemory(DataPool** ppDataPool, DataPoolInclude* pInclude, GXLPCSTR szDefinitionCodes, GXSIZE_T nCodeLength)
  {
    DataPoolCompiler* pResolver = NULL;
    GXHRESULT hval = szDefinitionCodes == NULL ? GX_OK :
      DataPoolCompiler::CreateFromMemory(&pResolver, pInclude, szDefinitionCodes, nCodeLength);
    if(GXSUCCEEDED(hval))
    {
      hval = CreateFromResolver(ppDataPool, pResolver);
      SAFE_RELEASE(pResolver);
    }
    return hval;
  }

  const clBufferBase* DataPool::IntGetEntryBuffer() const
  {
    return &m_VarBuffer;
  }

  class DefaultDataPoolInclude : public DataPoolInclude
  {
  public:
    GXHRESULT Open(IncludeType eIncludeType, GXLPCWSTR pFileName, GXLPVOID lpParentData, GXLPCVOID *ppData, GXUINT *pBytes)
    {
      //clStringW str = pFileName;
      //clpathfile::RemoveFileSpecW(str);
      //clpathfile::CombinePathW(str, str, pFileName);
      clstd::File file;
      if(file.OpenExistingW(pFileName) && file.MapToBuffer((CLBYTE**)ppData, 0, 0, pBytes)) {
        return GX_OK;
      }
      return GX_FAIL;
    }

    GXHRESULT Close(GXLPCVOID pData)
    {
      const CLBYTE* ptr = (const CLBYTE*)pData;
      SAFE_DELETE_ARRAY(ptr);
      return GX_OK;
    }
  };

  GXHRESULT DataPool::CompileFromFileW(DataPool** ppDataPool, GXLPCWSTR szFilename, DataPoolInclude* pInclude)
  {
    clstd::File file;
    GXHRESULT hval = GX_FAIL;
    if(file.OpenExistingW(szFilename))
    {
      clBuffer* pBuffer;
      DefaultDataPoolInclude IncludeImpl;
      if(file.MapToBuffer(&pBuffer)) {
        // TODO: 这个从文件加载要检查BOM，并转换为Unicode格式
        clStringA strDefine;
        clStringA strFilename = szFilename;
        strDefine.Format("#FILE %s\n#LINE 1\n", (clStringA::LPCSTR)strFilename);
        pBuffer->Insert(0, (GXLPCSTR)strDefine, strDefine.GetLength());

        hval = CompileFromMemory(ppDataPool, pInclude ? pInclude : &IncludeImpl, (GXLPCSTR)pBuffer->GetPtr(), pBuffer->GetSize());
        delete pBuffer;
        pBuffer = NULL;
      }
    }
    else {
      hval = GX_E_OPEN_FAILED;
    }
    return hval;
  }

  //DataPool::LPCENUMDESC DataPool::IntGetEnum( GXUINT nPackIndex ) const
  //{
  //  // ************************************************************************
  //  // 这里最开始写成了返回enum desc的引用
  //  // 但是使用Name自定位后发现Release版返回值经过了优化，会导致Name自定位到无效地址
  //  // 为了保证指针稳定，改成了返回指针
  //  //
  //  return &m_aEnums[nPackIndex];
  //  //return m_aEnumPck[nPackIndex];
  //}

  inline GXUINT ConvertToNewOffsetFromOldIndex(const STRINGSETDESC* pTable, int nOldIndex)
  {
    return (GXUINT)pTable[nOldIndex].offset;
  }

  void DataPool::CopyVariables(VARIABLE_DESC* pDestVarDesc, GXLPCVOID pSrcVector, const STRINGSETDESC* pTable, GXINT_PTR lpBase)
  {
    const BUILDTIME::BTVarDescArray& SrcVector = *(BUILDTIME::BTVarDescArray*)pSrcVector;
    int i = 0;
    for(auto it = SrcVector.begin(); it != SrcVector.end(); ++it, ++i)
    {
      const BUILDTIME::BT_VARIABLE_DESC& sBtDesc = *it;
      VARIABLE_DESC& sDesc = pDestVarDesc[i];
      sDesc.TypeDesc = (GXUINT)((GXINT_PTR)&sDesc.TypeDesc - (GXINT_PTR)&m_aTypes[((BUILDTIME::BT_TYPE_DESC*)sBtDesc.GetTypeDesc())->nIndex]);
      sDesc.nName     = ConvertToNewOffsetFromOldIndex(pTable, (int)sBtDesc.nName);
      sDesc.nOffset   = sBtDesc.nOffset;
      sDesc.nCount    = sBtDesc.nCount;
      sDesc.bDynamic  = sBtDesc.bDynamic;
      sDesc.bConst    = sBtDesc.bConst;

#ifdef DEBUG_DECL_NAME
      sDesc.Name      = (DataPool::LPCSTR)(lpBase + sDesc.nName);
      //TRACE("VAR:%16s %16s %8d\n", sDesc.GetTypeDesc()->Name, sDesc.Name, sDesc.nOffset);
#endif // DEBUG_DECL_NAME
    }
  }

  clsize DataPool::LocalizePtr()
  {
    GXLPBYTE ptr = (GXLPBYTE)m_Buffer.GetPtr();

    auto cbTypes     = m_nNumOfTypes * sizeof(TYPE_DESC);
    auto cbGVSIT     = (m_nNumOfVar + m_nNumOfMember + m_nNumOfEnums) * sizeof(SortedIndexType);
    auto cbVariables = m_nNumOfVar * sizeof(VARIABLE_DESC);
    auto cbMembers   = m_nNumOfMember * sizeof(VARIABLE_DESC);
    auto cbEnums     = m_nNumOfEnums * sizeof(ENUM_DESC);

    m_aTypes      = (TYPE_DESC*)ptr;
    m_aGSIT       = (SortedIndexType*)(ptr + cbTypes);
    m_aVariables  = (VARIABLE_DESC*)(ptr + cbTypes + cbGVSIT);

    if(m_nNumOfMember) {
      m_aMembers = (VARIABLE_DESC*)(ptr + cbTypes + cbGVSIT + cbVariables);
    }

    if(m_nNumOfEnums) {
      m_aEnums = (ENUM_DESC*)(ptr + cbTypes + cbGVSIT + cbVariables + cbMembers);
    }

    return cbTypes + cbGVSIT + cbVariables + cbMembers + cbEnums;
  }

  void DataPool::DbgIntDump()
  {
    TRACE("========= Types =========\n");
    for(GXUINT i = 0; i < m_nNumOfTypes; ++i) {
      TRACE("%16s %8d\n", m_aTypes[i].GetName(), m_aTypes[i]._cbSize);
    }

    TRACE("========= Variables =========\n");
    for(GXUINT i = 0; i < m_nNumOfVar; ++i)
    {
      const auto& v = m_aVariables[i];
      if(v.nCount > 1) {
        TRACE("%16s %12s[%4d] %8d[%d]\n", v.TypeName(), v.VariableName(), v.nCount, v.nOffset, v.GetUsageSize());
      }
      else {
        TRACE("%16s %16s %10d[%d]\n", v.TypeName(), v.VariableName(), v.nOffset, v.GetUsageSize());
      }
    }

    TRACE("========= Members =========\n");
    for(GXUINT i = 0; i < m_nNumOfMember; ++i){
      const auto& v = m_aMembers[i];
      if(v.nCount > 1) {
        TRACE("%16s %12s[%4d] %8d[%d]\n", v.TypeName(), v.VariableName(), v.nCount, v.nOffset, v.GetUsageSize());
      }
      else {
        TRACE("%16s %16s %10d[%d]\n", v.TypeName(), v.VariableName(), v.nOffset, v.GetUsageSize());
      }
    }
  }

  void DataPool::LocalizeTables(BUILDTIME& bt, GXSIZE_T cbVarSpace)
  {
    // [MAIN BUFFER 结构表]:
    // #.Type desc table            类型描述表
    // #.GVSIT
    // #.Variable desc table        变量描述表
    // #.Struct members desc table  成员变量描述表
    // #.enum desc table            枚举描述表
    // #.Strings                    描述表中所有字符串的字符串表
    // #.Variable Data Space        变量空间

    m_nNumOfTypes  = (GXUINT)bt.m_TypeDict.size();
    m_nNumOfVar    = (GXUINT)bt.m_aVar.size();
    m_nNumOfMember = (GXUINT)bt.m_aStructMember.size();
    m_nNumOfEnums  = (GXUINT)bt.m_aEnumPck.size();

    auto cbTypes     = m_nNumOfTypes * sizeof(TYPE_DESC);
    auto cbGVSIT     = (m_nNumOfVar + m_nNumOfMember + m_nNumOfEnums) * sizeof(SortedIndexType);
    auto cbVariables = m_nNumOfVar * sizeof(VARIABLE_DESC);
    auto cbMembers   = m_nNumOfMember * sizeof(VARIABLE_DESC);
    auto cbEnums     = m_nNumOfEnums * sizeof(ENUM_DESC);
    auto cbHeader    = cbTypes + cbGVSIT+ cbVariables + cbMembers + cbEnums;
    m_Buffer.Resize(cbHeader + bt.NameSet.buffer_size() + cbVarSpace, FALSE);

#ifdef _DEBUG
    auto cbDbgSave = m_Buffer.GetSize();
#endif // #ifdef _DEBUG

    STRINGSETDESC* pTable = new STRINGSETDESC[bt.NameSet.size()];
    bt.NameSet.sort(pTable);

    memset((GXLPBYTE)m_Buffer.GetPtr() + cbHeader, 0, bt.NameSet.buffer_size());

    GXINT_PTR lpBase = (GXINT_PTR)bt.NameSet.GatherToBuffer(&m_Buffer, cbHeader);
    //m_StringBase = lpBase;

    ASSERT(cbDbgSave == m_Buffer.GetSize()); // 确保GatherToBuffer不会改变Buffer的长度

    LocalizePtr();
    //ASSERT(m_StringBase == lpBase);


    // * 以下复制表的操作中均包含字符串重定位

    // 复制类型描述表
    GXUINT nIndex = 0;
    for(auto it = bt.m_TypeDict.begin(); it != bt.m_TypeDict.end(); ++it, ++nIndex) {
      BUILDTIME::BT_TYPE_DESC& sBtType = it->second;
      TYPE_DESC& sType = m_aTypes[nIndex];
      sType.nName        = ConvertToNewOffsetFromOldIndex(pTable, (int)sBtType.nName);
      sType.Cate         = sBtType.Cate;
      sType._cbSize       = sBtType._cbSize;
      //sType.nMemberIndex = sBtType.nMemberIndex;
      sType.nMemberCount = sBtType.nMemberCount;

      if(sType.Cate == T_STRUCT) {
        sType.Member = (GXUINT)((GXUINT_PTR)&m_aMembers[sBtType.Member] - (GXUINT_PTR)&sType.Member);
      }
      else if(sType.Cate == T_ENUM || sType.Cate == T_FLAG) {
        sType.Member = (GXUINT)((GXUINT_PTR)&m_aEnums[sBtType.Member] - (GXUINT_PTR)&sType.Member);
      }                                                                                                                                                                             





































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































#ifdef DEBUG_DECL_NAME
      sType.Name         = (DataPool::LPCSTR)(lpBase + sType.nName);
      TRACE("TYPE[%d]: %16s %8d\n", nIndex, sType.Name, sType._cbSize);
#endif // DEBUG_DECL_NAME

      sBtType.nIndex = nIndex;
    }

    // 复制变量和成员变量描述表
    CopyVariables(m_aVariables, &bt.m_aVar, pTable, lpBase);
    CopyVariables(m_aMembers, &bt.m_aStructMember, pTable, lpBase);

    // 复制枚举描述表
    nIndex = 0;
    for(auto it = bt.m_aEnumPck.begin(); it != bt.m_aEnumPck.end(); ++it, ++nIndex) {
      const ENUM_DESC& sBtDesc = *it;
      ENUM_DESC& sDesc = m_aEnums[nIndex];

      sDesc.nName = ConvertToNewOffsetFromOldIndex(pTable, (int)sBtDesc.nName);
      sDesc.Value = sBtDesc.Value;

#ifdef DEBUG_DECL_NAME
      sDesc.Name  = (DataPool::LPCSTR)(lpBase + sDesc.nName);
#endif // DEBUG_DECL_NAME
    }

    // #.这个依赖于有效的 m_aVariables， m_aMembers 和 m_aEnums
    // #.排序依赖于描述中的 nName 成员，它会按递增排序
    // #.排序不改变m_aVariables， m_aMembers 和 m_aEnums上的顺序，
    //   而是生成有序的基于这些数组的索引，放到GSIT上
    // #.nName 在运行时使用了自定位方法，自定位化后它的值不能保证在
    //   GSIT上是递增的，所以自定位化放在后面进行
    GenGSIT();

    // 自定位化转换
    SelfLocalizable(m_aTypes,     m_nNumOfTypes,  lpBase);
    SelfLocalizable(m_aVariables, m_nNumOfVar,    lpBase);
    SelfLocalizable(m_aMembers,   m_nNumOfMember, lpBase);
    SelfLocalizable(m_aEnums,     m_nNumOfEnums,  lpBase);

    new(&m_VarBuffer) clstd::RefBuffer((GXLPBYTE)lpBase + bt.NameSet.buffer_size(), cbVarSpace);
    memset(m_VarBuffer.GetPtr(), 0, m_VarBuffer.GetSize());   // 只清除变量段的内存

    SAFE_DELETE_ARRAY(pTable);
  }

  void DataPool::GenGSIT()
  {
    SortNames<VARIABLE_DESC>(m_aVariables, GSIT_Variables, 0, m_nNumOfVar);

    for(GXUINT i = 0; i < m_nNumOfTypes; ++i) {
      const TYPE_DESC& t = m_aTypes[i];

      if(t.nMemberCount >= 1)
      {
        switch(t.Cate)
        {
        case T_STRUCT:
          //SortNames<VARIABLE_DESC>(m_aMembers, GSIT_Members + t.nMemberIndex, t.nMemberIndex, t.nMemberCount);
          //TRACE("var index:%d\n", t.GetMemberIndex(m_aMembers));
          SortNames<VARIABLE_DESC>(t.GetMembers(), GSIT_Members + t.GetMemberIndex(m_aMembers), 0, t.nMemberCount);
          break;
        case T_FLAG:
        case T_ENUM:
          //SortNames<ENUM_DESC>(m_aEnums, GSIT_Enums + t.nMemberIndex, t.nMemberIndex, t.nMemberCount);
          //TRACE("enum index:%d\n", t.GetEnumIndex(m_aEnums));
          SortNames<ENUM_DESC>(t.GetEnumMembers(), GSIT_Enums + t.GetEnumIndex(m_aEnums), 0, t.nMemberCount);
          break;
        }
      }
    }
  }

  template<class DescT>
  void DataPool::SelfLocalizable(DescT* pDescs, int nCount, GXINT_PTR lpBase)
  {
    for(int i = 0; i < nCount; ++i)
    {
      GXUINT* pName = &pDescs[i].nName;
      ASSERT(lpBase - (GXINT_PTR)pName > 0); // 保证 lpBase 在 &nName 的后面出现

      *pName = (GXUINT)(lpBase - (GXINT_PTR)pName + *pName);

#ifdef DEBUG_DECL_NAME
      DataPool::LPCSTR szName = (DataPool::LPCSTR)((GXINT_PTR)&pDescs[i].nName + pDescs[i].nName);
      ASSERT(szName == pDescs[i].Name || pDescs[i].Name == NULL);
#endif // #ifdef DEBUG_DECL_NAME
    }
  }

  template<class DescT>
  void DataPool::SortNames( const DescT* pDescs, SortedIndexType* pDest, int nBegin, int nCount)
  {
    //ASSERT(pDest == &m_aGVSIT[nTargetTopIndex]);
    struct CONTEXT
    {
      GXUINT index;
      GXUINT name;

      b32 SortCompare(const CONTEXT& b) const
      {
        return name > b.name;
      }

      void SortSwap(CONTEXT& b)
      {
        clSwapX(index, b.index);
        clSwapX(name, b.name);
      }
    };

    CONTEXT* pContext = new CONTEXT[nCount];
    auto prev = pDescs[nBegin].nName;
    GXUINT mask = 0;
    for(int i = 0; i < nCount; ++i)
    {
      //pContext[i].index = nBegin + i; // GVSIT的索引已经加了Group的偏移
      //pContext[i].name = pDescs[i + nBegin].nName;
      pContext[i].index = i; // GVSIT的索引已经加了Group的偏移
      pContext[i].name = pDescs[i].nName;
      //m_aGVSIT[nTargetTopIndex + i] = pContext[i].index;
      pDest[i] = pContext[i].index;

      //TRACE("name:%d\n", pContext[i].name);

      mask |= pContext[i].name - prev;
      prev = pContext[i].name;
    }

    if(mask >> 31) // 检查名字是不是已经按照从大到校的顺序排序了
    {
      clstd::QuickSort(pContext, 0, nCount);
#ifdef _DEBUG
      prev = pContext->index;
#endif
      for(int i = 0; i < nCount; ++i)
      {
        //m_aGVSIT[nTargetTopIndex + i] = pContext[i].index;
        pDest[i] = pContext[i].index;
#ifdef _DEBUG
        ASSERT(pDescs[pContext[i].index].nName >= pDescs[prev].nName);
        prev = pContext[i].index;
#endif
      }
    }

    SAFE_DELETE_ARRAY(pContext);
  }

  GXBOOL DataPool::IntFindEnumFlagValue( LPCTD pTypeDesc, LPCSTR szName, EnumFlag* pOutEnumFlag ) GXCONST
  {
    const auto* p = GSIT_Enums + pTypeDesc->GetEnumIndex(m_aEnums);
    int begin = 0;
    int end = pTypeDesc->nMemberCount;
    LPCED aEnums = pTypeDesc->GetEnumMembers();

    while(begin <= end - 1)
    {
      int mid = (begin + end) >> 1;
      ASSERT(p[mid] < m_nNumOfEnums); // 索引肯定低于总大小
      auto& pair = aEnums[p[mid]];
      auto result = GXSTRCMP(szName, pair.GetName());
      if(result < 0) {
        end = mid;
      }
      else if(result > 0){
        if(begin == mid) {
          break;
        }
        begin = mid;
      }
      else {
        *pOutEnumFlag = pair.Value;
        return TRUE;
      }
    }


    return FALSE;
  }

  template<class _TIter>
  _TIter& DataPool::first_iterator(_TIter& it)
  {
    it.pDataPool = this; // 这个导致结构不能修饰为const
    it.pVarDesc  = m_aVariables;
    it.pBuffer   = &m_VarBuffer;
    it.nOffset   = 0;
    it.index     = (GXUINT)-1;
    return it;
  }

  DataPoolUtility::iterator DataPool::begin()
  {
    DataPoolUtility::iterator it;
    return first_iterator<DataPoolUtility::iterator>(it);
  }

  DataPoolUtility::iterator DataPool::end()
  {
    DataPoolUtility::iterator it;
    first_iterator(it);
    it.pVarDesc += m_nNumOfVar;
    return it;
  }

  DataPoolUtility::named_iterator DataPool::named_begin()
  {
    DataPoolUtility::named_iterator it;
    return first_iterator(it);
  }

  DataPoolUtility::named_iterator DataPool::named_end()
  {
    DataPoolUtility::named_iterator it;
    first_iterator(it);
    it.pVarDesc += m_nNumOfVar;
    return it;
  }

  GXBOOL DataPool::SaveW( GXLPCWSTR szFilename )
  {
    clFile file;
    if(file.CreateAlwaysW(szFilename)) {
      return Save(file);
    }
    static GXWCHAR szCantOpen[] = {'c','a','n',' ','n','o','t',' ','o','p','e','n',' ','f','i','l','e',' ','\"','%','s','\"','.','\0'};
    CLOG_ERRORW(szCantOpen, szFilename);
    return FALSE;
  }

#define SAVE_TRACE TRACE

  GXBOOL DataPool::Save( clFile& file )
  {
    //
    // TODO: 改为SmartRepository储存
    //
#ifdef DEBUG_DECL_NAME
    TRACE("打开名字调试模式,文件结构体中含有指针，要关闭这个宏才能保存");
    CLBREAK;
#else
    // #.[FILE_HEADER]
    // #.Variable space buffer header
    // #.Array buffer header[0]
    // #.Array buffer header[1]
    // ...
    // #.DataPool::m_Buffer - Variable space
    // #.字符串变量，字符串列表
    // #.Variable space 的重定位表 + Variable data
    // #.Array Buffer[0] 的重定位表 + data
    // #.Array Buffer[1] 的重定位表 + data
    // ...
    FILE_HEADER header;
    header.dwVersion         = DATAPOOL_VERSION;
    header.dwFlags           = 0;
    header.nNumOfTypes       = m_nNumOfTypes;
    header.nNumOfVar         = m_nNumOfVar;
    header.nNumOfMember      = m_nNumOfMember;
    header.nNumOfEnums       = m_nNumOfEnums;
    header.cbDescTabNames    = (GXUINT)IntGetRTDescNames();
    header.cbVariableSpace   = (GXUINT)m_VarBuffer.GetSize();
    header.nNumOfStrings     = 0;
    header.cbStringSpace     = 0;
    header.cbAnsiStringSpace = 0;
    header.nNumOfArrayBufs   = 0;
    //header.cbArraySpace     = 0;



    StringSetW sStringVar; // 字符串变量集合
    StringSetA sStringVarA; // 字符串变量集合
    GXUINT nRelOffset = 0;  // 重定位表的开始偏移
    //UIntArray     RelocalizeTab;  
    BufDescArray  BufferTab;
    BUFFER_SAVELOAD_DESC bd;
    BUFFER_SAVELOAD_DESC* pCurrBufDesc;
    bd._pBuffer = &m_VarBuffer;
    //bd.nBeginOfRel = 0;
    bd.pTypeDesc = NULL;
    BufferTab.push_back(bd);
    pCurrBufDesc = &BufferTab.back();

#ifdef _DEBUG
    typedef clset<clBufferBase*>  BufSet;
    BufSet        sDbgBufSet;
#endif // #ifdef _DEBUG

    // 变量预处理：
    // 1.收集字符串变量集合
    // 2.收集重定位表
    auto _itBegin = begin();
    auto _itEnd = end();
    DataPoolUtility::EnumerateVariables2
      <DataPoolUtility::iterator, DataPoolUtility::element_iterator, DataPoolUtility::element_reverse_iterator>
      (_itBegin, _itEnd, 
#ifdef _DEBUG
      [&sStringVar, &sStringVarA, &header, &nRelOffset, &BufferTab, &pCurrBufDesc, &sDbgBufSet, &bd]
#else
      [&sStringVar, &sStringVarA, &header, &nRelOffset, &BufferTab, &pCurrBufDesc, &bd]
#endif // #ifdef _DEBUG
    (int bArray, DataPool::iterator& it, int nDepth) 
    {
      MOVariable var = it.ToVariable();
      const auto pCheckBuffer = it.pBuffer;
      if(pCheckBuffer != pCurrBufDesc->_pBuffer) // 切换了Buffer
      {
        //TRACE("%08x:%08x\n", pCheckBuffer, pCurrBufDesc->pBuffer);

#ifdef _DEBUG
        // sDbgBufSet存了之前的buffer，新的buffer一定不在这个集合里
        ASSERT(sDbgBufSet.find(pCheckBuffer) == sDbgBufSet.end());
        sDbgBufSet.insert(pCheckBuffer);
#endif // #ifdef _DEBUG

        // 这个buffer结束时，累计偏移一定等于buffer大小
        ASSERT_X86(nRelOffset == pCurrBufDesc->_pBuffer->GetSize());

        ++pCurrBufDesc;

        // 一定在下面“if(bArray)”里注册过，并且也是按照顺序出现的
        ASSERT(pCurrBufDesc->_pBuffer == pCheckBuffer);

        //bd.pBuffer = pCheckBuffer;
        //BufferTab.push_back(bd);
        //pCurrBufDesc = &BufferTab.back();
        nRelOffset = 0;
      }

      ASSERT(bArray || it.pVarDesc->GetTypeCategory() != T_STRUCT);



      if(bArray)
      {
        ASSERT(it.pVarDesc->IsDynamicArray() && it.index == (GXUINT)-1);
        auto pChildBuf = it.child_buffer();
        if(pChildBuf)
        {
          if(pChildBuf->GetSize())
          {
            ++header.nNumOfArrayBufs;
            
            bd._pBuffer = pChildBuf;
            bd.pTypeDesc = it.pVarDesc->GetTypeDesc();
            const GXINT_PTR nCurOffset = (GXINT_PTR)pCurrBufDesc - (GXINT_PTR)&BufferTab.front();
            BufferTab.push_back(bd);
            pCurrBufDesc = (BUFFER_SAVELOAD_DESC*)((GXINT_PTR)&BufferTab.front() + nCurOffset); // vector指针改变，这里更新一下指针
          }
          //pCurrBufDesc->pTypeDesc = it.pVarDesc->GetTypeDesc();
          //else {
          //  pCurrBufDesc->ZeroArray.push_back(nRelOffset);
          //}
        }
        pCurrBufDesc->RelTable.push_back(nRelOffset | BUFFER_SAVELOAD_DESC::RelocalizeType_Array);

        //if(var.IsValid())
        //{
        //  SAVE_TRACE("0.Dyn buffer:%08x\n", it.pBuffer);
        //  SAVE_TRACE("  Dyn buffer:%08x x%d o%d %s\n", it.child_buffer(), it.child_buffer()->GetSize(), nRelOffset, it.FullNameA());
        //}
        //TRACE("*%d\n", nRelOffset);
        nRelOffset += SIZEOF_PTR32;
      }
      else if(it.pVarDesc->GetTypeCategory() == T_STRING)
      {
        ASSERT( ! bArray);
        sStringVar.insert(var.ToStringW());
        pCurrBufDesc->RelTable.push_back(nRelOffset | BUFFER_SAVELOAD_DESC::RelocalizeType_String);
        nRelOffset += SIZEOF_PTR32;
        ASSERT_X86(var.GetSize() == 4);
        ++header.nNumOfStrings;
      }
      else if(it.pVarDesc->GetTypeCategory() == T_STRINGA)
      {
        ASSERT( ! bArray);
        sStringVarA.insert(var.ToStringA());
        pCurrBufDesc->RelTable.push_back(nRelOffset | BUFFER_SAVELOAD_DESC::RelocalizeType_StringA);
        nRelOffset += SIZEOF_PTR32;
        ASSERT_X86(var.GetSize() == 4);
        ++header.nNumOfStrings;
      }
      else
      {
        ASSERT(var.IsValid());
        nRelOffset += var.GetSize();
      }

      // 累计偏移验证
      ASSERT(nRelOffset <= it.pBuffer->GetSize());
    });


    if(SIZEOF_PTR > SIZEOF_PTR32) // 运行时64位平台指针到磁盘文件32位无符号整数
    {      
      ASSERT( ! BufferTab.empty()) // 至少有m_VarBuffer
      header.cbVariableSpace = (GXUINT)BufferTab.front().GetDiskBufferSize();
    }

    //header.nRelocalizeOffset  = sizeof(FILE_HEADER);
    //header.nRelocalizeCount   = RelocalizeTab.size();
    header.nBufHeaderOffset   = (GXUINT)(sizeof(FILE_HEADER));
    header.nDescOffset        = (GXUINT)(sizeof(FILE_HEADER) + sizeof(FILE_BUFFERHEADER) * (header.nNumOfArrayBufs + 1));
    header.nStringVarOffset   = (GXUINT)(header.nDescOffset + (m_Buffer.GetSize() - m_VarBuffer.GetSize()));
    header.nAnsiStringOffset  = (GXUINT)header.nStringVarOffset + sStringVar.buffer_size();
    header.nBuffersOffset     = (GXUINT)header.nAnsiStringOffset + sStringVarA.buffer_size();

    header.nNumOfPtrVars      = (GXUINT)BufferTab.front().RelTable.size();
    header.cbStringSpace      = (GXUINT)sStringVar.buffer_size();
    header.cbAnsiStringSpace  = (GXUINT)sStringVarA.buffer_size();


    clBuffer BufferToWrite; // 临时使用的缓冲区

    // 文件头
    V_WRITE(file.Write(&header, sizeof(FILE_HEADER)), "Failed to write file header.");


    // 数据缓冲信息头
    ASSERT(file.GetPointer() == header.nBufHeaderOffset); // 当前指针与buffer描述表开始偏移一致
    FILE_BUFFERHEADER fbh;
    for(auto it = BufferTab.begin(); it != BufferTab.end(); ++it)
    {
      fbh.nBufferSize = (GXUINT)it->GetDiskBufferSize();
      fbh.nNumOfRel   = (GXUINT)it->RelTable.size();
      fbh.nType       = it->pTypeDesc == NULL ? 0
        : header.nDescOffset + (GXUINT)((GXUINT_PTR)it->pTypeDesc - (GXUINT_PTR)m_aTypes);

      SAVE_TRACE("save buffer type:%s\n", it->pTypeDesc ? it->pTypeDesc->GetName() : "<global>");

      //SAVE_TRACE("1.Buffer Ptr:%08x\n", it->pBuffer);
      ASSERT(fbh.nBufferSize != 0);

      V_WRITE(file.Write(&fbh, sizeof(fbh)), "Failed to write fbh.");
    }



    // 去掉变量空间的 DataPool::m_Buffer
    //DbgIntDump();
    ASSERT(file.GetPointer() == header.nDescOffset);
    if(SIZEOF_PTR > SIZEOF_PTR32)
    {
      BufferToWrite.Resize((GXUINT)m_Buffer.GetSize() - m_VarBuffer.GetSize(), FALSE);
      memcpy(BufferToWrite.GetPtr(), m_Buffer.GetPtr(), BufferToWrite.GetSize());

      // 这段儿地址计算参考[MAIN BUFFER 结构表]
      const GXUINT_PTR nDeltaVarToType = (GXUINT_PTR)m_aVariables - (GXUINT_PTR)m_aTypes;
      const GXUINT_PTR nDeltaMemberToType = (GXUINT_PTR)m_aMembers - (GXUINT_PTR)m_aTypes;
      IntChangePtrSize(4, (VARIABLE_DESC*)((GXUINT_PTR)BufferToWrite.GetPtr() + nDeltaVarToType), m_nNumOfVar);
      IntClearChangePtrFlag((TYPE_DESC*)BufferToWrite.GetPtr(), m_nNumOfTypes);

      V_WRITE(file.Write(BufferToWrite.GetPtr(), (GXUINT)BufferToWrite.GetSize()), "Failed to write global buffer.");
    }
    else {
      V_WRITE(file.Write(m_Buffer.GetPtr(), (GXUINT)m_Buffer.GetSize() - header.cbVariableSpace), "Failed to write global buffer.");
    }


    
    // 字符串变量的字符串列表
    clFixedBuffer StringVarBuf;
    ASSERT(file.GetPointer() == header.nStringVarOffset); // 当前指针与字符串变量表开始偏移一致
    StringVarBuf.Resize(sStringVar.buffer_size(), TRUE);
    sStringVar.GatherToBuffer(&StringVarBuf, 0);
    V_WRITE(file.Write(StringVarBuf.GetPtr(), (GXUINT)StringVarBuf.GetSize()), "Failed to write variable string buffer.");

    // ANSI 字符串保存
    ASSERT(file.GetPointer() == header.nAnsiStringOffset);
    StringVarBuf.Resize(sStringVarA.buffer_size(), TRUE);
    sStringVarA.GatherToBuffer(&StringVarBuf, 0);
    V_WRITE(file.Write(StringVarBuf.GetPtr(), (GXUINT)StringVarBuf.GetSize()), "Failed to write variable ansi string buffer.");    


    // 数据缓冲的数据
    GXUINT nBufferIndex = 1;
    for(auto it = BufferTab.begin(); it != BufferTab.end(); ++it)
    {
      SAVE_TRACE("2.Buffer Ptr:%08x %d\n", it->_pBuffer, it->_pBuffer->GetSize());

      BufferToWrite.Resize(it->GetDiskBufferSize(), FALSE);

      const auto nCheck = it->RelocalizePtr(&BufferToWrite, it->_pBuffer, [this, &sStringVar, &sStringVarA, header, &BufferTab, &nBufferIndex]
      (BUFFER_SAVELOAD_DESC::RelocalizeType type, GXUINT nOffset, GXLPBYTE& pDest, GXLPCBYTE& pSrc)
      {
        //SAVE_TRACE("rel offset:%d\n", (GXINT_PTR)pSrc - (GXINT_PTR)it->pBuffer->GetPtr());
        switch(type)
        {
        case BUFFER_SAVELOAD_DESC::RelocalizeType_String:
          {
            clStringW* pStr = (clStringW*)pSrc;
            //SAVE_TRACE("str:%s\n", *pStr);
            if(pStr)
            {
              auto itSetSet = sStringVar.find(*pStr);
              ASSERT(itSetSet != sStringVar.end());
              *(GXUINT*)pDest = (GXUINT)(itSetSet->second.offset + header.nStringVarOffset);
            }
          }
          break;
        case BUFFER_SAVELOAD_DESC::RelocalizeType_StringA:
          {
            clStringA* pStr = (clStringA*)pSrc;
            if(pStr)
            {
              auto itSetSet = sStringVarA.find(*pStr);
              ASSERT(itSetSet != sStringVarA.end());
              *(GXUINT*)pDest = (GXUINT)(itSetSet->second.offset + header.nAnsiStringOffset);
            }
          }
          break;
        case BUFFER_SAVELOAD_DESC::RelocalizeType_Array:
          {
            clBufferBase** ppBuf = (clBufferBase**)pSrc;
            if((*ppBuf) && (*ppBuf)->GetSize())
            {
              ASSERT(*ppBuf == BufferTab[nBufferIndex]._pBuffer);
              *(GXUINT*)pDest = nBufferIndex;
              ++nBufferIndex;
            }
            else {
              *(GXUINT*)pDest = 0; // 长度为0的buffer处理为空
            }
          }
          break;
        default:
          CLBREAK;
          break;
        }

        pDest += sizeof(GXUINT);
        pSrc += SIZEOF_PTR;
      });

      ASSERT(nCheck == BufferToWrite.GetSize());

      //TRACE("file ptr:%d\n", file.GetPointer());
      // 重定位表
      //if( ! it->RelTable.empty())
      //{
      //  V_WRITE(file.Write(&it->RelTable.front(), (GXUINT)it->RelTable.size() * sizeof(GXUINT)), "Failed to write relocalize table.");
      //}
      // buffer data
      V_WRITE(file.Write(BufferToWrite.GetPtr(), (GXUINT)BufferToWrite.GetSize()), "Failed to write data buffer.");
    }

    SAVE_TRACE("Arrays:%d Strings:%d\n", header.nNumOfArrayBufs, header.nNumOfStrings);
    SAVE_TRACE("=======================================================\n");
#endif // #ifdef DEBUG_DECL_NAME
    return TRUE;
  }

  //////////////////////////////////////////////////////////////////////////

  GXBOOL DataPool::Load( AFile& file, GXDWORD dwFlag )
  {
    //
    // TODO: 改为SmartRepository加载
    //
    ASSERT(m_Buffer.GetSize() == 0); // 有效的DataPool对象不能执行Load方法

#ifdef DEBUG_DECL_NAME
    TRACE("打开名字调试模式,文件结构体中含有指针，要关闭这个宏才能加载");
    CLBREAK;
#else

    FILE_HEADER header;
    GXDWORD dwRead;
    V_READ(file.Read(&header, sizeof(FILE_HEADER), &dwRead), "Can not load file header.");

    m_nNumOfTypes  = header.nNumOfTypes;
    m_nNumOfVar    = header.nNumOfVar;
    m_nNumOfMember = header.nNumOfMember;
    m_nNumOfEnums  = header.nNumOfEnums;



    //
    // Buffer header
    //
    typedef clvector<FILE_BUFFERHEADER> FileBufArray;
    FileBufArray BufHeaders;  // 文件记录
    BufDescArray BufferTab;   // 运行时记录
    BUFFER_SAVELOAD_DESC bd = {0};
    FILE_BUFFERHEADER BufHeader = {0};

    if(file.GetPos() != header.nBufHeaderOffset) {
      file.Seek(header.nBufHeaderOffset, AFILE_SEEK_SET);
    }
    const int nNumOfBuffers = header.nNumOfArrayBufs + 1;
    BufferTab.insert(BufferTab.begin(), nNumOfBuffers, bd);
    BufferTab.front()._pBuffer = &m_VarBuffer;

    // 读入文件记录的所有BufferHeader数据
    BufHeaders.insert(BufHeaders.begin(), nNumOfBuffers, BufHeader);
    V_READ(file.Read(&BufHeaders.front(), sizeof(FILE_BUFFERHEADER) * nNumOfBuffers, &dwRead), "Can not load buffer header.");





    // 这个计算参考[MAIN BUFFER 结构表]
    const GXSIZE_T nDescHeaderSize = IntGetRTDescHeader() + header.cbDescTabNames;
    const GXSIZE_T cbGlobalVariable = header.cbVariableSpace + BUFFER_SAVELOAD_DESC::GetPtrAdjustSize(header.nNumOfPtrVars);
    const GXSIZE_T nMainBufferSize_0 = nDescHeaderSize + cbGlobalVariable;
    GXSIZE_T nMainBufferSize = nMainBufferSize_0;




    //dwFlag = 0; // 强力调试屏蔽！！！




    //*
    if(TEST_FLAG(dwFlag, DataPoolLoad_ReadOnly))
    {
      m_bReadOnly = 1;
      nMainBufferSize += header.cbStringSpace;
      nMainBufferSize += header.cbAnsiStringSpace;
      nMainBufferSize += sizeof(DataPoolArray) * header.nNumOfArrayBufs;

      // 索引从1开始，[0]是全局变量空间，已经计算了
      for(int i = 1; i < nNumOfBuffers; ++i)
      {
        const FILE_BUFFERHEADER& fbh = BufHeaders[i];
        nMainBufferSize += (fbh.nBufferSize + BUFFER_SAVELOAD_DESC::GetPtrAdjustSize(fbh.nNumOfRel));
      }
    }//*/

    m_Buffer.Resize(nMainBufferSize, FALSE);

    if(file.GetPos() != header.nDescOffset) {
      file.Seek(header.nDescOffset, AFILE_SEEK_SET);
    }

    // 一次读入除了全局变量以外的数据，包括各种描述表，名字字符串列表等
    V_READ(file.Read(m_Buffer.GetPtr(), (GXUINT)nDescHeaderSize, &dwRead), "Can not load desc header.");

    const clsize cbDesc = LocalizePtr();
    new(&m_VarBuffer) clstd::RefBuffer((GXLPBYTE)m_Buffer.GetPtr() + cbDesc + header.cbDescTabNames, cbGlobalVariable);


    // 64位下扩展描述表中的指针
    if(SIZEOF_PTR > SIZEOF_PTR32)
    {
      IntChangePtrSize(8, m_aVariables, m_nNumOfVar);
      IntClearChangePtrFlag(m_aTypes, m_nNumOfTypes);
    }




    // 字符串变量的字符串列表
    clFixedBuffer StringVarBuf;
    clFixedBuffer StringVarBufA;
    GXLPBYTE pStringBegin;
    GXLPBYTE pStringBeginA;
    if(header.cbStringSpace)
    {
      if(file.GetPos() != header.nStringVarOffset) {
        file.Seek(header.nStringVarOffset, AFILE_SEEK_SET);
      }
      if(TEST_FLAG(dwFlag, DataPoolLoad_ReadOnly))
      {
        pStringBegin = (GXLPBYTE)m_Buffer.GetPtr() + nMainBufferSize_0;
      }
      else
      {
        StringVarBuf.Resize(header.cbStringSpace, FALSE);
        pStringBegin = (GXLPBYTE)StringVarBuf.GetPtr();
      }
      V_READ(file.Read(pStringBegin, header.cbStringSpace, &dwRead), "Can not load variable strings.");
    }
    
    // ANSI 字符串空间
    if(header.cbAnsiStringSpace)
    {
      if(file.GetPos() != header.nAnsiStringOffset) {
        file.Seek(header.nAnsiStringOffset, AFILE_SEEK_SET);
      }
      if(TEST_FLAG(dwFlag, DataPoolLoad_ReadOnly))
      {
        pStringBeginA = (GXLPBYTE)m_Buffer.GetPtr() + nMainBufferSize_0 + header.cbStringSpace;
      }
      else
      {
        StringVarBufA.Resize(header.cbAnsiStringSpace, FALSE);
        pStringBeginA = (GXLPBYTE)StringVarBufA.GetPtr();
      }
      V_READ(file.Read(pStringBeginA, header.cbAnsiStringSpace, &dwRead), "Can not load variable ansi strings.");
    }

    // 非只读模式下，在这里初始化缓冲区
    ASSERT(m_aTypes != NULL);
    if(TEST_FLAG(dwFlag, DataPoolLoad_ReadOnly))
    {
      GXLPBYTE lpBufferPtr = (GXLPBYTE)m_Buffer.GetPtr() + nMainBufferSize_0 + header.cbStringSpace + header.cbAnsiStringSpace;

      for(int i = 1; i < nNumOfBuffers; ++i)
      {
        const FILE_BUFFERHEADER& fbh = BufHeaders[i];
        BUFFER_SAVELOAD_DESC& bd = BufferTab[i];

        // 定位动态数组类型
        bd.pTypeDesc = (TYPE_DESC*)((GXINT_PTR)m_aTypes + (fbh.nType - header.nDescOffset));

        const clsize nBufferSize = fbh.nBufferSize + BUFFER_SAVELOAD_DESC::GetPtrAdjustSize(fbh.nNumOfRel);
        bd._pBuffer = new(lpBufferPtr) DataPoolArray(lpBufferPtr, nBufferSize);
        //((DataPoolArray*)bd.pBuffer)->Resize(, FALSE);

        lpBufferPtr += (nBufferSize + sizeof(DataPoolArray));
      }
      ASSERT((GXSIZE_T)lpBufferPtr - (GXSIZE_T)m_Buffer.GetPtr() == nMainBufferSize);
    }
    else
    {
      for(int i = 1; i < nNumOfBuffers; ++i)
      {
        const FILE_BUFFERHEADER& fbh = BufHeaders[i];
        BUFFER_SAVELOAD_DESC& bd = BufferTab[i];

        // 定位动态数组类型
        bd.pTypeDesc = (TYPE_DESC*)((GXINT_PTR)m_aTypes + (fbh.nType - header.nDescOffset));

        // 分配动态数组空间，增量是8倍类型大小
        bd._pBuffer = new DataPoolArray(bd.pTypeDesc->_cbSize * 8);
        ((DataPoolArray*)bd._pBuffer)->Resize(fbh.nBufferSize + BUFFER_SAVELOAD_DESC::GetPtrAdjustSize(fbh.nNumOfRel), FALSE);
      }
    }


    // 开始读取全局变量和动态数组数据
    if(file.GetPos() != header.nBuffersOffset) {
      file.Seek(header.nBuffersOffset, AFILE_SEEK_SET);
    }

    // buffer 表中第一个就是全局变量的尺寸，肯定是相等的
    ASSERT(BufferTab.front()._pBuffer->GetSize() == cbGlobalVariable);

    clBuffer BufferForRead;
    for(int i = 0; i < nNumOfBuffers; ++i)
    {
      const FILE_BUFFERHEADER& fbh = BufHeaders[i];
      BUFFER_SAVELOAD_DESC& bd = BufferTab[i];

      // 为重定位表预留空间
      if(fbh.nNumOfRel) {
        //BufferTab[i].RelTable.insert(BufferTab[i].RelTable.begin(), fbh.nNumOfRel, 0);
        bd.RelTable.reserve(fbh.nNumOfRel);
      }


      //
      // PS：重定位表既然能收集出来，为什么毛还要递归先收集，另一个循环定位？这个可以一次搞定！
      //


      // 计算buffer的类型说明,收集重定位表
      if(fbh.nType) {
        ASSERT(bd._pBuffer != NULL);
        bd.GenerateRelocalizeTable(bd.pTypeDesc);
      }
      else {
        // 全局变量
        bd.GenerateRelocalizeTable(0, m_aVariables, m_nNumOfVar);
      }

      BufferForRead.Resize(bd._pBuffer->GetSize() - bd.GetPtrAdjustSize(), FALSE);


      //TRACE("load buffer type:%s\n", bd.pTypeDesc ? bd.pTypeDesc->GetName() : "<global>");


      // 读取重定位表
      //if( ! rbd.RelTable.empty()) {
      //  file.Read(&rbd.RelTable.front(), (GXUINT)rbd.RelTable.size() * sizeof(GXUINT));
      //  //rbd.DbgCheck();
      //  // 重定位表偏移肯定都小于缓冲区
      //  ASSERT(rbd.pBuffer->GetSize() >= (rbd.RelTable.front() & BUFFER_SAVELOAD_DESC::RelocalizeOffsetMask));
      //  ASSERT(rbd.pBuffer->GetSize() >= (rbd.RelTable.back() & BUFFER_SAVELOAD_DESC::RelocalizeOffsetMask))
      //}

      V_READ(file.Read(BufferForRead.GetPtr(), (GXUINT)BufferForRead.GetSize(), &dwRead), "Can not load buffer data.");

      const auto nCheck = bd.RelocalizePtr(bd._pBuffer, &BufferForRead, [&pStringBegin, &pStringBeginA, &BufferTab, &header, &dwFlag, this]
      (BUFFER_SAVELOAD_DESC::RelocalizeType type, GXUINT nOffset, GXLPBYTE& pDest, GXLPCBYTE& pSrc)
      {
        switch(type)
        {
        case BUFFER_SAVELOAD_DESC::RelocalizeType_String:
          {
            GXLPCWSTR str = (GXLPCWSTR)((GXINT_PTR)pStringBegin + *(GXUINT*)pSrc - header.nStringVarOffset);
            if(TEST_FLAG(dwFlag, DataPoolLoad_ReadOnly))
            {
              *(GXLPCWSTR*)pDest = str;
              INC_DBGNUMOFSTRING;
            }
            else if(str[0]) {
              new(pDest) clStringW(str);
              INC_DBGNUMOFSTRING;
              //TRACEW(L"str:%s %s\n", str, *(clStringW*)pDest);
            }
            else {
              *(GXLPCWSTR*)pDest = NULL;
            }
          }
          break;

        case BUFFER_SAVELOAD_DESC::RelocalizeType_StringA:
          {
            GXLPCSTR str = (GXLPCSTR)((GXINT_PTR)pStringBeginA + *(GXUINT*)pSrc - header.nAnsiStringOffset);
            if(TEST_FLAG(dwFlag, DataPoolLoad_ReadOnly))
            {
              *(GXLPCSTR*)pDest = str;
              INC_DBGNUMOFSTRING;
            }
            else if(str[0]) {
              new(pDest) clStringA(str);
              INC_DBGNUMOFSTRING;
              //TRACEW(L"str:%s %s\n", str, *(clStringW*)pDest);
            }
            else {
              *(GXLPCSTR*)pDest = NULL;
            }
          }
          break;

        case BUFFER_SAVELOAD_DESC::RelocalizeType_Array:
          {
            GXUINT index = *(GXUINT*)pSrc;
            ASSERT(index < BufferTab.size());
            if(index)
            {
              // 缓冲区肯定已经创建过了
              ASSERT(BufferTab[index]._pBuffer != NULL);
              *(clBufferBase**)pDest = BufferTab[index]._pBuffer;
              INC_DBGNUMOFARRAY;
            }
            else {
              *(clBufferBase**)pDest = NULL;
            }
          }
          break;

        default:
          CLBREAK;
          break;
        }
        pDest += SIZEOF_PTR;
        pSrc += sizeof(GXUINT);
      });
      ASSERT(nCheck == bd._pBuffer->GetSize());
    }
#endif // #ifdef DEBUG_DECL_NAME
    return TRUE;
  }

  GXSIZE_T DataPool::IntGetRTDescHeader()
  {
    auto cbTypes     = m_nNumOfTypes * sizeof(TYPE_DESC);
    auto cbGVSIT     = (m_nNumOfVar + m_nNumOfMember + m_nNumOfEnums) * sizeof(SortedIndexType);
    auto cbVariables = m_nNumOfVar * sizeof(VARIABLE_DESC);
    auto cbMembers   = m_nNumOfMember * sizeof(VARIABLE_DESC);
    auto cbEnums     = m_nNumOfEnums * sizeof(ENUM_DESC);
    return (cbTypes + cbGVSIT + cbVariables + cbMembers + cbEnums);
  }

  GXSIZE_T DataPool::IntGetRTDescNames()
  {
    return m_Buffer.GetSize() - IntGetRTDescHeader() - m_VarBuffer.GetSize();
  }

  GXUINT DataPool::IntChangePtrSize(GXUINT nSizeofPtr, VARIABLE_DESC* pVarDesc, GXUINT nCount)
  {
    // 验证是全局变量开始，或者是成员变量开始
    ASSERT(pVarDesc->nOffset == 0);

    // 只用于32位指针到64位指针或者64位指针到32位指针转换
    ASSERT(nSizeofPtr == 4 || nSizeofPtr == 8);
    
    GXUINT nNewOffset = 0;
    for(GXUINT i = 0; i < nCount; ++i)
    {
      VARIABLE_DESC& d = pVarDesc[i];
      const auto eCate = d.GetTypeCategory();
      d.nOffset = nNewOffset;

#if 0
      if(d.IsDynamicArray()) {
        // 动态数组就是一个指针
        nNewOffset += nSizeofPtr; // sizeof(DataPoolArray*)
      }
      else
      {
        // 检查已经调整的标记
        // 如果没有调整过，则重新计算这个类型的大小
        // 否则步进这个类型的大小就可以
        if(TEST_FLAG_NOT(eCate, TYPE_CHANGED_FLAG))
        {
          TYPE_DESC* pTypeDesc = (TYPE_DESC*)d.GetTypeDesc();
          GXUINT& uCate = *(GXUINT*)&pTypeDesc->Cate;
          SET_FLAG(uCate, TYPE_CHANGED_FLAG);
          switch(eCate)
          {
          case T_STRUCT:
            //pTypeDesc->cbSize = IntChangePtrSize(nSizeofPtr, pMembers, &pMembers[d.MemberBegin()], d.MemberCount());
            pTypeDesc->_cbSize = IntChangePtrSize(nSizeofPtr, (VARIABLE_DESC*)d.MemberBeginPtr(), d.MemberCount());
            break;

          case T_STRING:
          case T_STRINGA:
            ASSERT((pTypeDesc->_cbSize == 4 && nSizeofPtr == 8) ||
              (pTypeDesc->_cbSize == 8 && nSizeofPtr == 4));

            pTypeDesc->_cbSize = nSizeofPtr;
            break;
          }
        }
        nNewOffset += d.GetSize();
      } // if(d.IsDynamicArray())
#endif
      if(TEST_FLAG_NOT(eCate, TYPE_CHANGED_FLAG))
      {
        TYPE_DESC* pTypeDesc = (TYPE_DESC*)d.GetTypeDesc();
        GXUINT& uCate = *(GXUINT*)&pTypeDesc->Cate;
        SET_FLAG(uCate, TYPE_CHANGED_FLAG);
        switch(eCate)
        {
        case T_STRUCT:
          pTypeDesc->_cbSize = IntChangePtrSize(nSizeofPtr, (VARIABLE_DESC*)d.MemberBeginPtr(), d.MemberCount());
          break;

        case T_STRING:
        case T_STRINGA:
        //case T_OBJECT:
          ASSERT((pTypeDesc->_cbSize == 4 && nSizeofPtr == 8) ||
            (pTypeDesc->_cbSize == 8 && nSizeofPtr == 4));

          pTypeDesc->_cbSize = nSizeofPtr;
          break;
        }
      }

      if(d.IsDynamicArray()) {
        nNewOffset += nSizeofPtr; // sizeof(DataPoolArray*)
      }
      else {
        nNewOffset += d.GetSize();
      }
    }
    return nNewOffset;
  }

  void DataPool::IntClearChangePtrFlag( TYPE_DESC* pTypeDesc, GXUINT nCount )
  {
    // 如果变量没有设置修改标志，表示这个函数之前的调用有误
    //ASSERT(TEST_FLAG(pTypeDesc[i].Cate, TYPE_CHANGED_FLAG));
    for(GXUINT i = 0; i < nCount; ++i)
    {
      RESET_FLAG(*(GXUINT*)&pTypeDesc[i].Cate, TYPE_CHANGED_FLAG);
    }
  }


  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////


  DataPool::VARIABLE_DESC::VTBL* DataPool::VARIABLE_DESC::GetUnaryMethod() const
  {
    switch(GetTypeCategory())
    {
    case T_STRING:  return (VTBL*)Implement::s_pStringVtbl;
    case T_STRINGA: return (VTBL*)Implement::s_pStringAVtbl;
    case T_STRUCT:  return (VTBL*)Implement::s_pStructVtbl;
    case T_ENUM:    return (VTBL*)Implement::s_pEnumVtbl;
    case T_FLAG:    return (VTBL*)Implement::s_pFlagVtbl;
    default:        return (VTBL*)Implement::s_pPrimaryVtbl;
    }
  }

  DataPool::VARIABLE_DESC::VTBL* DataPool::VARIABLE_DESC::GetMethod() const
  {
    if(IsDynamicArray()) {
      return (VTBL*)Implement::s_pDynamicArrayVtbl;
    }
    else if(nCount > 1) {
      return (VTBL*)Implement::s_pStaticArrayVtbl;
    }
    return GetUnaryMethod();
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
