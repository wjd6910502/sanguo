using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class AuthResult : Protocol
	{
		public const int PROTOCOL_TYPE = 3;
		public int retcode;	
		public Octets trans_ip;	
		public ushort trans_port;	
		public Octets udp_trans_ip;	
		public ushort udp_trans_port;	
		public Octets stund_ip;	
		public ushort stund_port;	
		public Octets trans_token;	
		public int signature;	

		public AuthResult()
			: base(PROTOCOL_TYPE, 1024, 1)
		{
			retcode = 0;
			trans_ip = new Octets();
			trans_port = 0;
			udp_trans_ip = new Octets();
			udp_trans_port = 0;
			stund_ip = new Octets();
			stund_port = 0;
			trans_token = new Octets();
			signature = 0;
		}

		public override Object Clone()
		{
			AuthResult obj = new AuthResult();
			obj.retcode = retcode;
			obj.trans_ip = (Octets)trans_ip.Clone();
			obj.trans_port = trans_port;
			obj.udp_trans_ip = (Octets)udp_trans_ip.Clone();
			obj.udp_trans_port = udp_trans_port;
			obj.stund_ip = (Octets)stund_ip.Clone();
			obj.stund_port = stund_port;
			obj.trans_token = (Octets)trans_token.Clone();
			obj.signature = signature;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(retcode);
			os.marshal(trans_ip);
			os.marshal(trans_port);
			os.marshal(udp_trans_ip);
			os.marshal(udp_trans_port);
			os.marshal(stund_ip);
			os.marshal(stund_port);
			os.marshal(trans_token);
			os.marshal(signature);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			retcode = os.unmarshal_int();
			trans_ip = os.unmarshal_Octets();
			trans_port = os.unmarshal_ushort();
			udp_trans_ip = os.unmarshal_Octets();
			udp_trans_port = os.unmarshal_ushort();
			stund_ip = os.unmarshal_Octets();
			stund_port = os.unmarshal_ushort();
			trans_token = os.unmarshal_Octets();
			signature = os.unmarshal_int();
			return os;
		}

	}
}
