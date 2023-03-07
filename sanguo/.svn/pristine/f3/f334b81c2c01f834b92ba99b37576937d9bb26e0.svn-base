using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class UDPSTUNRequest : Protocol
	{
		public const int PROTOCOL_TYPE = 102;
		public int magic;	
		public sbyte change_ip;	
		public sbyte change_port;	

		public UDPSTUNRequest()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			magic = 0;
			change_ip = 0;
			change_port = 0;
		}

		public override Object Clone()
		{
			UDPSTUNRequest obj = new UDPSTUNRequest();
			obj.magic = magic;
			obj.change_ip = change_ip;
			obj.change_port = change_port;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(magic);
			os.marshal(change_ip);
			os.marshal(change_port);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			magic = os.unmarshal_int();
			change_ip = os.unmarshal_sbyte();
			change_port = os.unmarshal_sbyte();
			return os;
		}

	}
}
