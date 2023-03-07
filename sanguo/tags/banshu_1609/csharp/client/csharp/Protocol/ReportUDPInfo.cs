using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class ReportUDPInfo : Protocol
	{
		public const int PROTOCOL_TYPE = 106;
		public int net_type;	
		public Octets public_ip;	
		public ushort public_port;	
		public Octets local_ip;	
		public ushort local_port;	

		public ReportUDPInfo()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			net_type = 0;
			public_ip = new Octets();
			public_port = 0;
			local_ip = new Octets();
			local_port = 0;
		}

		public override Object Clone()
		{
			ReportUDPInfo obj = new ReportUDPInfo();
			obj.net_type = net_type;
			obj.public_ip = (Octets)public_ip.Clone();
			obj.public_port = public_port;
			obj.local_ip = (Octets)local_ip.Clone();
			obj.local_port = local_port;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(net_type);
			os.marshal(public_ip);
			os.marshal(public_port);
			os.marshal(local_ip);
			os.marshal(local_port);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			net_type = os.unmarshal_int();
			public_ip = os.unmarshal_Octets();
			public_port = os.unmarshal_ushort();
			local_ip = os.unmarshal_Octets();
			local_port = os.unmarshal_ushort();
			return os;
		}

	}
}
