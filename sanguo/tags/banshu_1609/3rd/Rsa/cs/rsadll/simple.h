
#include "rsa16.h"
#include <time.h>
#include <string>

 extern "C" __declspec(dllexport) int rsa_encode_(const char *input,  int input_len, char* encode );
 extern "C" __declspec(dllexport) int rsa_decode_(const char* output, int output_len, char* decode );

 char _i2c(unsigned char i)                                                                                                                                     
{
        const char *_table = "0123456789abcdef";
            if (i < 16) 
                  return _table[i];
                return '0';
}
                                                                                                                                      
char _i2C(unsigned char i)
{
        const char *_table = "0123456789ABCDEF";
            if (i < 16) 
                  return _table[i];
                return '0';
}

char _C2i(char c)
{
	 const char *_table = "0123456789ABCDEF";
     for(int i = 0 ; i < 16; i++)
	 {
		if ( _table[i] == c) 
			return i;
	 }
	 return 0; 
}

int B16toStr(char* dst_data,unsigned char * str )
{
	unsigned char * p = str;
	for(int i = 0; i < 256; i=i+2)
	{
		p[i/2] = (_C2i(dst_data[i]))<<4 | _C2i(dst_data[i+1]); 	
	}
	return 0;
}

inline int StrToB16(unsigned char *o, bool tolower, char* dst_data)
{
	printf("o------------%s\n",o);
	unsigned char *src_data = (unsigned char*)o;
	
	for (unsigned int i=0; i<128; i++)
    {   
            if(tolower)
            {   
                dst_data[2*i] = _i2c(src_data[i]>>4);
                dst_data[2*i+1] = _i2c(src_data[i]&0x0f);
            }   
            else                                                                                                                      
            {   
                dst_data[2*i] = _i2C(src_data[i]>>4);
                dst_data[2*i+1] = _i2C(src_data[i]&0x0f);
            }   
     }

	for(int i = 0 ; i < 256 ; i++)
	{
			printf("%d",dst_data[i]);
	}
	printf("%s ====\n",dst_data);
	printf("\n");	
	return 0;
}

