#include <sys/stat.h>

#include "AFile.h"
//#include "AFI.h"
#include "AFPI.h"

//ALog*   g_pAFErrLog = NULL;
char    g_szBaseDir[AMAX_PATH] = ".";
//bool    g_bHasBackupBaseDir = false;
//char    g_szBackupBaseDir[AMAX_PATH] = "";

AFile::AFile()
{
//	m_szFileName[0]		= '\0';
	m_szRelativeName[0]	= '\0';

	m_pFile				= NULL;
	m_dwFlags			= 0;
	m_dwTimeStamp		= 0;

	m_bHasOpened		= false;
}

AFile::~AFile()
{
	Close();
}

bool AFile::Open(const char* szPath, ADWORD dwFlags)
{
	// If already opened, we must first close it!
	if( m_bHasOpened )
		Close();

	strncpy(m_szRelativeName, szPath, AMAX_PATH);
	char szOpenFlag[32];

	szOpenFlag[0] = '\0';
	if( dwFlags & AFILE_OPENEXIST )
		strcat(szOpenFlag, "r");

	if( dwFlags & AFILE_CREATENEW )
		strcat(szOpenFlag, "w");

	if( dwFlags & AFILE_OPENAPPEND )
		strcat(szOpenFlag, "a");

	//If there is no binary or text flag, the default is binary;
	if( dwFlags & AFILE_TEXT )
		strcat(szOpenFlag, "t");
	else
		strcat(szOpenFlag, "b");

	char szFileName[1024];
	sprintf(szFileName, "%s/%s", g_szBaseDir, m_szRelativeName);
//	af_UnifyFileName(szFileName);
	m_pFile = fopen(szFileName, szOpenFlag);
	if( NULL == m_pFile )
	{
		return m_bHasOpened;
	}

	ADWORD dwFOURCC;

	if( dwFlags & AFILE_CREATENEW )	//	Create new file
	{
		m_dwFlags = dwFlags;
		if( m_dwFlags & AFILE_TEXT )
		{
			dwFOURCC = 0x54584f4d;
			if( !(m_dwFlags & AFILE_NOHEAD) )
				fwrite(&dwFOURCC, 4, 1, m_pFile);
		}
		else
		{
			dwFOURCC = 0x42584f4d;
			if( !(m_dwFlags & AFILE_NOHEAD) )
				fwrite(&dwFOURCC, 4, 1, m_pFile);
		}
	}
	else	//	Open a normal file
	{
		m_dwFlags = dwFlags & (~(AFILE_BINARY | AFILE_TEXT));

		fread(&dwFOURCC, 4, 1, m_pFile);
		if( dwFOURCC == 0x42584f4d )
			m_dwFlags |= AFILE_BINARY;
		else if( dwFOURCC == 0x54584f4d )
			m_dwFlags |= AFILE_TEXT;
		else
		{
			//Default we use text mode, for we can edit it by hand, and we will not add 
			//the shitting FOURCC at the beginning of the file
			m_dwFlags |= AFILE_TEXT;
			fseek(m_pFile, 0, SEEK_SET);
		}
	}
	
	int idFile = fileno(m_pFile);
	struct stat fileStat;
	fstat(idFile, &fileStat);
	m_dwTimeStamp = (ADWORD)fileStat.st_mtime;

	m_bHasOpened = true;
	return m_bHasOpened;
}

bool AFile::Close()
{
	if( m_pFile )
	{
		fclose(m_pFile);
		m_pFile = NULL;
	}

	m_bHasOpened = false;
	return true;
}

bool AFile::Read(void* pBuffer, ADWORD dwBufferLength, ADWORD * pReadLength)
{
	*pReadLength = (ADWORD)fread(pBuffer, 1, dwBufferLength, m_pFile);
	return true;
}

bool AFile::Write(const void* pBuffer, ADWORD dwBufferLength, ADWORD * pWriteLength)
{
	*pWriteLength = (ADWORD)fwrite(pBuffer, 1, dwBufferLength, m_pFile);
	return true;
}

bool AFile::ReadLine(char * szLineBuffer, ADWORD dwBufferLength, ADWORD * pdwReadLength)
{
	if( !fgets(szLineBuffer, dwBufferLength, m_pFile) )
		return false;

	int nLen = (int)strcspn(szLineBuffer, "\r\n");
	szLineBuffer[nLen] = '\0';
	*pdwReadLength = nLen + 1;
	return true;
}

bool AFile::ReadString(char * szLineBuffer, ADWORD dwBufferLength, ADWORD * pdwReadLength)
{
	char ch;
	ADWORD nStrLen = 0;

	fread(&ch, 1, 1, m_pFile);
	while( ch )
	{
		szLineBuffer[nStrLen] = ch;
		nStrLen ++;

		if( nStrLen >= dwBufferLength )
			return false;

		fread(&ch, 1, 1, m_pFile);
	}

	szLineBuffer[nStrLen] = '\0';

	*pdwReadLength = nStrLen + 1;
	return true;
}

bool AFile::WriteString(const AString& str)
{
	//	Only binary file is supported
/*	if (m_dwFlags & AFILE_TEXT)
	{
		ASSERT(!(m_dwFlags & AFILE_TEXT));
		return false;
	}
*/
	//	Write length of string
	int iLen = str.GetLength();
	fwrite(&iLen, 1, sizeof (int), m_pFile);

	//	Write string data
	if (iLen)
		fwrite((const char*)str, 1, iLen, m_pFile);

	return true;
}

bool AFile::ReadString(AString& str)
{
	//	Only binary file is supported
/*	if (m_dwFlags & AFILE_TEXT)
	{
		ASSERT(!(m_dwFlags & AFILE_TEXT));
		return false;
	}
*/
	//	Read length of string
	int iLen;
	fread(&iLen, 1, sizeof (int), m_pFile);

	//	Read string data
	if (iLen)
	{
		char* szBuf = new char [iLen+1];
		if (!szBuf)
			return false;

		fread(szBuf, 1, iLen, m_pFile);
		szBuf[iLen] = '\0';
		str = szBuf;

		delete [] szBuf;
	}
	else
		str = "";

	return true;
}

bool AFile::WriteLine(const char* szLineBuffer)
{
	if( fprintf(m_pFile, "%s\n", szLineBuffer) < 0 )
		return false;
	return true;
}

ADWORD AFile::GetPos()
{
	ADWORD dwPos;

	dwPos = (ADWORD) ftell(m_pFile);

	return dwPos;
}

bool AFile::Seek(int iOffset, AFILE_SEEK origin)
{
	int iStart = SEEK_SET;

	switch (origin)
	{
	case AFILE_SEEK_SET:	iStart = SEEK_SET;	break;
	case AFILE_SEEK_CUR:	iStart = SEEK_CUR;	break;
	case AFILE_SEEK_END:	iStart = SEEK_END;	break;
	default:
	{
		ASSERT(0);
		return false;
	}
	}

	if( 0 != fseek(m_pFile, iOffset, iStart) )
		return false;

	return true;
}

bool AFile::ResetPointer()
{
	fseek(m_pFile, 0, SEEK_SET);
	return true;
}

//	Get file length
ADWORD AFile::GetFileLength()
{
	ASSERT(m_pFile);

	ADWORD dwPos, dwEnd;

	dwPos = ftell(m_pFile);
	fseek(m_pFile, 0, SEEK_END);
	dwEnd = ftell(m_pFile);
	fseek(m_pFile, dwPos, SEEK_SET);

	return dwEnd;
}

bool AFile::Flush()
{
	fflush(m_pFile);
	return true;
}
