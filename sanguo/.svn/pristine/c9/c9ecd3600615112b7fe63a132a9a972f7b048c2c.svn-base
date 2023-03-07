using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPGameProtocol : Protocol
	{
		public const int PROTOCOL_TYPE = 11;
		public long id;	
		public Octets data;	
		public ushort client_send_time;	
		public ushort server_send_time;	
		public int signature;	
		public int reserved1;	
		public int reserved2;	

		public UDPGameProtocol()
			: base(PROTOCOL_TYPE, 10240, 0)
		{
			id = 0;
			data = new Octets();
			client_send_time = 0;
			server_send_time = 0;
			signature = 0;
			reserved1 = 0;
			reserved2 = 0;
		}

		public override Object Clone()
		{
			UDPGameProtocol obj = new UDPGameProtocol();
			obj.id = id;
			obj.data = (Octets)data.Clone();
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			obj.signature = signature;
			obj.reserved1 = reserved1;
			obj.reserved2 = reserved2;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(id);
			os.marshal(data);
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			os.marshal(signature);
			os.marshal(reserved1);
			os.marshal(reserved2);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			id = os.unmarshal_long();
			data = os.unmarshal_Octets();
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			signature = os.unmarshal_int();
			reserved1 = os.unmarshal_int();
			reserved2 = os.unmarshal_int();
			return os;
		}

	}
}
