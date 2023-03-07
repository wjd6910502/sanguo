/*
 *  The RSA public-key cryptosystem
 *
 *  Copyright (C) 2006-2011, Brainspark B.V.
 *
 *  This file is part of PolarSSL (http://www.polarssl.org)
 *  Lead Maintainer: Paul Bakker <polarssl_maintainer at polarssl.org>
 *
 *  All rights reserved.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
/*
 *  RSA was designed by Ron Rivest, Adi Shamir and Len Adleman.
 *
 *  http://theory.lcs.mit.edu/~rivest/rsapaper.pdf
 *  http://www.cacr.math.uwaterloo.ca/hac/about/chap8.pdf
 */

#include "config.h"

#if defined(POLARSSL_RSA_C)

#include "rsa16.h"
//#include "md.h"

#include <stdlib.h>
#include <stdio.h>

/*
 * Initialize an RSA context
 */
void rsa_init( rsa_context *ctx,
               int padding,
               int hash_id )
{
    memset( ctx, 0, sizeof( rsa_context ) );

    ctx->padding = padding;
    ctx->hash_id = hash_id;
}

#if defined(POLARSSL_GENPRIME)

/*
 * Generate an RSA keypair
 */
int rsa_gen_key( rsa_context *ctx,
                 int (*f_rng)(void *, unsigned char *, size_t),
                 void *p_rng,
                 unsigned int nbits, int exponent )
{
    int ret;
    mpi P1, Q1, H, G;

    if( f_rng == NULL || nbits < 128 || exponent < 3 )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    mpi_init( &P1 ); mpi_init( &Q1 ); mpi_init( &H ); mpi_init( &G );

    /*
     * find primes P and Q with Q < P so that:
     * GCD( E, (P-1)*(Q-1) ) == 1
     */
    MPI_CHK( mpi_lset( &ctx->E, exponent ) );

    do
    {
        MPI_CHK( mpi_gen_prime( &ctx->P, ( nbits + 1 ) >> 1, 0, 
                                f_rng, p_rng ) );

        MPI_CHK( mpi_gen_prime( &ctx->Q, ( nbits + 1 ) >> 1, 0,
                                f_rng, p_rng ) );

        if( mpi_cmp_mpi( &ctx->P, &ctx->Q ) < 0 )
            mpi_swap( &ctx->P, &ctx->Q );

        if( mpi_cmp_mpi( &ctx->P, &ctx->Q ) == 0 )
            continue;

        MPI_CHK( mpi_mul_mpi( &ctx->N, &ctx->P, &ctx->Q ) );
        if( mpi_msb( &ctx->N ) != nbits )
            continue;

        MPI_CHK( mpi_sub_int( &P1, &ctx->P, 1 ) );
        MPI_CHK( mpi_sub_int( &Q1, &ctx->Q, 1 ) );
        MPI_CHK( mpi_mul_mpi( &H, &P1, &Q1 ) );
        MPI_CHK( mpi_gcd( &G, &ctx->E, &H  ) );
    }
    while( mpi_cmp_int( &G, 1 ) != 0 );

    /*
     * D  = E^-1 mod ((P-1)*(Q-1))
     * DP = D mod (P - 1)
     * DQ = D mod (Q - 1)
     * QP = Q^-1 mod P
     */
    MPI_CHK( mpi_inv_mod( &ctx->D , &ctx->E, &H  ) );
    MPI_CHK( mpi_mod_mpi( &ctx->DP, &ctx->D, &P1 ) );
    MPI_CHK( mpi_mod_mpi( &ctx->DQ, &ctx->D, &Q1 ) );
    MPI_CHK( mpi_inv_mod( &ctx->QP, &ctx->Q, &ctx->P ) );

    ctx->len = ( mpi_msb( &ctx->N ) + 7 ) >> 3;

cleanup:

    mpi_free( &P1 ); mpi_free( &Q1 ); mpi_free( &H ); mpi_free( &G );

    if( ret != 0 )
    {
        rsa_free( ctx );
        return( POLARSSL_ERR_RSA_KEY_GEN_FAILED + ret );
    }

    return( 0 );   
}

