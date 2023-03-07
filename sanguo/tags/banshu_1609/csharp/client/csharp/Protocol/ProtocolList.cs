using System;
using GNET.IO;
using GNET.Common;

namespace GNET
{
	public class ProtocolList
	{
		public static System.Collections.IEnumerable RegisterProtocols()
		{
			Protocol.Register(TransResponse.PROTOCOL_TYPE, new TransResponse());				/* Protocol Type = 5 */
			Protocol.Register(ServerLog.PROTOCOL_TYPE, new ServerLog());				/* Protocol Type = 107 */
			Protocol.Register(UDPKeepAlive.PROTOCOL_TYPE, new UDPKeepAlive());				/* Protocol Type = 13 */
			Protocol.Register(SyncNetimeRe.PROTOCOL_TYPE, new SyncNetimeRe());				/* Protocol Type = 15 */
			Protocol.Register(AuthResult.PROTOCOL_TYPE, new AuthResult());				/* Protocol Type = 3 */
			Protocol.Register(KeepAlive.PROTOCOL_TYPE, new KeepAlive());				/* Protocol Type = 12 */
			Protocol.Register(UDPS2CGameProtocols.PROTOCOL_TYPE, new UDPS2CGameProtocols());				/* Protocol Type = 36 */
			Protocol.Register(SyncNetime.PROTOCOL_TYPE, new SyncNetime());				/* Protocol Type = 14 */
			Protocol.Register(UDPSTUNRequest.PROTOCOL_TYPE, new UDPSTUNRequest());				/* Protocol Type = 102 */
			Protocol.Register(UDPSTUNResponse.PROTOCOL_TYPE, new UDPSTUNResponse());				/* Protocol Type = 103 */
			yield return null;
			Protocol.Register(Response.PROTOCOL_TYPE, new Response());				/* Protocol Type = 2 */
			Protocol.Register(UDPC2SGameProtocols.PROTOCOL_TYPE, new UDPC2SGameProtocols());				/* Protocol Type = 35 */
			Protocol.Register(Challenge.PROTOCOL_TYPE, new Challenge());				/* Protocol Type = 1 */
			Protocol.Register(ReportUDPInfo.PROTOCOL_TYPE, new ReportUDPInfo());				/* Protocol Type = 106 */
			Protocol.Register(ServerStatus.PROTOCOL_TYPE, new ServerStatus());				/* Protocol Type = 10 */
			Protocol.Register(UDPP2PMakeHole.PROTOCOL_TYPE, new UDPP2PMakeHole());				/* Protocol Type = 105 */
			Protocol.Register(TransAuthResult.PROTOCOL_TYPE, new TransAuthResult());				/* Protocol Type = 6 */
			Protocol.Register(GameProtocol.PROTOCOL_TYPE, new GameProtocol());				/* Protocol Type = 8 */
			Protocol.Register(UDPGameProtocol.PROTOCOL_TYPE, new UDPGameProtocol());				/* Protocol Type = 11 */
			Protocol.Register(Kickout.PROTOCOL_TYPE, new Kickout());				/* Protocol Type = 9 */
			yield return null;
			Protocol.Register(Continue.PROTOCOL_TYPE, new Continue());				/* Protocol Type = 7 */
			Protocol.Register(TransChallenge.PROTOCOL_TYPE, new TransChallenge());				/* Protocol Type = 4 */
		}
	}
}
