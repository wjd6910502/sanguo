--��ȡ������ҵ�N֡��ʵ����
function GetPeerOp(peer_tick, tick)
	--���������ҵ������ܻ���10tick����, �������ڵ�11֡ʱ���ֵ�1֡����Żᵽ��
	if tick-peer_tick<10 then return nil end
	--������Ҳ���: ��[81,90]֮֡��������������, ����ʱ�������(0)
	peer_tick = peer_tick%100
	if peer_tick>80 and peer_tick<=90 then
		return 1
	else
		return 0
	end
end

--Ԥ�������ҵ�N֡����
--��򵥵�Ԥ���㷨: �������ȫ��������(0), ֮�󵱷��ֶ��������뼴Ԥ��ʧ��ʱ��ҪRollback, ����Confirm
--TODO: �Ż��ռ�ܴ�
function PredictPeerOp(peer_tick)
	--return 0
	return math.random(0,99)
end









local tbl = API_RBT_Create() --���local tbl = {}

--��ϷԭTick�߼�
function ClientTick(tick, peer_op)
	--print("ClientTick", tick, peer_op)
	if tick<=500 then
		if tbl.ops==nil then
			tbl.ops = " "..peer_op
		else
			tbl.ops = tbl.ops.." "..peer_op
		end
	end
end

local peer_tick_got = 0 --�Ѿ���ö�����һ֡�Ĳ���
local predict_results = {} --����Ԥ���¼

function Tick(tick)
	assert(peer_tick_got<tick)

	local peer_op = GetPeerOp(peer_tick_got+1, tick)
	if peer_op==nil then
		--û�л�ö��ֲ�������ֻ֡�ܿ�Ԥ��
		API_RBT_Next(false)
		peer_op = PredictPeerOp(tick)
		predict_results[tick] = peer_op
		ClientTick(tick, peer_op)
	else
		--�õ�������ʵ����
		peer_tick_got = peer_tick_got+1
		if peer_tick_got==tick then
			--ͬһ֡���õ����ֵĲ��������������绷���º���
			API_RBT_Next(true) --��ȷ�ϲ����ķ�ʽ���������߼�
			ClientTick(tick, peer_op)
		else
			--�ӳ��õ����ֵĲ���
			if peer_op==predict_results[peer_tick_got] then
				--֮ǰԤ��Ķ��ֲ����ǶԵ�
				API_RBT_Confirm()
				Tick(tick) --�����ԣ����Ƿ��յ����ֲ�ֹһ������
			else
				--֮ǰԤ����ֲ���ʧ��, �ع���ʹ����ȷ����ִ��
				API_RBT_Rollback()
				API_RBT_Next(true)
				ClientTick(peer_tick_got, peer_op)
				--��֡
				for t=peer_tick_got+1,tick do
					Tick(t)
				end
			end
		end
	end
end

math.randomseed(API_GetTime())

for tick=1,1000 do
	Tick(tick)
end

print(tbl.ops)

