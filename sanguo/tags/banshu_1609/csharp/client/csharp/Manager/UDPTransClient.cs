using System;
using GNET.IO;
using GNET.Common;

namespace GNET
{
	public class UDPTransClient : Manager
	{
		private Session session = null;

		private static readonly UDPTransClient instance = new UDPTransClient();
		public static UDPTransClient GetInstance()
		{
			return instance;
		}

		public Session GetSession() { return session; }
		protected internal override void OnAddSession (Session session)
		{
			Console.WriteLine("UDPTransClient::OnAddSession");
			this.session = session;
		}

		protected internal override void OnDelSession (Session session)
		{
			if(this.session != null)
				Console.WriteLine("UDPTransClient::OnDelSession " + this.session.getPeerAddress ().ToString ());
			this.session = null;
			//reconnect
		}

		protected internal override void OnAbortSession (Session session)
		{
			if(this.session != null)
				Console.WriteLine("UDPTransClient::OnAbortSession " + this.session.getPeerAddress ().ToString ());
			this.session = null;
			//reconnect
		}

		public override String Identification()
		{
			return "UDPTransClient";
		}

		public bool SendProtocol(Protocol protocol) { return (session != null) && Send(session, protocol); }
		public override void OnRecvProtocol(Session session, Protocol protocol)
		{
			//TODO
		}

	}
}
