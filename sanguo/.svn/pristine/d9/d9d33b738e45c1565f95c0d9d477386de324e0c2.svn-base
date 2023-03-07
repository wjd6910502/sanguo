using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;


namespace charp_test
{
    class Program
    {
        [DllImport("rsadll.dll",EntryPoint="rsa_encode_", SetLastError= true, CallingConvention = CallingConvention.StdCall)]
        public static extern int rsa_encode_(String input, int input_len,StringBuilder encode);
        [DllImport("rsadll.dll")]
        public static extern int rsa_decode_(String input, int input_len, StringBuilder decode);

        static void Main(string[] args)
        { 
            StringBuilder sb = new StringBuilder(new string('a',256));
            rsa_encode_("wwww",4,sb);
            Console.WriteLine("------------------encode");
            Console.WriteLine(sb.Capacity);
            Console.WriteLine(sb.ToString());
            Console.WriteLine("------------------encode");
            //Console.WriteLine( encode.Length);
            /* encode is const char ,    */
            Console.WriteLine("*******************decode");
            StringBuilder decode = new StringBuilder(new string('\0', 256));
            rsa_decode_(sb.ToString(), 256, decode);
            Console.WriteLine("*******************decode");
            Console.WriteLine(decode.ToString());
        }
    }
}
