using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class TransAuthResult : Protocol
	{
		public const int PROTOCOL_TYPE = 6;
		public int retcode;	
		public int server_received_count;	
		public sbyte do_reset;	

		public TransAuthResult()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			retcode = 0;
			server_received_count = 0;
			do_reset = 0;
		}

		public override Object Clone()
		{
			TransAuthResult obj = new TransAuthResult();
			obj.retcode = retcode;
			obj.server_received_count = server_received_count;
			obj.do_reset = do_reset;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(retcode);
			os.marshal(server_received_count);
			os.marshal(do_reset);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			retcode = os.unmarshal_int();
			server_received_count = os.unmarshal_int();
			do_reset = os.unmarshal_sbyte();
			return os;
		}

	}
}
