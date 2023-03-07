using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPSyncNetTime : Protocol
	{
		public const int PROTOCOL_TYPE = 37;
		public long orignate_time;	
		public long offset;	
		public long delay;	

		public UDPSyncNetTime()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			orignate_time = 0;
			offset = 0;
			delay = 0;
		}

		public override Object Clone()
		{
			UDPSyncNetTime obj = new UDPSyncNetTime();
			obj.orignate_time = orignate_time;
			obj.offset = offset;
			obj.delay = delay;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(orignate_time);
			os.marshal(offset);
			os.marshal(delay);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			orignate_time = os.unmarshal_long();
			offset = os.unmarshal_long();
			delay = os.unmarshal_long();
			return os;
		}

	}
}
