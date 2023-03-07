using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class SyncNetime : Protocol
	{
		public const int PROTOCOL_TYPE = 14;
		public int id;	
		public long orignate_time;	
		public long offset;	
		public long delay;	
		public ushort client_send_time;	
		public ushort server_send_time;	

		public SyncNetime()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			id = 0;
			orignate_time = 0;
			offset = 0;
			delay = 0;
			client_send_time = 0;
			server_send_time = 0;
		}

		public override Object Clone()
		{
			SyncNetime obj = new SyncNetime();
			obj.id = id;
			obj.orignate_time = orignate_time;
			obj.offset = offset;
			obj.delay = delay;
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(id);
			os.marshal(orignate_time);
			os.marshal(offset);
			os.marshal(delay);
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			id = os.unmarshal_int();
			orignate_time = os.unmarshal_long();
			offset = os.unmarshal_long();
			delay = os.unmarshal_long();
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			return os;
		}

	}
}
