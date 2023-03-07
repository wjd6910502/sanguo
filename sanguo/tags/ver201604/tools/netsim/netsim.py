#!/usr/bin/env python
#encoding=GBK

import random, time

FPS = 30 #֡��
LOST_TIME = 99999999
TEST_COUNT = 100









clients_in_losting = {}
clients_prev_rtt = {}
def GetRTT(index):
	global clients_in_losting, clients_prev_rtt

	if index==2:
		return 48

	#���������ɿ���
	if clients_in_losting.has_key(index) and clients_in_losting[index]>0:
		clients_in_losting[index] -= 1
		return LOST_TIME
	#��Ҫ������ĳ�������
	rtt = 90
	if clients_prev_rtt.has_key(index) and clients_prev_rtt[index]==LOST_TIME:
		clients_prev_rtt[index] = rtt
		return rtt
	#��������
	i = random.randint(0,99) #[lower,upper]
	if i<1: #odd==1%
		clients_in_losting[index] = 1 #������������״̬, ֮��������������
		rtt = LOST_TIME 
	clients_prev_rtt[index] = rtt
	return rtt 









now = 0 #ʱ��(ms)
clients_tick_max = {} #���ͻ����Ѳ��������tick
clients_tick_arrive_time = {} #�ͻ��˲��������������ʱ��

def CommitOP(index, tick, rtt):
	global now, clients_tick_max, clients_tick_arrive_time

	clients_tick_max[index] = tick

	if not clients_tick_arrive_time.has_key(index):
		clients_tick_arrive_time[index] = {}
	if not clients_tick_arrive_time[index].has_key(tick):
		clients_tick_arrive_time[index][tick] = now+rtt
	elif clients_tick_arrive_time[index][tick] > now+rtt:
		clients_tick_arrive_time[index][tick] = now+rtt

def ReadOPSet():
	global now, clients_tick_max, clients_tick_arrive_time

	if not clients_tick_max.has_key(1):
		return 0
	if not clients_tick_max.has_key(2):
		return 0

	tk = clients_tick_max[1]
	if tk>clients_tick_max[2]:
		tk = clients_tick_max[2]

	while tk>0:
		if clients_tick_arrive_time[1][tk]>now or clients_tick_arrive_time[2][tk]>now:
			tk -= 1
			continue
		return tk
	return 0

def clientRunTick(index, tick, opset_tick_max):
	global now, clients_tick_max, clients_tick_arrive_time

	opset_tick = ReadOPSet()
	if opset_tick>opset_tick_max:
		opset_tick_max = opset_tick

	rtt = GetRTT(index)
	#print "%d, RTT, %d" % (index, rtt)
	CommitOP(index, tick, rtt)

	#+1+1Ϊ������, ��ʱ�����������ӳ�1+1=2ִ֡��(���Ӱ��µ�ִ��), �����������1֡�ӳ�(����1֡�����ڿͻ����ڲ�����Ϣ�������), ��Ҫ��rtt����С��1֡, ���򼴿�
	if tick < opset_tick_max+1+5:
		tick += 1
	else:
		print "%d, Waiting, %d" % (index, tick)

	return (tick, opset_tick_max)

def main():
	global now, clients_tick_max, clients_tick_arrive_time

	random.seed(time.time())

	c1_tick = 1
	c1_opset_tick_max = 0
	c1_begin_time = 10*1000
	#c1_begin_time = 0
	c2_tick = 1
	c2_opset_tick_max = 0
	c2_begin_time = 0

	while True:
		now += 1000.0/FPS
		if now>TEST_COUNT*3*60*1000:
			break

		if now>c1_begin_time:
			(c1_tick,c1_opset_tick_max) = clientRunTick(1, c1_tick, c1_opset_tick_max)
		if now>c2_begin_time:
			(c2_tick,c2_opset_tick_max) = clientRunTick(2, c2_tick, c2_opset_tick_max)

if __name__ == "__main__":
	main()

