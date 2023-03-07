using System;
using GNET.IO;
using GNET.Common;

namespace GNET
{
	public class GateClient : Manager
	{
		private Session session = null;

		private static readonly GateClient instance = new GateClient();
		public static GateClient GetInstance()
		{
			return instance;
		}

		public Session GetSession() { return session; }
		protected internal override void OnAddSession (Session session)
		{
			Console.WriteLine("GateClient::OnAddSession");
			this.session = session;
		}

		protected internal override void OnDelSession (Session session)
		{
			if(this.session != null)
				Console.WriteLine("GateClient::OnDelSession " + this.session.getPeerAddress ().ToString ());
			this.session = null;
			//reconnect
		}

		protected internal override void OnAbortSession (Session session)
		{
			if(this.session != null)
				Console.WriteLine("GateClient::OnAbortSession " + this.session.getPeerAddress ().ToString ());
			this.session = null;
			//reconnect
		}

		public override String Identification()
		{
			return "GateClient";
		}

		public bool SendProtocol(Protocol protocol) { return (session != null) && Send(session, protocol); }
		public override void OnRecvProtocol(Session session, Protocol protocol)
		{
			//TODO
		}

	}
}