#endif

/*
 * Check a public RSA key
 */
int rsa_check_pubkey( const rsa_context *ctx )
{
    if( !ctx->N.p || !ctx->E.p )
        return( POLARSSL_ERR_RSA_KEY_CHECK_FAILED );

    if( ( ctx->N.p[0] & 1 ) == 0 || 
        ( ctx->E.p[0] & 1 ) == 0 )
        return( POLARSSL_ERR_RSA_KEY_CHECK_FAILED );

    if( mpi_msb( &ctx->N ) < 128 ||
        mpi_msb( &ctx->N ) > POLARSSL_MPI_MAX_BITS )
        return( POLARSSL_ERR_RSA_KEY_CHECK_FAILED );

    if( mpi_msb( &ctx->E ) < 2 ||
        mpi_msb( &ctx->E ) > 64 )
        return( POLARSSL_ERR_RSA_KEY_CHECK_FAILED );

    return( 0 );
}

/*
 * Check a private RSA key
 */
int rsa_check_privkey( const rsa_context *ctx )
{
    int ret;
    mpi PQ, DE, P1, Q1, H, I, G, G2, L1, L2;

    if( ( ret = rsa_check_pubkey( ctx ) ) != 0 )
        return( ret );

    if( !ctx->P.p || !ctx->Q.p || !ctx->D.p )
        return( POLARSSL_ERR_RSA_KEY_CHECK_FAILED );

    mpi_init( &PQ ); mpi_init( &DE ); mpi_init( &P1 ); mpi_init( &Q1 );
    mpi_init( &H  ); mpi_init( &I  ); mpi_init( &G  ); mpi_init( &G2 );
    mpi_init( &L1 ); mpi_init( &L2 );

    MPI_CHK( mpi_mul_mpi( &PQ, &ctx->P, &ctx->Q ) );
    MPI_CHK( mpi_mul_mpi( &DE, &ctx->D, &ctx->E ) );
    MPI_CHK( mpi_sub_int( &P1, &ctx->P, 1 ) );
    MPI_CHK( mpi_sub_int( &Q1, &ctx->Q, 1 ) );
    MPI_CHK( mpi_mul_mpi( &H, &P1, &Q1 ) );
    MPI_CHK( mpi_gcd( &G, &ctx->E, &H  ) );

    MPI_CHK( mpi_gcd( &G2, &P1, &Q1 ) );
    MPI_CHK( mpi_div_mpi( &L1, &L2, &H, &G2 ) );  
    MPI_CHK( mpi_mod_mpi( &I, &DE, &L1  ) );

    /*
     * Check for a valid PKCS1v2 private key
     */
    if( mpi_cmp_mpi( &PQ, &ctx->N ) != 0 ||
        mpi_cmp_int( &L2, 0 ) != 0 ||
        mpi_cmp_int( &I, 1 ) != 0 ||
        mpi_cmp_int( &G, 1 ) != 0 )
    {
        ret = POLARSSL_ERR_RSA_KEY_CHECK_FAILED;
    }

    
cleanup:

    mpi_free( &PQ ); mpi_free( &DE ); mpi_free( &P1 ); mpi_free( &Q1 );
    mpi_free( &H  ); mpi_free( &I  ); mpi_free( &G  ); mpi_free( &G2 );
    mpi_free( &L1 ); mpi_free( &L2 );

    if( ret == POLARSSL_ERR_RSA_KEY_CHECK_FAILED )
        return( ret );

    if( ret != 0 )
        return( POLARSSL_ERR_RSA_KEY_CHECK_FAILED + ret );

    return( 0 );
}

/*
 * Do an RSA public key operation
 */
