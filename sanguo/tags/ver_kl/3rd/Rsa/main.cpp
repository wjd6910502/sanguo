#include "rsa.h"

void test_rsa_interface()
{
	GNET::Octets pubkey ,input ,prikey ,output ,ret;

	printf("******************test  interface******************\n");
	
	const char * str = "wwww";
	
	/*---------------encode data with pubkey---------------*/
	printf("          resouc_data  =  %s\n",str);
	pubkey.push_back(RSA_E,strlen(RSA_E)+1);
	input.push_back(str,strlen(str)+1);
	ret = rsa_encode(pubkey,input);
	
	//printf("          encode_data  =  %.*s\r\t\n",(int)ret.size(),(char*)ret.begin());
	/*--------------decode data with prikey---------------*/
	prikey.push_back(RSA_D,strlen(RSA_D)+1);	
	output = ret;
	
	/*À´×Ôc#¶ËµÄb16±àÂë²âÊÔ*/
	//char dst_datat[256];
	//memcpy(dst_datat,"360CE0CE300302F280292BEF7CB04F34C482AF75C4F555163CBDF9D33338DFAA67CA79DFEB676909552E01D3D5F5F913B9FAA9CD3A7816F07E41BBFC095D8CB0DA560F4AB849D9A26FC545E1005B3AA11B7C3E7D006CF2126476734EADB8833868CC5DF7355DF3EE443D7FB85577E92664AA65A143E62A343BB853274231D6A5",256);
	
	//unsigned char strs[128];
	//B16toStr(dst_datat,strs );
	//output.push_back((const char*)dst_datat,256);
	//printf("output  =  %.*s\n",(int)output.size(),(unsigned char*)output.begin()); 
	
	ret = rsa_decode(prikey,output);
	printf("          decode_data  =  %.*s\n",(int)ret.size(),(unsigned char*)ret.begin());
	
	printf("********************** compare result ******************\n");
	if(memcmp((char*)ret.begin(),str,(int)ret.size()) != 0)
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
