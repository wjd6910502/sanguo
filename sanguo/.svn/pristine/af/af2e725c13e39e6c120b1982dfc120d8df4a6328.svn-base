using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class Challenge : Protocol
	{
		public const int PROTOCOL_TYPE = 1;
		public Octets server_rand1;	

		public Challenge()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			server_rand1 = new Octets();
		}

		public override Object Clone()
		{
			Challenge obj = new Challenge();
			obj.server_rand1 = (Octets)server_rand1.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(server_rand1);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			server_rand1 = os.unmarshal_Octets();
			return os;
		}

	}
}
