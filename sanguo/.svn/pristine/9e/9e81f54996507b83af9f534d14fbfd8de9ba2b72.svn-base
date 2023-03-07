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

		public UDPKeepAlive()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			id = 0;
		}

		public override Object Clone()
		{
			UDPKeepAlive obj = new UDPKeepAlive();
			obj.id = id;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(id);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			id = os.unmarshal_long();
			return os;
		}

	}
}
