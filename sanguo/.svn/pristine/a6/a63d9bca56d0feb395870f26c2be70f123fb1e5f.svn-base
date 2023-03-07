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
		mday = 5
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
		if doCmd(sock, """<cmd_command cmd_data="AddServerReward" begin_time="%d" end_time="%d" mail_id="%d" level_min="%d" lifetime_min="%d"/>"""%(begin_time, end_time, mail_id, level_min, lifetime_min)):
			print "succeed"
			return 0
		else:
			return 1
	except:
		print "ERROR!"
		return 1

if __name__ == "__main__":
	sys.exit(main())

