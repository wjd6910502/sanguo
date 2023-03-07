using System;
using GNET.IO;
using GNET.Common;
using GNET.Common.Security;

using GNET.Rpcdata;

namespace GNET
{
	/*

	*/
	public class GameProtocol : Protocol
	{
		public const int PROTOCOL_TYPE = 8;
		public Octets data;	
		public ushort client_send_time;	
		public ushort server_send_time;	
		public LongVector extra_roles;	
		public LongVector extra_mafias;	
		public IntVector extra_pvps;	
		public int reserved1;	
		public int reserved2;	

		public GameProtocol()
			: base(PROTOCOL_TYPE, 1024000, 0)
		{
			data = new Octets();
			client_send_time = 0;
			server_send_time = 0;
			extra_roles = new LongVector();
			extra_mafias = new LongVector();
			extra_pvps = new IntVector();
			reserved1 = 0;
			reserved2 = 0;
		}

		public override Object Clone()
		{
			GameProtocol obj = new GameProtocol();
			obj.data = (Octets)data.Clone();
			obj.client_send_time = client_send_time;
			obj.server_send_time = server_send_time;
			obj.extra_roles = (LongVector)extra_roles.Clone();
			obj.extra_mafias = (LongVector)extra_mafias.Clone();
			obj.extra_pvps = (IntVector)extra_pvps.Clone();
			obj.reserved1 = reserved1;
			obj.reserved2 = reserved2;
			return obj;
		}

		public override OctetsStream marshal(OctetsStream os)
		{
			os.marshal(data);
			os.marshal(client_send_time);
			os.marshal(server_send_time);
			os.marshal(extra_roles);
			os.marshal(extra_mafias);
			os.marshal(extra_pvps);
			os.marshal(reserved1);
			os.marshal(reserved2);
			return os;
		}

		public override OctetsStream unmarshal(OctetsStream os)
		{
			data = os.unmarshal_Octets();
			client_send_time = os.unmarshal_ushort();
			server_send_time = os.unmarshal_ushort();
			os.unmarshal(extra_roles);
			os.unmarshal(extra_mafias);
			os.unmarshal(extra_pvps);
			reserved1 = os.unmarshal_int();
			reserved2 = os.unmarshal_int();
			return os;
		}

	}
}
