using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class KeepAlive : Protocol
	{
		public const int PROTOCOL_TYPE = 12;
		public ushort client_send_time;	
		public ushort server_send_time;	
		public int server_received_count;	

		public KeepAlive()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			client_send_time = 0;
			server_send_time = 0;
			server_received_count = 0;
		}

		public override Object Clone()
		{
			KeepAlive obj = new KeepAlive();
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			obj.server_received_count = server_received_count;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			os.marshal(server_received_count);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			server_received_count = os.unmarshal_int();
			return os;
		}

	}
}