int rsa_public( rsa_context *ctx,
                const unsigned char *input,
                unsigned char *output )
{
    int ret;
    size_t olen;
    mpi T;

    mpi_init( &T );

    MPI_CHK( mpi_read_binary( &T, input, ctx->len ) );

    if( mpi_cmp_mpi( &T, &ctx->N ) >= 0 )
    {
        mpi_free( &T );
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
    }

    olen = ctx->len;
    MPI_CHK( mpi_exp_mod( &T, &T, &ctx->E, &ctx->N, &ctx->RN ) );
    MPI_CHK( mpi_write_binary( &T, output, olen ) );

cleanup:

    mpi_free( &T );

    if( ret != 0 )
        return( POLARSSL_ERR_RSA_PUBLIC_FAILED + ret );

    return( 0 );
}

/*
 * Do an RSA private key operation
 */
int rsa_private( rsa_context *ctx,
                 const unsigned char *input,
                 unsigned char *output )
{
    int ret;
    size_t olen;
    mpi T, T1, T2;

    mpi_init( &T ); mpi_init( &T1 ); mpi_init( &T2 );

    MPI_CHK( mpi_read_binary( &T, input, ctx->len ) );

    if( mpi_cmp_mpi( &T, &ctx->N ) >= 0 )
    {
        mpi_free( &T );
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
    }

#if defined(POLARSSL_RSA_NO_CRT)
    MPI_CHK( mpi_exp_mod( &T, &T, &ctx->D, &ctx->N, &ctx->RN ) );
#else
    /*
     * faster decryption using the CRT
     *
     * T1 = input ^ dP mod P
     * T2 = input ^ dQ mod Q
     */
    MPI_CHK( mpi_exp_mod( &T1, &T, &ctx->DP, &ctx->P, &ctx->RP ) );
    MPI_CHK( mpi_exp_mod( &T2, &T, &ctx->DQ, &ctx->Q, &ctx->RQ ) );

    /*
     * T = (T1 - T2) * (Q^-1 mod P) mod P
     */
    MPI_CHK( mpi_sub_mpi( &T, &T1, &T2 ) );
    MPI_CHK( mpi_mul_mpi( &T1, &T, &ctx->QP ) );
    MPI_CHK( mpi_mod_mpi( &T, &T1, &ctx->P ) );

    /*
     * output = T2 + T * Q
     */
    MPI_CHK( mpi_mul_mpi( &T1, &T, &ctx->Q ) );
    MPI_CHK( mpi_add_mpi( &T, &T2, &T1 ) );
#endif

    olen = ctx->len;
    MPI_CHK( mpi_write_binary( &T, output, olen ) );

cleanup:

    mpi_free( &T ); mpi_free( &T1 ); mpi_free( &T2 );

    if( ret != 0 )
        return( POLARSSL_ERR_RSA_PRIVATE_FAILED + ret );

    return( 0 );
}

#if defined(POLARSSL_PKCS1_V21)
/**
 * Generate and apply the MGF1 operation (from PKCS#1 v2.1) to a buffer.
 *
 * \param dst       buffer to mask
 * \param dlen      length of destination buffer
 * \param src       source of the mask generation
 * \param slen      length of the source buffer
 * \param md_ctx    message digest context to use
 */
/*static void mgf_mask( unsigned char *dst, size_t dlen, unsigned char *src, size_t slen,  
                       md_context_t *md_ctx )
{
    unsigned char mask[POLARSSL_MD_MAX_SIZE];
    unsigned char counter[4];
    unsigned char *p;
    unsigned int hlen;
    size_t i, use_len;

    memset( mask, 0, POLARSSL_MD_MAX_SIZE );
    memset( counter, 0, 4 );

    hlen = md_ctx->md_info->size;

    // Generate and apply dbMask
    //
    p = dst;

    while( dlen > 0 )
    {
        use_len = hlen;
        if( dlen < hlen )
            use_len = dlen;

        md_starts( md_ctx );
        md_update( md_ctx, src, slen );
        md_update( md_ctx, counter, 4 );
        md_finish( md_ctx, mask );

        for( i = 0; i < use_len; ++i )
            *p++ ^= mask[i];

        counter[3]++;

        dlen -= use_len;
    }
}*/
#endif

/*
 * Add the message padding, then do an RSA operation
 */

