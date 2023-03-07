using System;
using GNET.IO;
using GNET.Common;

using GNET.Rpcdata;

namespace GNET.Rpcdata
{
	/*

	*/
	public class C2SGameProtocol : GNET.Common.MarshalData
	{
		public Octets data;	

		public C2SGameProtocol()
		{
			data = new Octets();
		}

		public override Object Clone()
		{
			C2SGameProtocol obj = new C2SGameProtocol();
			obj.data = (Octets)data.Clone();
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(data);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			data = os.unmarshal_Octets();
			return os;
		}

	}
}
