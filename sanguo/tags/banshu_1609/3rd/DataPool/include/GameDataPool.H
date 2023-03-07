#ifndef _MARIMO_GAME_DATA_POOL_H_
#define _MARIMO_GAME_DATA_POOL_H_

  // 这个让下面的参数用法更清晰
  typedef GXINT_PTR DataPoolPtr;
  typedef GXINT_PTR VariablePtr;
  typedef GXINT_PTR IteratorPtr; // iterator/named iterator/array iterator
  typedef GXINT_PTR StringHandle;
  typedef GXINT_PTR StringPtr;
  typedef GXINT_PTR DictPtr;

  using namespace clstd;

  // 对特定类型的建立字典储存
  // TODO: 以后的版本中基础类型支持字典类型，就不用这个类啦。

  class DataPoolDict
  {
  private:
	  struct INDEX
	  {
		  DataPool::LPCSTR  szVarName;
		  int               nIndex;
	  };

	  typedef clhash_map<int, INDEX>      KeyIndexDict;     // 数组某个键值->数组索引

	  // 这里用结构体包一下，便于未来扩展，而且如果定义为：
	  // clhash_map<clStringA, KeyIndexDict> VarArrayDict
	  // vc下会报定义名超长被截断的警告
	  struct KEYINDEX
	  {
		  KeyIndexDict sDict;
	  };
	  typedef clhash_map<clStringA, KEYINDEX> VarArrayDict;     // 变量名->数组字典

	  DataPool*         m_pDataPool;
	  //clstd::StringSetA m_SpaceSet;
	  VarArrayDict      m_VarArray;
  public:
	  DataPoolDict(DataPool* pDataPool) : m_pDataPool(pDataPool)
	  {
		  pDataPool->AddRef();
	  }

	  virtual ~DataPoolDict()
	  {
		  SAFE_RELEASE(m_pDataPool);
	  }

	  int SetArrayKey(GXLPCSTR szSpace, DataPool::LPCSTR szVar, DataPool::LPCSTR szKeyName)
	  {
		  MOVariable varArray;
		  MOVariable varElement;
		  if(m_pDataPool->QueryByExpression(szVar, &varArray))
		  {
			  // 长度是0或者元素中（测试的是第一个）不含这个key，则返回
			  if(varArray.GetLength() == 0 || ! varArray[0][szKeyName].IsValid()) {
				  return 0;
			  }

			  KEYINDEX sKeyIndexDict;
			  KEYINDEX& rKeyIndex = m_VarArray.insert(std::make_pair(szSpace, sKeyIndexDict)).first->second;

			  auto it_first = varArray.array_begin();
			  auto it_last = varArray.array_end();
			  INDEX sIdx;
			  for(auto it = it_first; it != it_last; ++it)
			  {
				  it.ToVariable(varElement);
				  sIdx.szVarName = varElement.GetName();  // 这个返回必须是GXLPCSTR才能这样储存
				  sIdx.nIndex = it - it_first;
				  auto result = rKeyIndex.sDict.insert(std::make_pair(varElement[szKeyName].ToInteger(), sIdx));
				  ASSERT(result.second); // 保证添加不会重复添加id
			  }
			  return (int)rKeyIndex.sDict.size();
		  }
		  return 0;
	  }

	  int FindByKey(GXLPCSTR szSpace, int szKeyValue, DataPool::LPCSTR* pArrayName, int* length)
	  {
		  auto itArray = m_VarArray.find(szSpace);
		  if(itArray == m_VarArray.end()) {
			  return -1;
		  }
		  auto itIndex = itArray->second.sDict.find(szKeyValue);
		  if(itIndex == itArray->second.sDict.end()) {
			  return -1;
		  }
		  *pArrayName = itIndex->second.szVarName;
		  *length = GXSTRLEN(*pArrayName);
		  return itIndex->second.nIndex;
	  }
  };

  extern "C"
  {
    DataPoolPtr   GXDLLAPI DataPool_CreateFromFileW         (GXLPCWSTR szFilename, GXDWORD dwFlag);
    DataPoolPtr   GXDLLAPI DataPool_CreateFromFileA         (GXLPCSTR szFilename, GXDWORD dwFlag);

	DataPoolPtr   GXDLLAPI DataPool_CreateFromFileW_PCK       (GXLPCWSTR szFilename, GXDWORD dwFlag);
	DataPoolPtr   GXDLLAPI DataPool_CreateFromFileA_PCK         (GXLPCSTR szFilename, GXDWORD dwFlag);

    void          GXDLLAPI DataPool_Release                 (DataPoolPtr nDataPool);

    VariablePtr   GXDLLAPI DataPool_QueryByExpression       (DataPoolPtr nDataPool, GXLPCSTR szExpression);
    IteratorPtr   GXDLLAPI DataPool_Begin                   (DataPoolPtr nDataPool);
    IteratorPtr   GXDLLAPI DataPool_End                     (DataPoolPtr nDataPool);
    DictPtr       GXDLLAPI DataPool_BuildDict               (DataPoolPtr nDataPool);

    int           GXDLLAPI DataPoolDict_SetKeyOfArray       (DictPtr nDict, GXLPCSTR szSpace, GXLPCSTR szVariable, GXLPCSTR szKeyName); // 返回值是表中的项目个数
    int           GXDLLAPI DataPoolDict_FindByKey           (DictPtr nDict, GXLPCSTR szSpace, int szKeyValue, GXLPCSTR* szArrayName, int* length); // 返回索引
    void          GXDLLAPI DataPoolDict_Release             (DictPtr nDict);

    IteratorPtr   GXDLLAPI DataPoolIterator_Begin           (IteratorPtr nIterator);
    IteratorPtr   GXDLLAPI DataPoolIterator_End             (IteratorPtr nIterator);
    IteratorPtr   GXDLLAPI DataPoolIterator_ArrayBegin      (IteratorPtr nIterator);
    IteratorPtr   GXDLLAPI DataPoolIterator_ArrayEnd        (IteratorPtr nIterator);
    VariablePtr   GXDLLAPI DataPoolIterator_ToVariable      (IteratorPtr nIterator);
    StringPtr     GXDLLAPI DataPoolIterator_Name            (IteratorPtr nIterator, int* nLength);
    int           GXDLLAPI DataPoolIterator_Compare         (IteratorPtr nIterator1, IteratorPtr nIterator2); // 0 表示不相等，非零表示相等
    IteratorPtr   GXDLLAPI DataPoolIterator_inc             (IteratorPtr nIterator);  // 返回值就是它自己
    void          GXDLLAPI DataPoolIterator_Release         (IteratorPtr nIterator);

    IteratorPtr   GXDLLAPI DataPoolElementIterator_Clone    (IteratorPtr nIterator);
    int           GXDLLAPI DataPoolElementIterator_sub      (IteratorPtr nIterator1, IteratorPtr nIterator2);
    int           GXDLLAPI DataPoolElementIterator_Compare  (IteratorPtr nIterator1, IteratorPtr nIterator2); // 0 表示不相等，非零表示相等
    IteratorPtr   GXDLLAPI DataPoolElementIterator_inc      (IteratorPtr nIterator);  // 返回值就是它自己


    void          GXDLLAPI DataPoolVariable_Release         (VariablePtr nVariable);
    VariablePtr   GXDLLAPI DataPoolVariable_MemberOf        (VariablePtr nVariable, GXLPCSTR szMember);
    VariablePtr   GXDLLAPI DataPoolVariable_IndexOf         (VariablePtr nVariable, int nIndex);
    int           GXDLLAPI DataPoolVariable_ToInteger       (VariablePtr nVariable);
    float         GXDLLAPI DataPoolVariable_ToFloat         (VariablePtr nVariable);
    StringHandle  GXDLLAPI DataPoolVariable_ToStringA       (VariablePtr nVariable, StringPtr* nString, int* length);
    StringHandle  GXDLLAPI DataPoolVariable_ToStringW       (VariablePtr nVariable, StringPtr* nString, int* length);
    StringPtr     GXDLLAPI DataPoolVariable_Name            (VariablePtr nVariable, int* nLength);
    int           GXDLLAPI DataPoolVariable_Length          (VariablePtr nVariable);
    IteratorPtr   GXDLLAPI DataPoolVariable_Begin           (VariablePtr nVariable);
    IteratorPtr   GXDLLAPI DataPoolVariable_End             (VariablePtr nVariable);
    IteratorPtr   GXDLLAPI DataPoolVariable_ArrayBegin      (VariablePtr nVariable);
    IteratorPtr   GXDLLAPI DataPoolVariable_ArrayEnd        (VariablePtr nVariable);
    TypeCategory  GXDLLAPI DataPoolVariable_Category        (VariablePtr nVariable);

    void          GXDLLAPI clstd_String_Free                (StringHandle nHandle);
  };

#endif // #ifndef _MARIMO_GAME_DATA_POOL_H_
