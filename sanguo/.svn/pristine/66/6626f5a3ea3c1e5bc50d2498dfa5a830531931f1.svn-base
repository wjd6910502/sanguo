using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPS2CGameProtocols : Protocol
	{
		public const int PROTOCOL_TYPE = 36;
		public int index;	
		public OctetsVector protocols;	
		public int index_ack;	
		public ushort client_send_time;	
		public ushort server_send_time;	
		public int signature;	
		public int reserved1;	
		public int reserved2;	

		public UDPS2CGameProtocols()
			: base(PROTOCOL_TYPE, 10240, 0)
		{
			index = 0;
			protocols = new OctetsVector();
			index_ack = 0;
			client_send_time = 0;
			server_send_time = 0;
			signature = 0;
			reserved1 = 0;
			reserved2 = 0;
		}

		public override Object Clone()
		{
			UDPS2CGameProtocols obj = new UDPS2CGameProtocols();
			obj.index = index;
			obj.protocols = (OctetsVector)protocols.Clone();
			obj.index_ack = index_ack;
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			obj.signature = signature;
			obj.reserved1 = reserved1;
			obj.reserved2 = reserved2;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(index);
			os.marshal(protocols);
			os.marshal(index_ack);
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			os.marshal(signature);
			os.marshal(reserved1);
			os.marshal(reserved2);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			index = os.unmarshal_int();
			os.unmarshal(protocols);
			index_ack = os.unmarshal_int();
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			signature = os.unmarshal_int();
			reserved1 = os.unmarshal_int();
			reserved2 = os.unmarshal_int();
			return os;
		}

	}
}
