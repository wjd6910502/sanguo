--获取对手玩家第N帧真实操作
function GetPeerOp(peer_tick, tick)
	--假设对手玩家的输入总会晚10tick到达, 即本地在第11帧时对手第1帧输入才会到达
	if tick-peer_tick<10 then return nil end
	--对手玩家操作: 仅[81,90]帧之间对手玩家有输入, 其他时间均空闲(0)
	peer_tick = peer_tick%100
	if peer_tick>80 and peer_tick<=90 then
		return 1
	else
		return 0
	end
end

--预测对手玩家第N帧操作
--最简单的预测算法: 对手玩家全程无输入(0), 之后当发现对手有输入即预测失败时需要Rollback, 否则Confirm
--TODO: 优化空间很大
function PredictPeerOp(peer_tick)
	--return 0
	return math.random(0,99)
end









local tbl = API_RBT_Create() --替代local tbl = {}

--游戏原Tick逻辑
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

local peer_tick_got = 0 --已经获得对手哪一帧的操作
local predict_results = {} --操作预测记录

function Tick(tick)
	assert(peer_tick_got<tick)

	local peer_op = GetPeerOp(peer_tick_got+1, tick)
	if peer_op==nil then
		--没有获得对手操作，本帧只能靠预测
		API_RBT_Next(false)
		peer_op = PredictPeerOp(tick)
		predict_results[tick] = peer_op
		ClientTick(tick, peer_op)
	else
		--拿到对手真实操作
		peer_tick_got = peer_tick_got+1
		if peer_tick_got==tick then
			--同一帧里拿到对手的操作，在正常网络环境下很难
			API_RBT_Next(true) --以确认操作的方式继续运行逻辑
			ClientTick(tick, peer_op)
		else
			--延迟拿到对手的操作
			if peer_op==predict_results[peer_tick_got] then
				--之前预测的对手操作是对的
				API_RBT_Confirm()
				Tick(tick) --再试试，看是否收到对手不止一个操作
			else
				--之前预测对手操作失败, 回滚并使用正确操作执行
				API_RBT_Rollback()
				API_RBT_Next(true)
				ClientTick(peer_tick_got, peer_op)
				--赶帧
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


