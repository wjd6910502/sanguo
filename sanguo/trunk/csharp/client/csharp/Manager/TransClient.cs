using System;
using GNET.IO;
using GNET.Common;

namespace GNET
{
	public class TransClient : Manager
	{
		private Session session = null;

		private static readonly TransClient instance = new TransClient();
		public static TransClient GetInstance()
		{
			return instance;
		}

		public Session GetSession() { return session; }
		protected internal override void OnAddSession (Session session)
		{
			Console.WriteLine("TransClient::OnAddSession");
			this.session = session;
		}

		protected internal override void OnDelSession (Session session)
		{
			if(this.session != null)
				Console.WriteLine("TransClient::OnDelSession " + this.session.getPeerAddress ().ToString ());
			this.session = null;
			//reconnect
		}

		protected internal override void OnAbortSession (Session session)
		{
			if(this.session != null)
				Console.WriteLine("TransClient::OnAbortSession " + this.session.getPeerAddress ().ToString ());
			this.session = null;
			//reconnect
		}

		public override String Identification()
		{
			return "TransClient";
		}

		public bool SendProtocol(Protocol protocol) { return (session != null) && Send(session, protocol); }
		public override void OnRecvProtocol(Session session, Protocol protocol)
		{
			//TODO
		}

	}
}
