#include "include/clstd.h"
#include "include/clBuffer.H"
#include "include/clString.H"
#include "include/clUtility.H"

//////////////////////////////////////////////////////////////////////////
namespace clstd
{
  FixedBuffer::FixedBuffer()
    : clBufferBase(NULL, 0)
  {
  }

  FixedBuffer::FixedBuffer(clsize nSize)
    : clBufferBase(nSize != 0 ? new CLBYTE[nSize] : NULL, nSize)
  {
  }

  FixedBuffer::~FixedBuffer()
  {
    SAFE_DELETE(m_lpBuffer);
  }

  b32 FixedBuffer::Resize(clsize dwSize, b32 bZeroInit)
  {
    if(dwSize == m_uSize) {
      return FALSE;
    }

    if(dwSize == 0) {
      SAFE_DELETE(m_lpBuffer);
    }
    else
    {
      CLBYTE* pNewBuffer = new CLBYTE[dwSize];
      if(m_lpBuffer != NULL) {
        memcpy(pNewBuffer, m_lpBuffer, clMin(m_uSize, dwSize));
        delete m_lpBuffer;
      }
      m_lpBuffer = pNewBuffer;

      if(bZeroInit && dwSize > m_uSize) {
        memset(m_lpBuffer + m_uSize, 0, dwSize - m_uSize);
      }
    }

    m_uSize = dwSize;
    return TRUE;
  }

  void FixedBuffer::Set(CLLPVOID lpData, clsize cbSize)
  {
    Resize(cbSize, FALSE);
    ASSERT(cbSize == m_uSize);
    memcpy(m_lpBuffer, lpData, cbSize);
  }

  void FixedBuffer::Set(const clBufferBase* pBuffer)
  {
    Set(pBuffer->GetPtr(), pBuffer->GetSize());
  }
} // namespace clstd

//////////////////////////////////////////////////////////////////////////  
clBuffer::clBuffer(u32 nPageSize)
  : clBufferBase(NULL, 0)
  , m_nCapacity(0)
  , m_nPageSize(nPageSize)
{
}

clBuffer::~clBuffer()
{
  SAFE_DELETE(m_lpBuffer);
  m_uSize = 0;
  m_nCapacity = 0;
}

b32 clBuffer::Reserve(clsize dwSize)
{
  if(dwSize > m_uSize)
  {
    auto nOriginSize = m_uSize;
    b32 r = Resize(dwSize, FALSE);
    m_uSize = nOriginSize;
    return r;
  }
  return FALSE;
}

b32 clBuffer::Resize(clsize dwSize, b32 bZeroInit)
{
  if(dwSize >= m_nCapacity)
  {
    m_nCapacity = ((dwSize / m_nPageSize) + 1) * m_nPageSize;
    CLBYTE* pNewBuffer = new CLBYTE[m_nCapacity];

    memcpy(pNewBuffer, m_lpBuffer, m_uSize);
    delete m_lpBuffer;
    m_lpBuffer = pNewBuffer;
  }

  if(bZeroInit && dwSize > m_uSize) {
    memset(m_lpBuffer + m_uSize, 0, dwSize - m_uSize);
  }

  m_uSize = dwSize;
  return TRUE;
}

clsize clBuffer::GetSize() const
{
  return m_uSize;
}

CLLPVOID clBuffer::GetPtr() const
{
  return m_lpBuffer;  
}

b32 clBuffer::Append(CLLPCVOID lpData, clsize dwSize)
{
  clsize dwTail = m_uSize;
  Resize(m_uSize + dwSize, FALSE);
  memcpy(m_lpBuffer + dwTail, lpData, dwSize);
  return TRUE;
}

b32 clBuffer::Replace(clsize nPos, clsize nLen, CLLPCVOID lpData, clsize cbSize)
{
  if(nPos + nLen >= m_uSize)
  {
    m_uSize = nPos;
    Append(lpData, cbSize);
    return TRUE;
  }

  if(nLen != cbSize)
  {
    clsize dwTail = m_uSize - (nPos + nLen);
    Resize(m_uSize - nLen + cbSize, FALSE);
    memcpy(m_lpBuffer + nPos + cbSize, m_lpBuffer + nPos + nLen, dwTail);
  }

  if(lpData != NULL && cbSize != 0) {
    memcpy(m_lpBuffer + nPos, lpData, cbSize);
  }
  return TRUE;
}

b32 clBuffer::Insert(clsize nPos, CLLPCVOID lpData, clsize cbSize)
{
  return Replace(nPos, 0, lpData, cbSize);
}

//////////////////////////////////////////////////////////////////////////
clQueueBuffer::clQueueBuffer(u32 uElementSize)
  : m_pHead(NULL)
  , m_pTail(NULL)
  , m_uSize(0)
  , m_uElementSize(uElementSize)
{
}

void* clQueueBuffer::front()
{
  return ((u8*)m_pHead) + sizeof(HEADER);
}

void* clQueueBuffer::back()
{
  return ((u8*)m_pTail) + sizeof(HEADER);
}

void clQueueBuffer::pop()
{
  if(m_pHead == NULL) {
    return;
  }

  HEADER* pNext = m_pHead->pNext;
  
  delete m_pHead;
  m_pHead = pNext;

  m_uSize--;
}

void clQueueBuffer::push(void* pFixedData)
{
   HEADER* pNew = (HEADER*)new u8[sizeof(HEADER) + m_uElementSize];
   
   pNew->pNext = NULL;
   memcpy(((u8*)pNew) + sizeof(HEADER), pFixedData, m_uElementSize);

   ASSERT(m_pTail->pNext == NULL);
   m_pTail->pNext = pNew;
   m_pTail = pNew;
   m_uSize++;
}

void clQueueBuffer::push_front(void* pFixedData)
{
  HEADER* pNew = (HEADER*)new u8[sizeof(HEADER) + m_uElementSize];

  pNew->pNext = m_pHead;
  memcpy(((u8*)pNew) + sizeof(HEADER), pFixedData, m_uElementSize);

  m_pHead = pNew;
  m_uSize++;
}

void clQueueBuffer::clear()
{
  HEADER* pHead = m_pHead;
  HEADER* pNext = NULL;
  while(pHead != NULL) {
    pNext = pHead->pNext;
    delete pHead;
    pHead = pNext;
  }
  m_pHead = NULL;
  m_pTail = NULL;
  m_uSize = 0;
}

u32 clQueueBuffer::size()
{
  return m_uSize;
}
