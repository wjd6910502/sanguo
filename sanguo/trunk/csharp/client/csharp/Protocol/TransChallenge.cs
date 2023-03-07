using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class TransChallenge : Protocol
	{
		public const int PROTOCOL_TYPE = 4;
		public Octets server_rand2;	

		public TransChallenge()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			server_rand2 = new Octets();
		}

		public override Object Clone()
		{
			TransChallenge obj = new TransChallenge();
			obj.server_rand2 = (Octets)server_rand2.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(server_rand2);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			server_rand2 = os.unmarshal_Octets();
			return os;
		}

	}
}
