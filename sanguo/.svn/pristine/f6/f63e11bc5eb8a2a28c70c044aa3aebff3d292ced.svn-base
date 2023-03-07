using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPSyncNetTimeRe : Protocol
	{
		public const int PROTOCOL_TYPE = 38;
		public long id;	
		public long orignate_time;	
		public long receive_time;	
		public long transmit_time;	

		public UDPSyncNetTimeRe()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			id = 0;
			orignate_time = 0;
			receive_time = 0;
			transmit_time = 0;
		}

		public override Object Clone()
		{
			UDPSyncNetTimeRe obj = new UDPSyncNetTimeRe();
			obj.id = id;
			obj.orignate_time = orignate_time;
			obj.receive_time = receive_time;
			obj.transmit_time = transmit_time;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(id);
			os.marshal(orignate_time);
			os.marshal(receive_time);
			os.marshal(transmit_time);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			id = os.unmarshal_long();
			orignate_time = os.unmarshal_long();
			receive_time = os.unmarshal_long();
			transmit_time = os.unmarshal_long();
			return os;
		}

	}
}
