using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class Kickout : Protocol
	{
		public const int PROTOCOL_TYPE = 9;
		public int reason;	

		public Kickout()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			reason = 0;
		}

		public override Object Clone()
		{
			Kickout obj = new Kickout();
			obj.reason = reason;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(reason);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			reason = os.unmarshal_int();
			return os;
		}

	}
}
