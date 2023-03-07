
#define KEY_LEN 128

#define KEY_LEN_LEN 256
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

#include "simple.h"
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

unsigned char rsa_ciphertext[KEY_LEN];
/* encode the message with rsa */
int  rsa_encode_(const char *input,  int input_len, char* encode )
{
	if( input_len > MAX_INPUT_LEN || input_len < MIN_INPUT_LEN)
		return 1;

    rsa_context rsa;
	//内存释放
	unsigned char *rsa_plaintext = new unsigned char[input_len];
    rsa_init( &rsa, RSA_PKCS_V15, 0 );
	
	/*   compute the E*/
    rsa.len = KEY_LEN;
    mpi_read_string( &rsa.N , 16, RSA_N  );
    mpi_read_string( &rsa.E , 16, RSA_E );
    if( rsa_check_pubkey(  &rsa ) != 0 )
    {
        return 1;
    }
	
    memcpy( rsa_plaintext, input, input_len );

    if( rsa_pkcs1_encrypt( &rsa, &myrand, NULL, RSA_PUBLIC, input_len,
                           rsa_plaintext, rsa_ciphertext ) != 0 )
    {
        return 1;
    }
	
	//printf("*******************encode code***************************\n");	
	StrToB16(rsa_ciphertext,false,encode);
	//printf("temp_data = \n%s\n",encode);
	//printf("*******************encode code***************************\n");
	delete[] rsa_plaintext;
	rsa_plaintext = NULL;
	rsa_free( &rsa ); 
	return 0;
}

unsigned char rsa_decrypted[128];
/* decode the message */
int rsa_decode_(const char* output, int output_len, char* decode )
{	
	if( output_len <= MIN_INPUT_LEN )
		return 1;

	char* ret = NULL;
	size_t len;
    rsa_context rsa;	
	unsigned char rsa_cinphertext[KEY_LEN];
	
    rsa_init( &rsa, RSA_PKCS_V15, 0 );

    rsa.len = KEY_LEN;
    mpi_read_string( &rsa.N , 16, RSA_N  );
    mpi_read_string( &rsa.E , 16, RSA_E  );
    mpi_read_string( &rsa.D , 16, RSA_D  );
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
        return 1;
    }

	/**编码转化**/
    char dst_data[256];
	memcpy(dst_data,output,output_len);
    //printf("dst_data = %s \n",dst_data);
	B16toStr(dst_data,rsa_cinphertext);	
	//printf("decode = %s \n",rsa_ciphertext);
	
    if( rsa_pkcs1_decrypt( &rsa, RSA_PRIVATE, &len,
                           rsa_cinphertext, rsa_decrypted,
                           sizeof(rsa_decrypted) ) != 0 )
    {
        return 1;
    }

	memcpy(decode,rsa_decrypted,len);	
	rsa_free( &rsa ); 
	return 0;
}
