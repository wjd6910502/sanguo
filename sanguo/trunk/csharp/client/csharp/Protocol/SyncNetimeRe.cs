using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class SyncNetimeRe : Protocol
	{
		public const int PROTOCOL_TYPE = 15;
		public int id;	
		public long orignate_time;	
		public long receive_time;	
		public long transmit_time;	
		public ushort client_send_time;	
		public ushort server_send_time;	

		public SyncNetimeRe()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			id = 0;
			orignate_time = 0;
			receive_time = 0;
			transmit_time = 0;
			client_send_time = 0;
			server_send_time = 0;
		}

		public override Object Clone()
		{
			SyncNetimeRe obj = new SyncNetimeRe();
			obj.id = id;
			obj.orignate_time = orignate_time;
			obj.receive_time = receive_time;
			obj.transmit_time = transmit_time;
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(id);
			os.marshal(orignate_time);
			os.marshal(receive_time);
			os.marshal(transmit_time);
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			id = os.unmarshal_int();
			orignate_time = os.unmarshal_long();
			receive_time = os.unmarshal_long();
			transmit_time = os.unmarshal_long();
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			return os;
		}

	}
}
