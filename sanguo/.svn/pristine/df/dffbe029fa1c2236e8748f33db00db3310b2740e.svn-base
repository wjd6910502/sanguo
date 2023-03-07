using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPKeepAlive : Protocol
	{
		public const int PROTOCOL_TYPE = 13;
		public long id;	
		public ushort client_send_time;	
		public ushort server_send_time;	

		public UDPKeepAlive()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			id = 0;
			client_send_time = 0;
			server_send_time = 0;
		}

		public override Object Clone()
		{
			UDPKeepAlive obj = new UDPKeepAlive();
			obj.id = id;
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(id);
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			id = os.unmarshal_long();
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			return os;
		}

	}
}
