#!/usr/bin/env python
#encoding=gbk

import sys, socket, struct, pdb, time
from xml.dom import minidom

def init():
	#print "init:"
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.connect(("127.0.0.1", 8088))
	return sock

def parseResp(resp):
	print "parseResp:", resp
	try:
		#pdb.set_trace()
		xmldoc = minidom.parseString(resp)
		if xmldoc.firstChild.tagName == "cmd_command":
			attr = {}
			for (k,v) in xmldoc.firstChild.attributes.items():
				attr[k] = v
			if attr.has_key("return") and attr["return"].lower()=="true":
				return True
			return False
	except:
		return False

def doCmd(sock, xml):
	print "doCmd:", xml
	sock.send(struct.pack("!i", len(xml))) #网络字节序
	sock.send(xml)

	resp = ""
	while True:
		dat = sock.recv(4096)
		if not dat or dat=="":
			return False
		resp += dat
		if len(resp) < 4:
			continue
		(l,) = struct.unpack("!i", resp[:4]) #网络字节序
		if l > len(resp)-4:
			continue
		return parseResp(resp[4:])

def main():
	try:
		#开始生效时间
		year = 2017
		mon = 6
		mday = 9
		hour = 0
		min = 0
		#生效时长(小时)
		duration = 720
		#邮件id
		mail_id = 1001
		#其他限制
		level_min = 0
		lifetime_min = 0

		begin_time = time.mktime((year, mon, mday, hour, min, 0, 0, 0, 0))
		end_time = begin_time+duration*3600
		
		sock = init()

		data = [
			(6001,0),
			(6002,75600),
			(6003,118800),
			(6004,162000),
			(6005,205200),
			(6006,248400),
			(6007,291600),
			(6008,334800),
			(6009,378000),
			(6010,421200),
			(6011,464400),
			(6012,507600),
			(6013,550800),
			(6014,594000),
			(6015,637200),
			(6016,723600),
			(6017,810000),
		]

		for (mail_id,lifetime_min) in data:
			if doCmd(sock, """<cmd_command cmd_data="AddServerReward" begin_time="%d" end_time="%d" mail_id="%d" level_min="%d" lifetime_min="%d"/>"""%(begin_time, end_time, mail_id, level_min, lifetime_min)):
				print "succeed"
			else:
				print "failed"
				return 2
	except:
		print "ERROR!"
		return 1

if __name__ == "__main__":
	sys.exit(main())

