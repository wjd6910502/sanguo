using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class Response : Protocol
	{
		public const int PROTOCOL_TYPE = 2;
		public Octets client_rand1_encoded;	
		public Octets account_encoded;	
		public Octets password_encoded;	

		public Response()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			client_rand1_encoded = new Octets();
			account_encoded = new Octets();
			password_encoded = new Octets();
		}

		public override Object Clone()
		{
			Response obj = new Response();
			obj.client_rand1_encoded = (Octets)client_rand1_encoded.Clone();
			obj.account_encoded = (Octets)account_encoded.Clone();
			obj.password_encoded = (Octets)password_encoded.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(client_rand1_encoded);
			os.marshal(account_encoded);
			os.marshal(password_encoded);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			client_rand1_encoded = os.unmarshal_Octets();
			account_encoded = os.unmarshal_Octets();
			password_encoded = os.unmarshal_Octets();
			return os;
		}

	}
}
