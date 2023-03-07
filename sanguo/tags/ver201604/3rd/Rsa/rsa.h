/**
 *
 *	@brief 由于文中加密用的是1024长度的私钥，故最大加密长度为128个字节 	
 *  @time 2015-9-22 20:21
 *	
 */

#include "octets.h"
#include <time.h>
#include "rsa16.h"
#define KEY_LEN 128

#define RSA_N   "9292758453063D803DD603D5E777D788" \
                "8ED1D5BF35786190FA2F23EBC0848AEA" \
                "DDA92CA6C3D80B32C4D109BE0F36D6AE" \
                "7130B9CED7ACDF54CFC7555AC14EEBAB" \
                "93A89813FBF3C4F8066D2D800F7C38A8" \
                "1AE31942917403FF4946B0A83D3D3E05" \
                "EE57C6F5F5606FB5D4BC6CD34EE0801A" \
                "5E94BB77B07507233A0BC7BAC8F90F79"

#define RSA_E   "10001"

#define RSA_D   "24BF6185468786FDD303083D25E64EFC" \
                "66CA472BC44D253102F8B4A9D3BFA750" \
                "91386C0077937FE33FA3252D28855837" \
                "AE1B484A8A9A45F7EE8C0C634F99E8CD" \
                "DF79C5CE07EE72C7F123142198164234" \
                "CABB724CF78B8173B9F880FC86322407" \
                "AF1FEDFDDE2BEB674CA15F3E81A1521E" \
                "071513A1E85B5DFA031F21ECAE91A34D"

#define RSA_P   "C36D0EB7FCD285223CFB5AABA5BDA3D8" \
                "2C01CAD19EA484A87EA4377637E75500" \
                "FCB2005C5C7DD6EC4AC023CDA285D796" \
                "C3D9E75E1EFC42488BB4F1D13AC30A57"

#define RSA_Q   "C000DF51A7C77AE8D7C7370C1FF55B69" \
                "E211C2B9E5DB1ED0BF61D0D9899620F4" \
                "910E4168387E3C30AA1E00C339A79508" \
                "8452DD96A9A5EA5D9DCA68DA636032AF"

#define RSA_DP  "C1ACF567564274FB07A0BBAD5D26E298" \
                "3C94D22288ACD763FD8E5600ED4A702D" \
                "F84198A5F06C2E72236AE490C93F07F8" \
                "3CC559CD27BC2D1CA488811730BB5725"

#define RSA_DQ  "4959CBF6F8FEF750AEE6977C155579C7" \
                "D8AAEA56749EA28623272E4F7D0592AF" \
                "7C1F1313CAC9471B5C523BFE592F517B" \
                "407A1BD76C164B93DA2D32A383E58357"

#define RSA_QP  "9AE7FBC99546432DF71896FC239EADAE" \
                "F38D18D2B2F0E2DD275AA977E2BF4411" \
                "F5A3B2A5D33605AEBBCCBA7FEB9F2D2F" \
                "A74206CEC169D74BF5A8C50D6F48EA08"

/*   11 padding + 1 结束字符 "\0" + 1 输入字符串的长度，一个字节   */
#define CONST_PADDING_LEN 14 

/*    容许输入的最大字符串长度                                     */
#define MAX_INPUT_LEN (KEY_LEN - CONST_PADDING_LEN)

/*                                                                */
#define MIN_INPUT_LEN 0

static int myrand( void *rng_state, unsigned char *output, size_t len )
{
    size_t i;

    if( rng_state != NULL )
        rng_state  = NULL;

    for( i = 0; i < len; ++i )
        output[i] = rand();
    
    return( 0 );
}


/* encode the message with rsa */
GNET::Octets rsa_encode_(const char *pub,  int pub_len, const char *input,  int input_len)
{
	/* 这种返回会不会出现内存问题 ？？？？？？*/
	GNET::Octets ret;
	if( pub_len < MIN_INPUT_LEN || pub_len > KEY_LEN || input_len > MAX_INPUT_LEN || input_len < MIN_INPUT_LEN)
		return ret;

    rsa_context rsa;
	unsigned char rsa_plaintext[input_len];
	unsigned char rsa_ciphertext[KEY_LEN];

    rsa_init( &rsa, RSA_PKCS_V15, 0 );
	
	/*   compute the E*/
    rsa.len = KEY_LEN;
    mpi_read_string( &rsa.N , 16, RSA_N  );

	/* read the pubkey E  */
   	char *ekey = new char[pub_len];
	memset(ekey,0,pub_len);
	memcpy(ekey,pub,pub_len);
	if(memcmp(ekey,RSA_E,pub_len) != 0 )
	{
		printf("wrong pubkey\n");
		return	ret; 
	}
    mpi_read_string( &rsa.E , 16, ekey  );
	delete[] ekey;
	ekey = NULL;

    if( rsa_check_pubkey(  &rsa ) != 0 )
    {
        return ret;
    }

    memcpy( rsa_plaintext, input, input_len );
    if( rsa_pkcs1_encrypt( &rsa, &myrand, NULL, RSA_PUBLIC, input_len,
                           rsa_plaintext, rsa_ciphertext ) != 0 )
    {
        return ret;
    }
	
	ret.push_back(rsa_ciphertext,KEY_LEN);
	rsa_free( &rsa ); 

	return ret;
}