int rsa_pkcs1_encrypt( rsa_context *ctx,
                       int (*f_rng)(void *, unsigned char *, size_t),
                       void *p_rng,
                       int mode, size_t ilen,
                       const unsigned char *input,
                       unsigned char *output )
{
    size_t nb_pad, olen;
	int i = 0;
    int ret;
    unsigned char *p = output;
#if defined(POLARSSL_PKCS1_V21)
    //unsigned int hlen;
    //const md_info_t *md_info;
    //md_context_t md_ctx;
#endif

    olen = ctx->len;

    if( f_rng == NULL )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
	
    switch( ctx->padding )
    {
        case RSA_PKCS_V15:

            if( olen < ilen + 11 )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            nb_pad = olen - 3 - ilen;

            *p++ = 0;
            if( mode == RSA_PUBLIC )
            {
                *p++ = RSA_CRYPT;

                while( nb_pad-- > 0 )
                {
                    int rng_dl = 100;

                    do {
                        ret = f_rng( p_rng, p, 1 );
                    } while( *p == 0 && --rng_dl && ret == 0 );

                    // Check if RNG failed to generate data
                    //
                    if( rng_dl == 0 || ret != 0)
                        return POLARSSL_ERR_RSA_RNG_FAILED + ret;

                    p++;
					i++;
                }
            }
            else
            {
                *p++ = RSA_SIGN;

                while( nb_pad-- > 0 )
                    *p++ = 0xFF;
            }

            *p++ = 0;
            memcpy( p, input, ilen );
			printf("output = %s -%d",p,strlen(p));
//			B16Encode(p, false);
            break;
        
/*#if defined(POLARSSL_PKCS1_V21)
        case RSA_PKCS_V21:

            md_info = md_info_from_type( ctx->hash_id );
            if( md_info == NULL )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            hlen = md_get_size( md_info );

            if( olen < ilen + 2 * hlen + 2 || f_rng == NULL )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            memset( output, 0, olen );

            *p++ = 0;

            // Generate a random octet string seed
            //
            if( ( ret = f_rng( p_rng, p, hlen ) ) != 0 )
                return( POLARSSL_ERR_RSA_RNG_FAILED + ret );

            p += hlen;

            // Construct DB
            //
            md( md_info, p, 0, p );
            p += hlen;
            p += olen - 2 * hlen - 2 - ilen;
            *p++ = 1;
            memcpy( p, input, ilen ); 

            md_init_ctx( &md_ctx, md_info );

            // maskedDB: Apply dbMask to DB
            //
            mgf_mask( output + hlen + 1, olen - hlen - 1, output + 1, hlen,  
                       &md_ctx );

            // maskedSeed: Apply seedMask to seed
            //
            mgf_mask( output + 1, hlen, output + hlen + 1, olen - hlen - 1,  
                       &md_ctx );

            md_free_ctx( &md_ctx );
            break;
#endif*/

        default:

            return( POLARSSL_ERR_RSA_INVALID_PADDING );
    }

    return( ( mode == RSA_PUBLIC )
            ? rsa_public(  ctx, output, output )
            : rsa_private( ctx, output, output ) );
}

/*
 * Do an RSA operation, then remove the message padding
 */
