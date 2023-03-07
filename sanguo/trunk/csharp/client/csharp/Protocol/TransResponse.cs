using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class TransResponse : Protocol
	{
		public const int PROTOCOL_TYPE = 5;
		public Octets device_id;	
		public Octets trans_token;	
		public Octets client_rand2_encoded;	
		public int client_received_count;	
		public int signature;	

		public TransResponse()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			device_id = new Octets();
			trans_token = new Octets();
			client_rand2_encoded = new Octets();
			client_received_count = 0;
			signature = 0;
		}

		public override Object Clone()
		{
			TransResponse obj = new TransResponse();
			obj.device_id = (Octets)device_id.Clone();
			obj.trans_token = (Octets)trans_token.Clone();
			obj.client_rand2_encoded = (Octets)client_rand2_encoded.Clone();
			obj.client_received_count = client_received_count;
			obj.signature = signature;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(device_id);
			os.marshal(trans_token);
			os.marshal(client_rand2_encoded);
			os.marshal(client_received_count);
			os.marshal(signature);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			device_id = os.unmarshal_Octets();
			trans_token = os.unmarshal_Octets();
			client_rand2_encoded = os.unmarshal_Octets();
			client_received_count = os.unmarshal_int();
			signature = os.unmarshal_int();
			return os;
		}

	}
}
