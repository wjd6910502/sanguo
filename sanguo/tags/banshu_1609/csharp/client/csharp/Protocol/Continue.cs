using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class Continue : Protocol
	{
		public const int PROTOCOL_TYPE = 7;
		public sbyte reset;	

		public Continue()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			reset = 0;
		}

		public override Object Clone()
		{
			Continue obj = new Continue();
			obj.reset = reset;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(reset);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			reset = os.unmarshal_sbyte();
			return os;
		}

	}
}