int rsa_pkcs1_decrypt( rsa_context *ctx,
                       int mode, size_t *olen,
                       const unsigned char *input,
                       unsigned char *output,
                       size_t output_max_len)
{
    int ret, correct = 1;
    size_t ilen, pad_count = 0;
    unsigned char *p, *q;
    unsigned char bt;
    unsigned char buf[1024];
#if defined(POLARSSL_PKCS1_V21)
    //unsigned char lhash[POLARSSL_MD_MAX_SIZE];
    //unsigned int hlen;
    //const md_info_t *md_info;
    //md_context_t md_ctx;
#endif

    ilen = ctx->len;

    if( ilen < 16 || ilen > sizeof( buf ) )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    ret = ( mode == RSA_PUBLIC )
          ? rsa_public(  ctx, input, buf )
          : rsa_private( ctx, input, buf );

    if( ret != 0 )
        return( ret );

    p = buf;
    switch( ctx->padding )
    {
        case RSA_PKCS_V15:
			
            if( *p++ != 0 )
                correct = 0;
            
            bt = *p++;
            if( ( bt != RSA_CRYPT && mode == RSA_PRIVATE ) ||
                ( bt != RSA_SIGN && mode == RSA_PUBLIC ) )
            {
                correct = 0;
				
            }

            if( bt == RSA_CRYPT )
            {
                while( *p != 0 && p < buf + ilen - 1 )
                    pad_count += ( *p++ != 0 );

                correct &= ( *p == 0 && p < buf + ilen - 1 );

                q = p;

                // Also pass over all other bytes to reduce timing differences
                //
                while ( q < buf + ilen - 1 )
                    pad_count += ( *q++ != 0 );

                // Prevent compiler optimization of pad_count
                //
                correct |= pad_count & 0x100000; /* Always 0 unless 1M bit keys */
                p++;
			
            }
            else
            {
                while( *p == 0xFF && p < buf + ilen - 1 )
                    pad_count += ( *p++ == 0xFF );

                correct &= ( *p == 0 && p < buf + ilen - 1 );
				
                q = p;

                // Also pass over all other bytes to reduce timing differences
                //
                while ( q < buf + ilen - 1 )
                    pad_count += ( *q++ != 0 );

                // Prevent compiler optimization of pad_count
                //
                correct |= pad_count & 0x100000; /* Always 0 unless 1M bit keys */
               
				p++;
            }

            if( correct == 0 )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            break;

/*#if defined(POLARSSL_PKCS1_V21)
        case RSA_PKCS_V21:
            
            if( *p++ != 0 )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            md_info = md_info_from_type( ctx->hash_id );
            if( md_info == NULL )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
                
            hlen = md_get_size( md_info );

            md_init_ctx( &md_ctx, md_info );
            
            // Generate lHash
            //
            md( md_info, lhash, 0, lhash );

            // seed: Apply seedMask to maskedSeed
            //
            mgf_mask( buf + 1, hlen, buf + hlen + 1, ilen - hlen - 1,
                       &md_ctx );

            // DB: Apply dbMask to maskedDB
            //
            mgf_mask( buf + hlen + 1, ilen - hlen - 1, buf + 1, hlen,  
                       &md_ctx );

            p += hlen;
            md_free_ctx( &md_ctx );

            // Check validity
            //
            if( memcmp( lhash, p, hlen ) != 0 )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            p += hlen;

            while( *p == 0 && p < buf + ilen )
                p++;

            if( p == buf + ilen )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            if( *p++ != 0x01 )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            break;
#endif*/

        default:
			
            return( POLARSSL_ERR_RSA_INVALID_PADDING );
    }

    if (ilen - (p - buf) > output_max_len)
        return( POLARSSL_ERR_RSA_OUTPUT_TOO_LARGE );

    *olen = ilen - (p - buf);
    memcpy( output, p, *olen );

    return( 0 );
}

/*
 * Do an RSA operation to sign the message digest
 */
