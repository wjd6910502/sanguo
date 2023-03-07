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
		public Octets client_id;	
		public Octets exe_ver;	
		public Octets res_ver;	

		public Response()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			client_rand1_encoded = new Octets();
			account_encoded = new Octets();
			password_encoded = new Octets();
			client_id = new Octets();
			exe_ver = new Octets();
			res_ver = new Octets();
		}

		public override Object Clone()
		{
			Response obj = new Response();
			obj.client_rand1_encoded = (Octets)client_rand1_encoded.Clone();
			obj.account_encoded = (Octets)account_encoded.Clone();
			obj.password_encoded = (Octets)password_encoded.Clone();
			obj.client_id = (Octets)client_id.Clone();
			obj.exe_ver = (Octets)exe_ver.Clone();
			obj.res_ver = (Octets)res_ver.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(client_rand1_encoded);
			os.marshal(account_encoded);
			os.marshal(password_encoded);
			os.marshal(client_id);
			os.marshal(exe_ver);
			os.marshal(res_ver);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			client_rand1_encoded = os.unmarshal_Octets();
			account_encoded = os.unmarshal_Octets();
			password_encoded = os.unmarshal_Octets();
			client_id = os.unmarshal_Octets();
			exe_ver = os.unmarshal_Octets();
			res_ver = os.unmarshal_Octets();
			return os;
		}

	}
}
