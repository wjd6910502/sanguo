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
#include "include/GUnknown.H"
#include "include/DataPool.H"
#include "include/DataPoolIterator.h"
#include "include/DataPoolVariable.H"
//#include "AFile.h"
#include "DataPoolVariableVtbl.h"

#include "GameDataPool.H"

using namespace clstd;

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

extern "C"
{
  GXINT_PTR GXDLLAPI DataPool_CreateFromFileW( GXLPCWSTR szFilename, GXDWORD dwFlag )
  {
    DataPool* pDataPool = NULL;
    if(GXSUCCEEDED(DataPool::CreateFromFileW(&pDataPool, szFilename, dwFlag))) {
      return (GXINT_PTR)pDataPool;
    }
    return 0;
  }

  GXINT_PTR GXDLLAPI DataPool_CreateFromFileA( GXLPCSTR szFilename, GXDWORD dwFlag )
  {
    DataPool* pDataPool = NULL;
    if(GXSUCCEEDED(DataPool::CreateFromFileA(&pDataPool, szFilename, dwFlag))) {
      return (GXINT_PTR)pDataPool;
    }
    return 0;
  }

  GXINT_PTR GXDLLAPI DataPool_CreateFromFileW_PCK( GXLPCWSTR szFilename, GXDWORD dwFlag )
  {
	  DataPool* pDataPool = NULL;
	  if(GXSUCCEEDED(DataPool::CreateFromFileImageW(&pDataPool, szFilename, dwFlag))) {
		  return (GXINT_PTR)pDataPool;
	  }
	  return 0;
  }

  GXINT_PTR GXDLLAPI DataPool_CreateFromFileA_PCK( GXLPCSTR szFilename, GXDWORD dwFlag )
  {
	  DataPool* pDataPool = NULL;
	  if(GXSUCCEEDED(DataPool::CreateFromFileImageA(&pDataPool, szFilename, dwFlag))) {
		  return (GXINT_PTR)pDataPool;
	  }
	  return 0;
  }

  void GXDLLAPI DataPool_Release( GXINT_PTR nDataPool )
  {
    DataPool* pDataPool = (DataPool*)nDataPool;
    SAFE_RELEASE(pDataPool);
  }

  GXINT_PTR GXDLLAPI DataPool_QueryByExpression( GXINT_PTR nDataPool, GXLPCSTR szExpression )
  {
    DataPool* pDataPool = (DataPool*)nDataPool;
    if(pDataPool) {
      MOVariable* pVar = new MOVariable;
      if( ! pDataPool->QueryByExpression(szExpression, pVar)) {
        SAFE_DELETE(pVar);
      }
      return (GXINT_PTR)pVar;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPool_Begin( DataPoolPtr nDataPool )
  {
    DataPool* pDataPool = (DataPool*)nDataPool;
    if(pDataPool) {
      DataPool::iterator* pIterator = new DataPool::iterator;
      *pIterator = pDataPool->begin();
      return (IteratorPtr)pIterator;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPool_End( DataPoolPtr nDataPool )
  {
    DataPool* pDataPool = (DataPool*)nDataPool;
    if(pDataPool) {
      DataPool::iterator* pIterator = new DataPool::iterator;
      *pIterator = pDataPool->end();
      return (IteratorPtr)pIterator;
    }
    return 0;
  }

  DictPtr GXDLLAPI DataPool_BuildDict(DataPoolPtr nDataPool)
  {
    if(nDataPool == 0) {
      return 0;
    }

    DataPoolDict* pDict = new DataPoolDict((DataPool*)nDataPool);
    return (DictPtr)pDict;
  }

  void  GXDLLAPI DataPoolVariable_Release( GXINT_PTR nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    SAFE_DELETE(pVariable);
  }
  //////////////////////////////////////////////////////////////////////////
  int GXDLLAPI DataPoolDict_SetKeyOfArray(DictPtr nDict, GXLPCSTR szSpace, GXLPCSTR szVariable, GXLPCSTR szKeyName)
  {
    DataPoolDict* pDict = (DataPoolDict*)nDict;
    if(pDict) {
      return pDict->SetArrayKey(szSpace, szVariable, szKeyName);
    }
    return 0;
  }

  int GXDLLAPI DataPoolDict_FindByKey(DictPtr nDict, GXLPCSTR szSpace, int szKeyValue, GXLPCSTR* szArrayName, int* length)
  {
    DataPoolDict* pDict = (DataPoolDict*)nDict;
    if(pDict) {
      return pDict->FindByKey(szSpace, szKeyValue, szArrayName, length);
    }
    return -1;
  }

  void GXDLLAPI DataPoolDict_Release(DictPtr nDict)
  {
    DataPoolDict* pDict = (DataPoolDict*)nDict;
    SAFE_DELETE(pDict);
  }
  //////////////////////////////////////////////////////////////////////////

  GXINT_PTR GXDLLAPI DataPoolVariable_MemberOf( GXINT_PTR nVariable, GXLPCSTR szMember )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      DataPoolVariable varMember = pVariable->MemberOf(szMember);
      if(varMember.IsValid()) {
        return (GXINT_PTR)(new DataPoolVariable(varMember));
      }
    }
    return (GXINT_PTR)0;
  }

  GXINT_PTR GXDLLAPI DataPoolVariable_IndexOf( GXINT_PTR nVariable, int nIndex )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      DataPoolVariable varMember = pVariable->IndexOf(nIndex);
      if(varMember.IsValid()) {
        return (GXINT_PTR)(new DataPoolVariable(varMember));
      }
    }
    return (GXINT_PTR)0;
  }

  int GXDLLAPI DataPoolVariable_ToInteger( GXINT_PTR nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      return pVariable->ToInteger();
    }
    return 0;
  }

  float GXDLLAPI DataPoolVariable_ToFloat( GXINT_PTR nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      return pVariable->ToFloat();
    }
    return 0.0f;
  }

  GXINT_PTR GXDLLAPI DataPoolVariable_ToStringA( GXINT_PTR nVariable, GXINT_PTR* nString, int* length )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable){
      clStringA* pStr = (clStringA*)malloc(sizeof(clStringA*));
      new (pStr) clStringA;
      *pStr = pVariable->ToStringA();
      *nString = (GXINT_PTR)(clStringA::LPCSTR)(*pStr);
      *length = pStr->GetLength();
      return (GXINT_PTR)pStr;
    }
    return 0;
  }

  GXINT_PTR GXDLLAPI DataPoolVariable_ToStringW( GXINT_PTR nVariable, GXINT_PTR* nString, int* length )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable){
      clStringW* pStr = (clStringW*)malloc(sizeof(clStringW*));
      new (pStr) clStringW;
      *pStr = pVariable->ToStringW();
      *nString = (GXINT_PTR)(clStringW::LPCSTR)(*pStr);
      *length = pStr->GetLength();
      return (GXINT_PTR)pStr;
    }
    return 0;
  }

  StringPtr GXDLLAPI DataPoolVariable_Name(VariablePtr nVariable, int* nLength)
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable){
      DataPool::LPCSTR szName = pVariable->GetName();
      *nLength = GXSTRLEN(szName);
      return (StringPtr)szName;
    }
    return 0;
  }

  int GXDLLAPI DataPoolVariable_Length(VariablePtr nVariable)
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable){
      return pVariable->GetLength();
    }
    return 0;
  }

  void GXDLLAPI clstd_String_Free(GXINT_PTR nHandle)
  {
    if(nHandle) {
      free((void*)nHandle);
    }
  }

  IteratorPtr GXDLLAPI DataPoolIterator_Begin( IteratorPtr nIterator )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pIter->begin();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolIterator_End( IteratorPtr nIterator )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pIter->end();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolIterator_ArrayBegin( IteratorPtr nIterator )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pIter->array_begin();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolIterator_ArrayEnd( IteratorPtr nIterator )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pIter->array_end();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  VariablePtr GXDLLAPI DataPoolIterator_ToVariable(IteratorPtr nIterator)
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      DataPoolVariable* pVar = new DataPoolVariable;
      pIter->ToVariable(*pVar);
      return (VariablePtr)pVar;
    }
    return 0;
  }

  int GXDLLAPI DataPoolIterator_Compare(IteratorPtr nIterator1, IteratorPtr nIterator2)
  {
    DataPool::iterator* pIter1 = (DataPool::iterator*)nIterator1;
    DataPool::iterator* pIter2 = (DataPool::iterator*)nIterator2;

    if(pIter1 && pIter2)
    {
      return (int)(*pIter1 == *pIter2);
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolIterator_inc( IteratorPtr nIterator )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      ++(*pIter);
    }
    return nIterator;
  }

  StringPtr GXDLLAPI DataPoolIterator_Name( IteratorPtr nIterator, int* nLength )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    if(pIter) {
      DataPool::LPCSTR szName = pIter->VariableName();
      *nLength = GXSTRLEN(szName);
      return (StringPtr)szName;
    }
    return 0;
  }

  void GXDLLAPI DataPoolIterator_Release( IteratorPtr nIterator )
  {
    DataPool::iterator* pIter = (DataPool::iterator*)nIterator;
    SAFE_DELETE(pIter);
  }

  //////////////////////////////////////////////////////////////////////////
  IteratorPtr GXDLLAPI DataPoolElementIterator_Clone(IteratorPtr nIterator)
  {
    typedef DataPoolUtility::element_iterator element_iterator;
    element_iterator* pIter = (element_iterator*)nIterator;
    if(pIter)
    {
      element_iterator* pNewIter = new element_iterator;
      *pNewIter = *pIter;
      return (IteratorPtr)pNewIter;
    }
    return 0;
  }

  int GXDLLAPI DataPoolElementIterator_sub(IteratorPtr nIterator1, IteratorPtr nIterator2)
  {
    typedef DataPoolUtility::element_iterator element_iterator;
    element_iterator* pIter1 = (element_iterator*)nIterator1;
    element_iterator* pIter2 = (element_iterator*)nIterator2;

    if(pIter1 && pIter2)
    {
      return (int)(*pIter1 - *pIter2);
    }
    return 0;
  }

  int GXDLLAPI DataPoolElementIterator_Compare(IteratorPtr nIterator1, IteratorPtr nIterator2)
  {
    typedef DataPoolUtility::element_iterator element_iterator;
    element_iterator* pIter1 = (element_iterator*)nIterator1;
    element_iterator* pIter2 = (element_iterator*)nIterator2;

    if(pIter1 && pIter2)
    {
      return (int)(*pIter1 == *pIter2);
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolElementIterator_inc(IteratorPtr nIterator)
  {
    typedef DataPoolUtility::element_iterator element_iterator;
    element_iterator* pIter = (element_iterator*)nIterator;
    if(pIter) {
      ++(*pIter);
    }
    return nIterator;
  }

  //////////////////////////////////////////////////////////////////////////
  IteratorPtr GXDLLAPI DataPoolVariable_Begin( VariablePtr nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pVariable->begin();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolVariable_End( VariablePtr nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pVariable->end();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolVariable_ArrayBegin( VariablePtr nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pVariable->array_begin();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  IteratorPtr GXDLLAPI DataPoolVariable_ArrayEnd( VariablePtr nVariable )
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      DataPool::iterator* pChildIter = new DataPool::iterator;
      *pChildIter = pVariable->array_end();
      return (IteratorPtr)pChildIter;
    }
    return 0;
  }

  TypeCategory  GXDLLAPI DataPoolVariable_Category  (VariablePtr nVariable)
  {
    DataPoolVariable* pVariable = (DataPoolVariable*)nVariable;
    if(pVariable) {
      return pVariable->GetTypeCategory();
    }
    return T_UNDEFINE;
  }
} // extern "C"

