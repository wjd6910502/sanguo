#include "rsa.h"

void test_rsa_interface()
{
	GNET::Octets pubkey ,input ,prikey ,output ,ret;

	printf("******************test  interface******************\n");
	
	const char * str = "hello rsa , 12123";
	
	/*---------------encode data with pubkey---------------*/
	printf("          resouc_data  =  %s\n",str);
	pubkey.push_back(RSA_E,strlen(RSA_E)+1);
	input.push_back(str,strlen(str)+1);
	ret = rsa_encode(pubkey,input);
	
	printf("          encode_data  =  %.*s\r\t\n",(int)ret.size(),(char*)ret.begin());
	/*--------------decode data with prikey---------------*/
	prikey.push_back(RSA_D,strlen(RSA_D)+1);	
	output = ret;
	ret = rsa_decode(prikey,output);
	printf("          decode_data  =  %.*s\n",(int)ret.size(),(unsigned char*)ret.begin());
	
	printf("********************** compare result ******************\n");
	if(memcmp((char*)ret.begin(),str,strlen(str)) != 0)
		printf("***********************************************false\n");
	else
		printf("*************************************************success\n");	
	


}

#include <iostream>
int main()
{
	test_rsa_interface(); 		
 	//rsa_self_test(0);
 
 	//printf("******************decode_data****************************\n");
 	//printf("**********************************************************\n");
	
 return 0;

}