GNET::Octets rsa_encode(const GNET::Octets& pubkey, const GNET::Octets& input)
{
	if( pubkey.size() > MAX_INPUT_LEN || input.size() > MAX_INPUT_LEN )
		return 0;

	GNET::Octets ret;
	char* ppubkey =(char *)pubkey.begin();
	char* pinput =(char *)input.begin();	
	
	/* 这里包含俩个字节*/
	int input_len = input.size();
	int pubkey_len = pubkey.size();
	char input_new[input_len + 2];
	memset(input_new,'\0',input_len + 2);
		
	char *pinput_new = input_new;
	*pinput_new = input.size();
	pinput_new++;
	memcpy(pinput_new,pinput,input_len);
	
	ret = rsa_encode_(ppubkey,pubkey_len,input_new,strlen(input_new));
	return ret;

}

/* decode the message */
 GNET::Octets rsa_decode_(const char *prikey, int pri_len, const char* in,int input_len)
{	
	if(pri_len != 2*KEY_LEN + 1 || input_len <= MIN_INPUT_LEN )
		return NULL;

	GNET::Octets ret;
	size_t len;
    rsa_context rsa;	
	unsigned char rsa_ciphertext[KEY_LEN];
	unsigned char rsa_decrypted[input_len];

    rsa_init( &rsa, RSA_PKCS_V15, 0 );

    rsa.len = KEY_LEN;
    mpi_read_string( &rsa.N , 16, RSA_N  );
    mpi_read_string( &rsa.E , 16, RSA_E  );
	
	/* compute dkey */
	char *dkey = new char[pri_len];
	memset(dkey,0,pri_len);
	memcpy(dkey,prikey,pri_len);
	if(memcmp(dkey,RSA_D,pri_len) != 0 )
	{
		printf("wrong prikey\n");
		return ret; 
	}
    mpi_read_string( &rsa.D , 16, dkey  );
	delete[] dkey;
	dkey = NULL;

    mpi_read_string( &rsa.P , 16, RSA_P  );
    mpi_read_string( &rsa.Q , 16, RSA_Q  );
    mpi_read_string( &rsa.DP, 16, RSA_DP );
    mpi_read_string( &rsa.DQ, 16, RSA_DQ );
    mpi_read_string( &rsa.QP, 16, RSA_QP );
	/*************     compute P Q DP DQ QP ****************/
	//mpi P1, Q1, H, G;
    //mpi_init( &P1 ); mpi_init( &Q1 ); mpi_init( &H ); mpi_init( &G );
	//mpi_sub_int( &P1, &rsa.P, 1 );
    //mpi_sub_int( &Q1, &rsa.Q, 1 ); 
    //mpi_mul_mpi( &H, &P1, &Q1 );
    //mpi_gcd( &G, &rsa.E, &H  );
    //mpi_inv_mod( &rsa.D , &rsa.E, &H  ) == 0 );
    //mpi_mod_mpi( &rsa.DP, &rsa.D, &P1 );
    //mpi_mod_mpi( &rsa.DQ, &rsa.D, &Q1 );
    //mpi_inv_mod( &rsa.QP, &rsa.Q, &rsa.P );

    if( rsa_check_pubkey(  &rsa ) != 0 ||
        rsa_check_privkey( &rsa ) != 0 )
    {
        return ret;
    }
	
	memcpy(rsa_ciphertext,in,input_len);
	
    if( rsa_pkcs1_decrypt( &rsa, RSA_PRIVATE, &len,
                           rsa_ciphertext, rsa_decrypted,
                           sizeof(rsa_decrypted) ) != 0 )
    {
        return ret;
    }

	ret.push_back(rsa_decrypted,input_len+1);	
	rsa_free( &rsa ); 

	return ret;

}

GNET::Octets rsa_decode(const GNET::Octets& prikey, const GNET::Octets& input)
{
	//fprintf(stderr,"-----------------prikey.size()= %d",(int)prikey.size());
	if( prikey.size() != 2*KEY_LEN + 1 )
		return NULL;
	
	GNET::Octets ret;
	char* pprikey =(char *)prikey.begin();
	char* pinput =(char *)input.begin();
	
	int prikey_len = prikey.size();
	int input_len  = input.size();
	GNET::Octets rdecode = rsa_decode_(pprikey,prikey_len,pinput,input_len);
	if( rdecode.size() == 0 )
		return NULL;
	
	unsigned int r_len = rdecode.size();
	char* prdecode =(char*)rdecode.begin();
	unsigned int len = *prdecode;
	prdecode++;
	if( len > r_len - 1 )
		return NULL;
	
	ret.push_back(prdecode,len);
	return ret;

}