int rsa_pkcs1_sign( rsa_context *ctx,
                    int (*f_rng)(void *, unsigned char *, size_t),
                    void *p_rng,
                    int mode,
                    int hash_id,
                    unsigned int hashlen,
                    const unsigned char *hash,
                    unsigned char *sig )
{
    size_t nb_pad, olen;
    unsigned char *p = sig;
#if defined(POLARSSL_PKCS1_V21)
    //unsigned char salt[POLARSSL_MD_MAX_SIZE];
    //unsigned int slen, hlen, offset = 0;
    //int ret;
    //size_t msb;
    //const md_info_t *md_info;
    //md_context_t md_ctx;
#else
    (void) f_rng;
    (void) p_rng;
#endif

    olen = ctx->len;

    switch( ctx->padding )
    {
        case RSA_PKCS_V15:

            switch( hash_id )
            {
                case SIG_RSA_RAW:
                    nb_pad = olen - 3 - hashlen;
                    break;

                case SIG_RSA_MD2:
                case SIG_RSA_MD4:
                case SIG_RSA_MD5:
                    nb_pad = olen - 3 - 34;
                    break;

                case SIG_RSA_SHA1:
                    nb_pad = olen - 3 - 35;
                    break;

                case SIG_RSA_SHA224:
                    nb_pad = olen - 3 - 47;
                    break;

                case SIG_RSA_SHA256:
                    nb_pad = olen - 3 - 51;
                    break;

                case SIG_RSA_SHA384:
                    nb_pad = olen - 3 - 67;
                    break;

                case SIG_RSA_SHA512:
                    nb_pad = olen - 3 - 83;
                    break;


                default:
                    return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
            }

            if( ( nb_pad < 8 ) || ( nb_pad > olen ) )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            *p++ = 0;
            *p++ = RSA_SIGN;
            memset( p, 0xFF, nb_pad );
            p += nb_pad;
            *p++ = 0;

            switch( hash_id )
            {
                case SIG_RSA_RAW:
                    memcpy( p, hash, hashlen );
                    break;

                case SIG_RSA_MD2:
                    memcpy( p, ASN1_HASH_MDX, 18 );
                    memcpy( p + 18, hash, 16 );
                    p[13] = 2; break;

                case SIG_RSA_MD4:
                    memcpy( p, ASN1_HASH_MDX, 18 );
                    memcpy( p + 18, hash, 16 );
                    p[13] = 4; break;

                case SIG_RSA_MD5:
                    memcpy( p, ASN1_HASH_MDX, 18 );
                    memcpy( p + 18, hash, 16 );
                    p[13] = 5; break;

                case SIG_RSA_SHA1:
                    memcpy( p, ASN1_HASH_SHA1, 15 );
                    memcpy( p + 15, hash, 20 );
                    break;

                case SIG_RSA_SHA224:
                    memcpy( p, ASN1_HASH_SHA2X, 19 );
                    memcpy( p + 19, hash, 28 );
                    p[1] += 28; p[14] = 4; p[18] += 28; break;

                case SIG_RSA_SHA256:
                    memcpy( p, ASN1_HASH_SHA2X, 19 );
                    memcpy( p + 19, hash, 32 );
                    p[1] += 32; p[14] = 1; p[18] += 32; break;

                case SIG_RSA_SHA384:
                    memcpy( p, ASN1_HASH_SHA2X, 19 );
                    memcpy( p + 19, hash, 48 );
                    p[1] += 48; p[14] = 2; p[18] += 48; break;

                case SIG_RSA_SHA512:
                    memcpy( p, ASN1_HASH_SHA2X, 19 );
                    memcpy( p + 19, hash, 64 );
                    p[1] += 64; p[14] = 3; p[18] += 64; break;

                default:
                    return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
            }

            break;

/*#if defined(POLARSSL_PKCS1_V21)
        case RSA_PKCS_V21:

            if( f_rng == NULL )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            switch( hash_id )
            {
                case SIG_RSA_MD2:
                case SIG_RSA_MD4:
                case SIG_RSA_MD5:
                    hashlen = 16;
                    break;

                case SIG_RSA_SHA1:
                    hashlen = 20;
                    break;

                case SIG_RSA_SHA224:
                    hashlen = 28;
                    break;

                case SIG_RSA_SHA256:
                    hashlen = 32;
                    break;

                case SIG_RSA_SHA384:
                    hashlen = 48;
                    break;

                case SIG_RSA_SHA512:
                    hashlen = 64;
                    break;

                default:
                    return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
            }

            md_info = md_info_from_type( ctx->hash_id );
            if( md_info == NULL )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
                
            hlen = md_get_size( md_info );
            slen = hlen;

            if( olen < hlen + slen + 2 )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            memset( sig, 0, olen );

            msb = mpi_msb( &ctx->N ) - 1;

            // Generate salt of length slen
            //
            if( ( ret = f_rng( p_rng, salt, slen ) ) != 0 )
                return( POLARSSL_ERR_RSA_RNG_FAILED + ret );

            // Note: EMSA-PSS encoding is over the length of N - 1 bits
            //
            msb = mpi_msb( &ctx->N ) - 1;
            p += olen - hlen * 2 - 2;
            *p++ = 0x01;
            memcpy( p, salt, slen );
            p += slen;

            md_init_ctx( &md_ctx, md_info );

            // Generate H = Hash( M' )
            //
            md_starts( &md_ctx );
            md_update( &md_ctx, p, 8 );
            md_update( &md_ctx, hash, hashlen );
            md_update( &md_ctx, salt, slen );
            md_finish( &md_ctx, p );

            // Compensate for boundary condition when applying mask
            //
            if( msb % 8 == 0 )
                offset = 1;

            // maskedDB: Apply dbMask to DB
            //
            mgf_mask( sig + offset, olen - hlen - 1 - offset, p, hlen, &md_ctx );

            md_free_ctx( &md_ctx );

            msb = mpi_msb( &ctx->N ) - 1;
            sig[0] &= 0xFF >> ( olen * 8 - msb );

            p += hlen;
            *p++ = 0xBC;
            break;
#endif */

        default:

            return( POLARSSL_ERR_RSA_INVALID_PADDING );
    }

    return( ( mode == RSA_PUBLIC )
            ? rsa_public(  ctx, sig, sig )
            : rsa_private( ctx, sig, sig ) );
}

