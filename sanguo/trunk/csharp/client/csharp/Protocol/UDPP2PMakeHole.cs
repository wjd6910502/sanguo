using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPP2PMakeHole : Protocol
	{
		public const int PROTOCOL_TYPE = 105;
		public int magic;	
		public sbyte request;	

		public UDPP2PMakeHole()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			magic = 0;
			request = 0;
		}

		public override Object Clone()
		{
			UDPP2PMakeHole obj = new UDPP2PMakeHole();
			obj.magic = magic;
			obj.request = request;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(magic);
			os.marshal(request);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			magic = os.unmarshal_int();
			request = os.unmarshal_sbyte();
			return os;
		}

	}
}
