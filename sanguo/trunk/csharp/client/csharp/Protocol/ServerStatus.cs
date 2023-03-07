using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class ServerStatus : Protocol
	{
		public const int PROTOCOL_TYPE = 10;
		public Octets info;	

		public ServerStatus()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			info = new Octets();
		}

		public override Object Clone()
		{
			ServerStatus obj = new ServerStatus();
			obj.info = (Octets)info.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(info);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			info = os.unmarshal_Octets();
			return os;
		}

	}
}
