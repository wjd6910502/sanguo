/*
 * FILE: AFile.h
 *
 * DESCRIPTION: The class which operating the files in Angelica Engine
 *
 * CREATED BY: Hedi, 2001/12/3
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.	
 */

#ifndef _AFILE_H_
#define _AFILE_H_

#include "AFPlatform.h"
#include "ABaseDef.h"
#include "AString.h"

#define AFILE_TYPE_BINARY			0x42584f4d
#define AFILE_TYPE_TEXT				0x54584f4d

#define AFILE_OPENEXIST				0x00000001
#define AFILE_CREATENEW				0x00000002
#define AFILE_OPENAPPEND			0x00000004
#define AFILE_TEXT					0x00000008
#define AFILE_BINARY				0x00000010
#define AFILE_NOHEAD				0x00000020
#define AFILE_TEMPMEMORY			0x00000040

#define AFILE_LINEMAXLEN			2048

enum AFILE_SEEK
{
	AFILE_SEEK_SET = SEEK_SET,
	AFILE_SEEK_CUR = SEEK_CUR,
	AFILE_SEEK_END = SEEK_END,
};

class AFile
{
private:
	FILE *	m_pFile;

protected:
	// An fullpath file name;
//	char	m_szFileName[AMAX_PATH];

	// An relative file name that relative to the work dir;
	char	m_szRelativeName[AMAX_PATH];

	ADWORD	m_dwFlags;
	ADWORD	m_dwTimeStamp;

	bool	m_bHasOpened;

public:
	AFile();
	virtual ~AFile();

	virtual bool Open(const char* szPath, ADWORD dwFlags);
	virtual bool Close();

	virtual bool Read(void* pBuffer, ADWORD dwBufferLength, ADWORD * pReadLength);
	virtual bool Write(const void* pBuffer, ADWORD dwBufferLength, ADWORD * pWriteLength);

	virtual bool ReadLine(char * szLineBuffer, ADWORD dwBufferLength, ADWORD * pdwReadLength);
	virtual bool ReadString(char * szLineBuffer, ADWORD dwBufferLength, ADWORD * pdwReadLength);
	virtual bool WriteLine(const char * szLineBuffer);
	virtual bool WriteString(const AString& str);
	virtual bool ReadString(AString& str);

	virtual ADWORD GetPos();
	virtual bool Seek(int iOffset, AFILE_SEEK origin);
	virtual bool ResetPointer(); // Reset the file pointer;
	//	Get file length
	virtual ADWORD GetFileLength();
	
	bool Flush();

	inline ADWORD GetTimeStamp() { return m_dwTimeStamp; }
	inline ADWORD GetFlags() { return m_dwFlags; }
	//Binary first, so if there is no binary or text, it is a binary file;
	inline bool IsBinary() { return !IsText(); }
	inline bool IsText() { return (m_dwFlags & AFILE_TEXT) ? true : false; }

//	inline char* GetFileName() { return m_szFileName; }
	inline char* GetRelativeName() { return m_szRelativeName; }

	bool IsOpened() const { return m_bHasOpened; }
};

typedef AFile * PAFile;
#endif