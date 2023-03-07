using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPSTUNResponse : Protocol
	{
		public const int PROTOCOL_TYPE = 103;
		public int magic;	
		public Octets client_ip;	
		public ushort client_port;	

		public UDPSTUNResponse()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			magic = 0;
			client_ip = new Octets();
			client_port = 0;
		}

		public override Object Clone()
		{
			UDPSTUNResponse obj = new UDPSTUNResponse();
			obj.magic = magic;
			obj.client_ip = (Octets)client_ip.Clone();
			obj.client_port = client_port;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(magic);
			os.marshal(client_ip);
			os.marshal(client_port);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			magic = os.unmarshal_int();
			client_ip = os.unmarshal_Octets();
			client_port = os.unmarshal_ushort();
			return os;
		}

	}
}