/*
 * Do an RSA operation and check the message digest
 */
int rsa_pkcs1_verify( rsa_context *ctx,
                      int mode,
                      int hash_id,
                      unsigned int hashlen,
                      const unsigned char *hash,
                      unsigned char *sig )
{
    int ret;
    size_t len, siglen;
    unsigned char *p, c;
    unsigned char buf[1024];
#if defined(POLARSSL_PKCS1_V21)
    //unsigned char result[POLARSSL_MD_MAX_SIZE];
    //unsigned char zeros[8];
    //unsigned int hlen;
    //size_t slen, msb;
    //const md_info_t *md_info;
    //md_context_t md_ctx;
#endif
    siglen = ctx->len;

    if( siglen < 16 || siglen > sizeof( buf ) )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    ret = ( mode == RSA_PUBLIC )
          ? rsa_public(  ctx, sig, buf )
          : rsa_private( ctx, sig, buf );

    if( ret != 0 )
        return( ret );

    p = buf;

    switch( ctx->padding )
    {
        case RSA_PKCS_V15:

            if( *p++ != 0 || *p++ != RSA_SIGN )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            while( *p != 0 )
            {
                if( p >= buf + siglen - 1 || *p != 0xFF )
                    return( POLARSSL_ERR_RSA_INVALID_PADDING );
                p++;
            }
            p++;

            len = siglen - ( p - buf );

            if( len == 34 )
            {
                c = p[13];
                p[13] = 0;

                if( memcmp( p, ASN1_HASH_MDX, 18 ) != 0 )
                    return( POLARSSL_ERR_RSA_VERIFY_FAILED );

                if( ( c == 2 && hash_id == SIG_RSA_MD2 ) ||
                        ( c == 4 && hash_id == SIG_RSA_MD4 ) ||
                        ( c == 5 && hash_id == SIG_RSA_MD5 ) )
                {
                    if( memcmp( p + 18, hash, 16 ) == 0 ) 
                        return( 0 );
                    else
                        return( POLARSSL_ERR_RSA_VERIFY_FAILED );
                }
            }

            if( len == 35 && hash_id == SIG_RSA_SHA1 )
            {
                if( memcmp( p, ASN1_HASH_SHA1, 15 ) == 0 &&
                        memcmp( p + 15, hash, 20 ) == 0 )
                    return( 0 );
                else
                    return( POLARSSL_ERR_RSA_VERIFY_FAILED );
            }
            if( ( len == 19 + 28 && p[14] == 4 && hash_id == SIG_RSA_SHA224 ) ||
                    ( len == 19 + 32 && p[14] == 1 && hash_id == SIG_RSA_SHA256 ) ||
                    ( len == 19 + 48 && p[14] == 2 && hash_id == SIG_RSA_SHA384 ) ||
                    ( len == 19 + 64 && p[14] == 3 && hash_id == SIG_RSA_SHA512 ) )
            {
                c = p[1] - 17;
                p[1] = 17;
                p[14] = 0;

                if( p[18] == c &&
                        memcmp( p, ASN1_HASH_SHA2X, 18 ) == 0 &&
                        memcmp( p + 19, hash, c ) == 0 )
                    return( 0 );
                else
                    return( POLARSSL_ERR_RSA_VERIFY_FAILED );
            }

            if( len == hashlen && hash_id == SIG_RSA_RAW )
            {
                if( memcmp( p, hash, hashlen ) == 0 )
                    return( 0 );
                else
                    return( POLARSSL_ERR_RSA_VERIFY_FAILED );
            }

            break;

/*#if defined(POLARSSL_PKCS1_V21)
        case RSA_PKCS_V21:
            
            if( buf[siglen - 1] != 0xBC )
                return( POLARSSL_ERR_RSA_INVALID_PADDING );

            switch( hash_id )
            {
                case SIG_RSA_MD2:
                case SIG_RSA_MD4:
                case SIG_RSA_MD5:
                    hashlen = 16;
                    break;

                case SIG_RSA_SHA1:
                    hashlen = 20;
                    break;

                case SIG_RSA_SHA224:
                    hashlen = 28;
                    break;

                case SIG_RSA_SHA256:
                    hashlen = 32;
                    break;

                case SIG_RSA_SHA384:
                    hashlen = 48;
                    break;

                case SIG_RSA_SHA512:
                    hashlen = 64;
                    break;

                default:
                    return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
            }

            md_info = md_info_from_type( ctx->hash_id );
            if( md_info == NULL )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
                
            hlen = md_get_size( md_info );
            slen = siglen - hlen - 1;

            memset( zeros, 0, 8 );

            // Note: EMSA-PSS verification is over the length of N - 1 bits
            //
            msb = mpi_msb( &ctx->N ) - 1;

            // Compensate for boundary condition when applying mask
            //
            if( msb % 8 == 0 )
            {
                p++;
                siglen -= 1;
            }
            if( buf[0] >> ( 8 - siglen * 8 + msb ) )
                return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

            md_init_ctx( &md_ctx, md_info );

            mgf_mask( p, siglen - hlen - 1, p + siglen - hlen - 1, hlen, &md_ctx );

            buf[0] &= 0xFF >> ( siglen * 8 - msb );

            while( *p == 0 && p < buf + siglen )
                p++;

            if( p == buf + siglen ||
                *p++ != 0x01 )
            {
                md_free_ctx( &md_ctx );
                return( POLARSSL_ERR_RSA_INVALID_PADDING );
            }

            slen -= p - buf;

            // Generate H = Hash( M' )
            //
            md_starts( &md_ctx );
            md_update( &md_ctx, zeros, 8 );
            md_update( &md_ctx, hash, hashlen );
            md_update( &md_ctx, p, slen );
            md_finish( &md_ctx, result );

            md_free_ctx( &md_ctx );

            if( memcmp( p + slen, result, hlen ) == 0 )
                return( 0 );
            else
                return( POLARSSL_ERR_RSA_VERIFY_FAILED );
#endif*/

        default:

            return( POLARSSL_ERR_RSA_INVALID_PADDING );
    }

    return( POLARSSL_ERR_RSA_INVALID_PADDING );
}

/*
 * Free the components of an RSA key
 */
void rsa_free( rsa_context *ctx )
{
    mpi_free( &ctx->RQ ); mpi_free( &ctx->RP ); mpi_free( &ctx->RN );
    mpi_free( &ctx->QP ); mpi_free( &ctx->DQ ); mpi_free( &ctx->DP );
    mpi_free( &ctx->Q  ); mpi_free( &ctx->P  ); mpi_free( &ctx->D );
    mpi_free( &ctx->E  ); mpi_free( &ctx->N  );
}

#if defined(POLARSSL_SELF_TEST)

//#include "polarssl/sha1.h"

/*
 * Example RSA-1024 keypair, for test purposes
 */


#endif

#endif
