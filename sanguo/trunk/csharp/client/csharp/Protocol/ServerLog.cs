using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class ServerLog : Protocol
	{
		public const int PROTOCOL_TYPE = 107;
		public OctetsVector logs;	

		public ServerLog()
			: base(PROTOCOL_TYPE, 1024000, 1)
		{
			logs = new OctetsVector();
		}

		public override Object Clone()
		{
			ServerLog obj = new ServerLog();
			obj.logs = (OctetsVector)logs.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(logs);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			os.unmarshal(logs);
			return os;
		}

	}
}
