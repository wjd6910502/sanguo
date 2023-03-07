#!/usr/bin/env python
#encoding=gbk

import sys, socket, struct, pdb
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
		sock = init()
		if doCmd(sock, """<cmd_command cmd_data="GetAccID" charid="844424931132003" charname=""/>"""):
			print "succeed"
			return 0
		else:
			return 1
	except:
		print "ERROR!"
		return 1

if __name__ == "__main__":
	sys.exit(main())

