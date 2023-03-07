#!/usr/bin/python
# -*- coding: UTF-8 -*-
u"""rpcalls.xml Generator version 0.2

Generates rpcalls.xml

Usage: genrpc.py [options] [source]

Options:
	-h, --help					show this help
	-f ..., --file=...				use specified file other than default 'rpcalls.xml'
	-d, --debug					debug mode, output detailed information
	-v, --verbose					verbose mode, output warnings
	--toasclient					generate Action Script files at client/gnetnew, which is used for AS client
	--tocsharp					generate C# client files at client/csharp

Examples:
	rpcgen.py					generate rpcalls.xml
	rpcgen.py -f temp.xml				generate temp.xml
	rpcgen.py -f http://172.31.2.188/rpcalls.xml	generate rpcalls.xml on network
	
	rpcgen.py -f "<application namespace="GNET" project="SAINTNET"></application>"
							generate xml string

Author and Support:
	Programmed by yanfengbing @ FengNiao.
	Find me by 'yanfengbing' at RTX.
	Email: yanfengbing@wanmei.com
	2010/11/19

Check:
	 1. xml文件基本语法
	 2. xml文件是否满足rpcalls.xml的语法
	 3. 是否有重复的protocol、rpc、rpcdata、state、service
	 4. 每个service中的manager，state，protocol，rpc是否有重复
	 5. service中引用的state是否有定义
	 6. state和service中引用的rpc和protocol是否有定义
	 7. protocol和rpc的协议号是否有重复
	 8. protocol，rpc，rpcdata，state，manager，service的属性是否合法，是否漏掉了某个属性
	 9. protocol的字段一旦有default属性，那么这个字段之后的字段都必须要有default属性 
	10. rpcdata的字段一旦有default属性，那么这个字段之后的字段最好都要有default属性，这是一个警告，加上-v参数可以输出
	11. rpc最好定义argument和result属性，这是一个警告，加上-v参数可以输出
	12. protocol和rpcdata必须含有成员变量

Generate:
	 1. rpcdata和inl
	 2. protocol和rpc
	 3. 各个service
	 4. 各个state
	 5. 各个manager
	 6. 各个Makefile
"""

import sys

def openAnything(source):
	if hasattr(source, 'read'):
		return source
	if source =='-':
		return sys.stdin
	import urllib
	try:
		return urllib.urlopen(source)
	except (IOError, OSError):
		pass
	
	try:
		return open(source)
	except (IOError, OSError):
		pass
	
	import StringIO
	return StringIO.StringIO(str(source))

import os

#
INL_DIR = u'inl'
RPCDATA_DIR = u'rpcdata'
os.linesep = "\n"

def getAttrValue(node, attr): 
	if node.getAttribute and node.getAttribute(attr):
		return node.getAttribute(attr)
	else:
		return ""
class RpcException(Exception):
	def __init__(self, str):
		self.str = str
	def __str__(self):
		return self.str
class Variable:
	def __init__(self, name, type, default='', attr=''):
		self.name = name
		self.type = type
		self.default = default
		self.attr = attr
		self.comment = ''
	def hasDefault(self):
		if self.default == '':
			return False
		return True
	def hasAttr(self):
		if self.attr == '':
			return False
		return True
	def __str__(self):
		return self.type + " " + self.name + "=" + self.default

class RpcData:
	def __init__(self, name, attr='', bdbtable='', key=''):
		self.name = name
		self.vars = []
		self.attr = attr
		self.bdbtable = bdbtable
		self.key = key
		self.comment = ''
	def addVariable(self, var):
		for tmpv in self.vars:
			if tmpv.name == var.name:
				raise RpcException("Rpcdata " + self.name + " has duplicated variable '" + var.name + "'") 
		self.vars.append(var)
	def addComment(self, var):
		if len(self.comment) == 0:
			self.comment = u'\t' + var
		else:
			self.comment += os.linesep + u'\t' + var
	def hasAttr(self):
		if self.attr == '':
			return False
		return True
	def __str__(self):
		return self.name + " " + self.attr + " " + self.bdbtable + " " + self.key
	def getRpcDatas(self, rpcdatas):
		re = []
		for var in self.vars:
			if var.type != "RpcRetcode":
				if var.type in rpcdatas.keys():
					re.append(var.type)
				elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
					re.append(var.type[0:var.type.find("Vector")])
				elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
					re.append(var.type[var.type.find("std::vector<") + 12:var.type.find(">")])
		return re
	def toAS(self, project, rpcdatas):
		#str  = os.linesep
		str  = 'package ' + project + '.net.gnet.beans {' + os.linesep
		str += os.linesep
		#import 
		for var in self.vars:
			if var.type != "RpcRetcode":
				if var.type in rpcdatas.keys():
					str += u'import ' + project + '.net.gnet.beans.' + var.type + ';' + os.linesep
				elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
					str += u'import ' + project + '.net.gnet.beans.' + var.type[0:var.type.find("Vector")] + u';' + os.linesep
				elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
					str += u'import ' + project + '.net.gnet.beans.' + var.type[var.type.find("std::vector<") + 12:var.type.find(">")] + u';' + os.linesep
		str += os.linesep
		str += 'import com.wanmei.marshal.Bean;' + os.linesep
		str += 'import com.wanmei.marshal.Stream;' + os.linesep
		str += 'import com.wanmei.types.*;' + os.linesep
		str += os.linesep
		str += 'public class ' + self.name + ' extends com.wanmei.marshal.Bean {' + os.linesep
		#comment
		str += u"\t/*" + os.linesep
		str += self.comment + os.linesep
		str += u"\t*/" + os.linesep
		#variables
		for var in self.vars:
			str += '\t' + 'public var ' + var.name + ' : '
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
				str += 'int;'
			elif var.type in ('double', 'float'):
				str += 'Number;'
			elif var.type == 'int64_t':
				str += 'com.wanmei.types.Int64;'
			elif var.type == 'uint64_t':
				str += 'com.wanmei.types.UInt64;'
			elif var.type == 'Octets':
				str += 'com.wanmei.types.Octets;'
			elif var.type in rpcdatas.keys():
				str += project + '.net.gnet.beans.' + var.type + ';'
			elif var.type == 'ByteVector':
				str += 'Vector.<int>;'
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'Vector.<' + project + '.net.gnet.beans.' + var.type[0:var.type.find("Vector")] + u'>;'
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'Vector.<' + project + '.net.gnet.beans.' + vartype + u'>;'
				elif vartype in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
					str += 'Vector.<int>;'
				elif vartype in ('double', 'float'):
					str += 'Vector.<Number>;'
				elif vartype == 'int64_t':
					str += 'Vector.<com.wanmei.types.Int64>;'
				elif vartype == 'uint64_t':
					str += 'Vector.<com.wanmei.types.UInt64>;'
				elif vartype == 'Octets':
					str += 'Vector.<com.wanmei.types.Octets>;'
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
			if len(var.comment) != 0:
				str += u"\t/* " + var.comment + " */" + os.linesep;
			else:
				str += os.linesep
		str += os.linesep
		#constructor
		str += "\tpublic function " + self.name + "() {" + os.linesep
		for var in self.vars:
			str += "\t\t" + var.name + " = "
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
				str += '0;' + os.linesep
			elif var.type in ('double', 'float'):
				str += 'new Number();' + os.linesep
			elif var.type == 'int64_t':
				str += 'new com.wanmei.types.Int64();' + os.linesep
			elif var.type == 'uint64_t':
				str += 'new com.wanmei.types.UInt64();' + os.linesep
			elif var.type == 'Octets':
				str += 'new com.wanmei.types.Octets();' + os.linesep
			elif var.type in rpcdatas.keys():
				str += 'new ' + project + '.net.gnet.beans.' + var.type + '();' + os.linesep
			elif var.type == 'ByteVector':
				str += 'new Vector.<int>;' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'new Vector.<' + project + '.net.gnet.beans.' + var.type[0:var.type.find("Vector")] + u'>();' + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'new Vector.<' + project + '.net.gnet.beans.' + vartype + u'>();' + os.linesep
				elif vartype in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
					str += 'new Vector.<int>();' + os.linesep
				elif vartype in ('double', 'float'):
					str += 'new Vector.<Number>();' + os.linesep
				elif vartype == 'int64_t':
					str += 'new Vector.<com.wanmei.types.Int64>();' + os.linesep
				elif vartype == 'uint64_t':
					str += 'new Vector.<com.wanmei.types.UInt64>();' + os.linesep
				elif vartype == 'Octets':
					str += 'new Vector.<com.wanmei.types.Octets>();' + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t}" + os.linesep + os.linesep
		#marshal
		str += "\tpublic override function marshal(_os_ : Stream) : Stream {" + os.linesep
		str += "\t\tvar i:int = 0;" + os.linesep
		for var in self.vars:
			if var.type in ('unsigned char', 'char'):
				str += "\t\t" + "_os_.marshal" + 'Int8(' + var.name + ");" + os.linesep
			elif var.type in ('unsigned short', 'short'):
				str += "\t\t" + "_os_.marshal" + 'Int16(' + var.name + ");" + os.linesep
			elif var.type in ('unsigned int', 'int', 'unsigned long', 'long'):
				str += "\t\t" + "_os_.marshal" + 'Int32(' + var.name + ");" + os.linesep
			elif var.type == 'double':
				str += "\t\t" + "_os_.marshal" + 'Double(' + var.name + ");" + os.linesep
			elif var.type == 'float':
				str += "\t\t" + "_os_.marshal" + 'Float(' + var.name + ");" + os.linesep
			elif var.type == 'int64_t':
				str += "\t\t" + "_os_.marshal" + 'Int64(' + var.name + ");" + os.linesep
			elif var.type == 'uint64_t':
				str += "\t\t" + "_os_.marshal" + 'UInt64(' + var.name + ");" + os.linesep
			elif var.type == 'Octets':
				str += "\t\t" + "_os_.marshal" + 'Octets(' + var.name + ");" + os.linesep
			elif var.type in rpcdatas.keys():
				str += "\t\t" + "_os_.marshal" + '(' + var.name + ');' + os.linesep
			elif var.type == 'ByteVector':
				str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t" + "\t\t" + "_os_.marshalInt8" + '(' + var.name +'[i]);' + os.linesep
				str += "\t\t}" + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t" + "\t\t" + "_os_.marshal" + '(' + var.name +'[i]);' + os.linesep
				str += "\t\t}" + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshal" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned char', 'char'):
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt8" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned short', 'short'):
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt16" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned int', 'int', 'unsigned long', 'long'):
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt32" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'double':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalDouble" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'float':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalFloat" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'int64_t':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt64" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'uint64_t':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalUInt64" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'Octets':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalOctets" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\treturn _os_;" + os.linesep
		str += "\t}" + os.linesep + os.linesep
		#unmarshal
		str += "\tpublic override function unmarshal(_os_ : Stream) : Stream {" + os.linesep
		v = 0
		str += "\t\tvar i:int = 0;" + os.linesep
		for var in self.vars:
			v += 1
			if var.type == 'char':
				str += "\t\t" + var.name + " = _os_.unmarshalInt8();" + os.linesep
			elif var.type == 'unsigned char':
				str += "\t\t" + var.name + " = _os_.unmarshalUInt8();" + os.linesep
			elif var.type == 'short':
				str += "\t\t" + var.name + " = _os_.unmarshalInt16();" + os.linesep
			elif var.type == 'unsigned short':
				str += "\t\t" + var.name + " = _os_.unmarshalUInt16();" + os.linesep
			elif var.type in ('int', 'long'):
				str += "\t\t" + var.name + " = _os_.unmarshalInt32();" + os.linesep
			elif var.type in ('unsigned int', 'unsigned long'):
				str += "\t\t" + var.name + " = _os_.unmarshalUInt32();" + os.linesep
			elif var.type == 'double':
				str += "\t\t" + var.name + " = _os_.unmarshalDouble();" + os.linesep
			elif var.type == 'float':
				str += "\t\t" + var.name + " = _os_.unmarshalFloat();" + os.linesep
			elif var.type == 'int64_t':
				str += "\t\t" + "_os_.unmarshalInt64(" + var.name + ");" + os.linesep
			elif var.type == 'uint64_t':
				str += "\t\t" + "_os_.unmarshalUInt64(" + var.name + ");" + os.linesep
			elif var.type == 'Octets':
				str += "\t\t" + "_os_.unmarshalOctets(" + var.name + ");" + os.linesep
			elif var.type in rpcdatas.keys():
				str += "\t\t" + "_os_.unmarshal" + '(' + var.name + ');' + os.linesep
			elif var.type == 'ByteVector':
				str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t\t\t" + "var v" + "%d" % v + ":int = new int;" + os.linesep
				str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt8" + '();' + os.linesep
				str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
				str += "\t\t}" + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t\t\t" + "var v" + "%d" % v + ":" + var.type[0:var.type.find("Vector")] + " = new " + var.type[0:var.type.find("Vector")] + "();" + os.linesep
				str += "\t" + "\t\t" + "_os_.unmarshal" + '(v' + "%d" % v + ');' + os.linesep
				str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
				str += "\t\t}" + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":"+ vartype + " = new " + vartype + "();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshal(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'char':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt8" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'unsigned char':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalUInt8" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'unsigned short':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalUInt16" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + "" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in 'short':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt16" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned int', 'unsigned long'):
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalUInt32" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('int', 'long'):
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt32" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'double':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Number = new Number();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalDouble();" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'float':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Number = new Number();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalFloat();" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'int64_t':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Int64 = new Int64();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshalInt64(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'uint64_t':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":UInt64 = new UInt64();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshalUInt64(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'Octets':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Octets = new Octets();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshalOctets(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\treturn _os_;" + os.linesep
		str += "\t}" + os.linesep + os.linesep
		str += "}" + os.linesep
		str += "}" + os.linesep

		return str
	def toCPP(self, namespace, rpcdatas):
		str  = u'#ifndef __' + namespace.upper() + u'_' + self.name.upper() + u'_RPCDATA' + os.linesep
		str += u'#define __' + namespace.upper() + u'_' + self.name.upper() + u'_RPCDATA' + os.linesep
		str += os.linesep
		str += u'#include "rpcdefs.h"' + os.linesep
		str += os.linesep
		for var in self.vars:
			if var.type != "RpcRetcode":
				if var.type in rpcdatas.keys():
					str += u'#include "' + var.type.lower() + u'"' + os.linesep
				elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
					str += u'#include "' + var.type[0:var.type.find("Vector")].lower() + u'"' + os.linesep
				elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
					str += u'#include "' + var.type[var.type.find("std::vector<") + 12:var.type.find(">")].lower() + u'"' + os.linesep
		str += os.linesep
		str += u"namespace " + namespace.upper() + os.linesep
		str += u"{" + os.linesep
		str += u"\tclass " + self.name + u" : public GNET::Rpc::Data" + os.linesep
		str += u"\t{" + os.linesep
		#comment
		str += u"\t/*" + os.linesep
		str += self.comment + os.linesep
		str += u"\t*/" + os.linesep
		#class variable
		str += u"\tpublic:" + os.linesep
		for var in self.vars:
			str += u"\t\t" + var.type + u" " + var.name + u";";
			if len(var.comment) != 0:
				str += u"\t/* " + var.comment + " */" + os.linesep;
			else:
				str += os.linesep
		str += u"\tpublic:" + os.linesep
		#class constructor
		str += u"\t\t" + self.name + u"("
		incsrt = False
		for var in self.vars:
			if var.hasDefault():
				str += var.type + u" l_" + var.name + u" = " + var.default + u", "
				incsrt = True
		if incsrt:
			str = str[0:-2]
			str += u"): " + os.linesep + u"\t\t"
			for var in self.vars:
				if var.hasDefault():
					str += var.name + u"(l_" + var.name + u"), "
			str = str[0:-2]
			str += u"{ }" + os.linesep
		else:
			str += u") { }" + os.linesep
		#class copy constructor
		str += u"\t\t" + self.name + u"(const " + self.name + "& rhs)"
		if len(self.vars) > 0:
			str += u":" + os.linesep + u"\t\t"
			for var in self.vars:
				str += var.name + u"(rhs." + var.name + u"), "
			str = str[0:-2]
			str += u"{ }" + os.linesep
		else:
			str += u"{ }" + os.linesep
		#class clone
		str += u"\t\tRpc::Data *Clone() const { return new " + self.name + u"(*this); }" + os.linesep
		#class operator =
		str += u"\t\tRpc::Data& operator = (const Rpc::Data& rhs)" + os.linesep
		str += u"\t\t{" + os.linesep
		str += u"\t\t\tconst " + self.name + u"* r = dynamic_cast<const " + self.name + u"* >(&rhs);" + os.linesep
		str += u"\t\t\tif (r && r != this)" + os.linesep
		str += u"\t\t\t{" + os.linesep
		for var in self.vars:
			str += u"\t\t\t\t" + var.name + u" = r->" + var.name + u";" + os.linesep
		str += u"\t\t\t}" + os.linesep
		str += u"\t\t\treturn *this;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class operator = 
		str += u"\t\t" + self.name + "& operator = (const " + self.name + "& rhs)" + os.linesep
		str += u"\t\t{" + os.linesep
		str += u"\t\t\tconst " + self.name + u"* r = &rhs;" + os.linesep
		str += u"\t\t\tif (r && r != this)" + os.linesep
		str += u"\t\t\t{" + os.linesep
		for var in self.vars:
			str += u"\t\t\t\t" + var.name + u" = r->" + var.name + u";" + os.linesep
		str += u"\t\t\t}" + os.linesep
		str += u"\t\t\treturn *this;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class marshal
		str += u"\t\tOctetsStream& marshal(OctetsStream & os) const" + os.linesep
		str += u"\t\t{" + os.linesep
		for var in self.vars:
			str += u"\t\t\tos << " + var.name + u";" + os.linesep
		str += u"\t\t\treturn os;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class unmarshal
		str += u"\t\tconst OctetsStream& unmarshal(const OctetsStream & os)" + os.linesep
		str += u"\t\t{" + os.linesep
		for var in self.vars:
			str += u"\t\t\tos >> " + var.name + u";" + os.linesep
		str += u"\t\t\treturn os;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class marshal2
		str += u"\t\tOctetsStream& marshal2(OctetsStream & os) const" + os.linesep
		str += u"\t\t{" + os.linesep
		str += u"\t\t\tos << CompactUINT(%d);" % len(self.vars) + os.linesep
		for var in self.vars:
			str += u"\t\t\tos <<= " + var.name + u";" + os.linesep
		str += u"\t\t\treturn os;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class unmarshal2
		str += u"\t\tconst OctetsStream& unmarshal2(const OctetsStream & os)" + os.linesep
		str += u"\t\t{" + os.linesep
		str += u"\t\t\tunsigned int _xx_num_xx_;" + os.linesep
		str += u"\t\t\tos >> CompactUINT(_xx_num_xx_);" + os.linesep
		for var in self.vars:
			str += u"\t\t\tif(_xx_num_xx_-- == 0) return os;" + os.linesep
			str += u"\t\t\tos >>= " + var.name + u";" + os.linesep
		str += u"\t\t\treturn os;" + os.linesep
		str += u"\t\t}" + os.linesep
		str += u"\t};" + os.linesep
		if self.attr == 'vector':
			str += u"\ttypedef GNET::RpcDataVector<" + self.name + "> " + self.name + "Vector;" + os.linesep
		str += u"};" + os.linesep
		str += u"#endif" + os.linesep
		return str
	def toCSharp(self, namespace, rpcdatas):
		linesep = os.linesep
		os.linesep = "\r\n"
		str  = u'using System;' + os.linesep
		str += u'using GNET.IO;' + os.linesep
		str += u'using GNET.Common;' + os.linesep
		str += os.linesep 
		#using
		#for var in self.vars:
		#	if var.type != "RpcRetcode":
		#		if var.type in rpcdatas.keys():
		#			str += u'using GNET.Rpcdata.' + var.type + ";" + os.linesep
		#		elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
		#			str += u'using GNET.Rpcdata.' + var.type[0:var.type.find("Vector")] + ";" + os.linesep
		#		elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
		#			str += u'using GNET.Rpcdata.' + var.type[var.type.find("std::vector<") + 12:var.type.find(">")] + ";" + os.linesep
		str += "using GNET.Rpcdata;" + os.linesep
		str += os.linesep
		#class
		str += u'namespace GNET.Rpcdata' + os.linesep
		str += u'{' + os.linesep
		#comment
		str += u"\t/*" + os.linesep
		str += self.comment + os.linesep
		str += u"\t*/" + os.linesep
		#variables
		str += u'\tpublic class ' + self.name + ' : GNET.Common.MarshalData' + os.linesep
		str += u'\t{' + os.linesep
		for var in self.vars:
			str += '\t\t' + 'public '
			if var.type == 'unsigned char':
				str += 'byte '
			elif var.type == 'char':
				str += 'sbyte '
			elif var.type == 'short':
				str += 'short '
			elif var.type == 'unsigned short':
				str += 'ushort '
			elif var.type == 'int':
				str += 'int '
			elif var.type == 'unsigned int':
				str += 'uint '
			elif var.type == 'int64_t':
				str += 'long '
			elif var.type in ('float', 'double'):
				str += var.type + ' '
			elif var.type == 'Octets':
				str += 'Octets '
			elif var.type in rpcdatas.keys():
				str += var.type + ' '
			elif var.type == 'ByteVector':
				str += 'ByteVector '
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'RpcDataVector<' + var.type[0:var.type.find("Vector")] + u'> '
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'RpcDataVector<' + vartype + u'> '
				elif vartype in ('unsigned char', 'char'):
					str += 'ByteVector '
				elif vartype in ('unsigned short', 'short'):
					str += 'ShortVector '
				elif vartype in ('unsigned int', 'int'):
					str += 'IntVector '
				elif vartype == 'int64_t':
					str += 'LongVector '
				elif vartype == 'Octets':
					str += 'OctetsVector '
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
			str += var.name + ';\t' 
			if len(var.comment) != 0:
				str += u"\t/* " + var.comment + " */" + os.linesep
			else: str += os.linesep;
		str += os.linesep
		#constructor
		str += "\t\tpublic " + self.name + "()" + os.linesep
		str += "\t\t{" + os.linesep
		for var in self.vars:
			str += "\t\t\t" + var.name + " = "
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'int64_t', 'float', 'double'):
				str += '0;' + os.linesep
			elif var.type == 'Octets':
				str += 'new Octets();' + os.linesep
			elif var.type in rpcdatas.keys():
				str += 'new ' + var.type + '();' + os.linesep
			elif var.type == 'ByteVector':
				str += 'new ByteVector();' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'new RpcDataVector<' + var.type[0:var.type.find("Vector")] + u'>();' + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'new RpcDataVector<' + vartype + u'>();' + os.linesep
				elif vartype in ('unsigned char', 'char'):
					str += 'new ByteVector();' + os.linesep
				elif vartype in ('unsigned short', 'short'):
					str += 'new ShortVector();' + os.linesep
				elif vartype in ('unsigned int', 'int'):
					str += 'new IntVector();' + os.linesep
				elif vartype == 'int64_t':
					str += 'new LongVector();' + os.linesep
				elif vartype == 'Octets':
					str += 'new OctetsVector();' + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\t}" + os.linesep + os.linesep
		#Clone
		str += "\t\tpublic override Object Clone()" + os.linesep
		str += "\t\t{" + os.linesep
		str += "\t\t\t" + self.name + " obj = new " + self.name + "();" + os.linesep
		for var in self.vars:
			str += "\t\t\tobj." + var.name + " = "
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'int64_t', 'float', 'double'):
				str += var.name + ";" + os.linesep
			elif var.type == 'Octets':
				str += '(Octets)' + var.name + '.Clone();' + os.linesep
			elif var.type in rpcdatas.keys():
				str += '(' + var.type + ')' + var.name + '.Clone();' + os.linesep
			elif var.type == 'ByteVector':
				str += '(ByteVector)' + var.name + '.Clone();' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += '(RpcDataVector<' + var.type[0:var.type.find("Vector")] + u'>)' + var.name + '.Clone();' + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += '(RpcDataVector<' + vartype + u'>)' + var.name + '.Clone();' + os.linesep
				elif vartype in ('unsigned char', 'char'):
					str += '(ByteVector)' + var.name + '.Clone();' + os.linesep
				elif vartype in ('unsigned short', 'short'):
					str += '(ShortVector)' + var.name + '.Clone();' + os.linesep
				elif vartype in ('unsigned int', 'int'):
					str += '(IntVector)' + var.name + '.Clone();' + os.linesep
				elif vartype == 'int64_t':
					str += '(LongVector)' + var.name + '.Clone();' + os.linesep
				elif vartype == 'Octets':
					str += '(OctetsVector)' + var.name + '.Clone();' + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\t\treturn obj;" + os.linesep
		str += "\t\t}" + os.linesep + os.linesep
		#marshal
		str += "\t\tpublic override OctetsStream marshal(OctetsStream os)" + os.linesep
		str += "\t\t{" + os.linesep
		for var in self.vars:
			str += "\t\t\tos.marshal(" + var.name + ");" + os.linesep;
		str += "\t\t\treturn os;" + os.linesep
		str += "\t\t}" + os.linesep + os.linesep
		#unmarshal
		str += "\t\tpublic override OctetsStream unmarshal(OctetsStream os)" + os.linesep
		str += "\t\t{" + os.linesep
		for var in self.vars:
			if var.type == 'char':
				str += "\t\t\t" + var.name + " = os.unmarshal_sbyte();" + os.linesep
			elif var.type == 'unsigned char':
				str += "\t\t\t" + var.name + " = os.unmarshal_byte();" + os.linesep
			elif var.type == 'short':
				str += "\t\t\t" + var.name + " = os.unmarshal_short();" + os.linesep
			elif var.type == 'unsigned short':
				str += "\t\t\t" + var.name + " = os.unmarshal_ushort();" + os.linesep
			elif var.type == 'int':
				str += "\t\t\t" + var.name + " = os.unmarshal_int();" + os.linesep
			elif var.type == 'unsigned int':
				str += "\t\t\t" + var.name + " = os.unmarshal_uint();" + os.linesep
			elif var.type == 'int64_t':
				str += "\t\t\t" + var.name + " = os.unmarshal_long();" + os.linesep
			elif var.type == 'double':
				str += "\t\t\t" + var.name + " = os.unmarshal_double();" + os.linesep
			elif var.type == 'float':
				str += "\t\t\t" + var.name + " = os.unmarshal_float();" + os.linesep
			elif var.type == 'Octets':
				str += "\t\t\t" + var.name + " = os.unmarshal_Octets();" + os.linesep
			elif var.type in rpcdatas.keys():
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
			elif var.type == 'ByteVector':
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
			else:
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
		str += "\t\t\treturn os;" + os.linesep
		str += "\t\t}" + os.linesep + os.linesep
		str += "\t}" + os.linesep
		str += "}" + os.linesep
		os.linesep = linesep
		return str
	
class Protocol:
	def __init__(self, name, type, maxsize, prior='1', debug=0):
		self.name = name
		self.type = type
		self.maxsize = maxsize
		self.prior = prior
		self.debug = debug
		self.vars = []
		self.comment = ''
	def addVariable(self, var):
		for tmpv in self.vars:
			if tmpv.name == var.name:
				raise RpcException("Protocol " + self.name + " has duplicated variable '" + var.name + "'") 
		self.vars.append(var)
	def addComment(self, var):
		if len(self.comment) == 0:
			self.comment = u'\t' + var
		else:
			self.comment += os.linesep + u'\t' + var
	def __str__(self):
		return self.name + " " + self.type + " " + self.maxsize + " " + self.prior
	def getRpcDatas(self, rpcdatas):
		re = []
		for var in self.vars:
			if var.type != "RpcRetcode":
				if var.type in rpcdatas.keys():
					re.append(var.type)
				elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
					re.append(var.type[0:var.type.find("Vector")])
				elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
					re.append(var.type[var.type.find("std::vector<") + 12:var.type.find(">")])
		return re
	def toInl(self):
		#class variable
		str  = u"\tpublic:" + os.linesep
		for var in self.vars:
			str += u"\t\t" + var.type + u" " + var.name + u";"
			if len(var.comment) != 0:
				str += u"\t/* " + var.comment + " */" + os.linesep
			else:
				str += os.linesep
		str += u"\t\tenum { PROTOCOL_TYPE = PROTOCOL_" + self.name.upper() + u" };" + os.linesep
		str += u"\tpublic:" + os.linesep
		#class constructor
		str += u"\t\t" + self.name + u"() { type = PROTOCOL_" + self.name.upper() + u"; }" + os.linesep
		str += u"\t\t" + self.name + u"(void*): Protocol(PROTOCOL_" + self.name.upper() + u", \"" + self.name + "\") { }" + os.linesep
		if len(self.vars) > 0:
			str += u"\t\t" + self.name + u"("
			for var in self.vars:
				if var.attr == 'ref':
					str += u"const " + var.type + u"& l_" + var.name
				else:
					str += var.type + u" l_" + var.name
				if var.hasDefault():
					str += u" = " + var.default
				str += u", "
			str = str[0:-2]
			str += u"): " + os.linesep + u"\t\t"
			for var in self.vars:
				str += var.name + u"(l_" + var.name + u"), "
			str = str[0:-2]
			str += u" { type = PROTOCOL_" + self.name.upper() + u"; }" + os.linesep
		#class copy constructor
		str += u"\t\t" + self.name + u"(const " + self.name + "& rhs)"
		str += u": Protocol(rhs)"
		if len(self.vars) > 0:
			str += u", " + os.linesep + u"\t\t"
			for var in self.vars:
				str += var.name + u"(rhs." + var.name + u"), "
			str = str[0:-2]
			str += u" { }" + os.linesep
		else:
			str += u" { }" + os.linesep
		#class clone
		str += u"\t\tGNET::Protocol *Clone() const { return new " + self.name + u"(*this); }" + os.linesep
		#class marshal
		str += u"\t\tOctetsStream& marshal(OctetsStream & os) const" + os.linesep
		str += u"\t\t{" + os.linesep
		for var in self.vars:
			str += u"\t\t\tos << " + var.name + u";" + os.linesep
		str += u"\t\t\treturn os;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class unmarshal
		str += u"\t\tconst OctetsStream& unmarshal(const OctetsStream & os)" + os.linesep
		str += u"\t\t{" + os.linesep
		for var in self.vars:
			str += u"\t\t\tos >> " + var.name + u";" + os.linesep
		str += u"\t\t\treturn os;" + os.linesep
		str += u"\t\t}" + os.linesep
		#class PriorPolicy
		str += u"\t\tint PriorPolicy() const { return " + self.prior + u"; }" + os.linesep
		#class SizePolicy
		str += u"\t\tbool SizePolicy(size_t size) const { return size <= " + self.maxsize + u"; }" + os.linesep
		return str
	def toHpp(self, namespace, service, rpcdatas):
		str  = u'#ifndef __' + namespace.upper() + u'_' + self.name.upper() + u'_HPP' + os.linesep
		str += u'#define __' + namespace.upper() + u'_' + self.name.upper() + u'_HPP' + os.linesep
		str += os.linesep
		str += u'#include "rpcdefs.h"' + os.linesep
		str += u'#include "callid.hxx"' + os.linesep
		str += u'#include "state.hxx"' + os.linesep
		str += os.linesep
		if self.forwards:
			if service.name.lower().find("link") >= 0:
				str += u'#include "glinkserver.hpp"' + os.linesep
				str += u'#include "gdeliveryclient.hpp"' + os.linesep
				str += u'#include "gproviderserver.hpp"' + os.linesep
			elif service.name.lower().find("delivery") >= 0:
				str += u'#include "gdeliveryserver.hpp"' + os.linesep
				str += u'#include "gproviderserver.hpp"' + os.linesep
			elif service.name.lower().find("gamed") >= 0:
				str += u'#include "gproviderclient.hpp"' + os.linesep

		str += os.linesep
		for var in self.vars:
			if var.type != "RpcRetcode":
				if var.type in rpcdatas.keys():
					str += u'#include "' + var.type.lower() + u'"' + os.linesep
				elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
					str += u'#include "' + var.type[0:var.type.find("Vector")].lower() + u'"' + os.linesep
				elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
					str += u'#include "' + var.type[var.type.find("std::vector<") + 12:var.type.find(">")].lower() + u'"' + os.linesep
		str += os.linesep
		str += u"namespace " + namespace.upper() + os.linesep
		str += u"{" + os.linesep
		str += u"class " + self.name + u" : public GNET::Protocol" + os.linesep
		str += u"{" + os.linesep
		#include
		str += u'\t#include "' + self.name.lower() + '" ' + os.linesep
		str += os.linesep
		#comment
		str += u"\t/*" + os.linesep
		str += u"\tVariables:" + os.linesep
		for var in self.vars:
			str += u"\t\t" + var.type + u" " + var.name + u";"
			if len(var.comment) != 0:
				str += u"\t///< " + var.comment + os.linesep
			else:
				str += os.linesep
		str += u"\tComment:" + os.linesep
		str += self.comment + os.linesep
		str += u"\t*/" + os.linesep
		#process
		str += u"\tvoid Process(Manager *manager, Manager::Session::ID sid)" + os.linesep
		str += u"\t{" + os.linesep

		if service.name.lower().find("link") >= 0 and self.forwards.has_key("glinkd"):
			#when cur service is glink, generate code
			forward = self.forwards["glinkd"]
			#if getAttrValue(forward, "retcode"):
			#	str += u'\t\tLOG_TRACE("sid(%d) retcode(%d)", sid, retcode);' + os.linesep
			#else:
			#	str += u'\t\tLOG_TRACE("sid(%d)", sid);' + os.linesep
			var_role = getAttrValue(forward, "roleid")
			if not var_role:
				var_role = "roleid"
			profrom = getAttrValue(forward, "from") 
			if profrom == "client":
				var_thro = getAttrValue(forward, "throttle")
				if not var_thro:
					var_thro = "normal"
				if var_role != "none":
					str += u'\t\tif(GLinkServer::ValidThrottleRole(sid, %s, THROTTLE_%s)) {'%(var_role, var_thro.upper()) + os.linesep
					str += u'\t\t\tLOG_TRACE("sid(%%d) role(%%lld) operate too frequencyly)", sid, %s);' % var_role + os.linesep
					str += u'\t\t\treturn;' + os.linesep
					str += u'\t\t}' + os.linesep
					str += os.linesep
				else:
					str += u'\t\tif(GLinkServer::ValidThrottleSid(sid, THROTTLE_%s)) {'%(var_thro.upper()) + os.linesep
					str += u'\t\t\tLOG_TRACE("sid(%%d) operate too frequencyly)", sid);' + os.linesep
					str += u'\t\t\treturn;' + os.linesep
					str += u'\t\t}' + os.linesep
					str += os.linesep
				localsid = getAttrValue(forward, "localsid") 
				if not localsid :
					localsid = "localsid"
				if localsid != "none":
					str += u'\t\t%s = sid;' % localsid + os.linesep
			elif profrom == "gdeliveryd":
				pass
			elif profrom == "gamed":
				pass

			str += os.linesep

			proto = getAttrValue(forward, "to") 
			if proto == "client":
				localsid = getAttrValue(forward, "localsid")
				if localsid == "none":
					torole = getAttrValue(forward, "roleid")
					if not torole:
						raise RpcException("protocol '" + self.name + "' <forward>'s attr [roleid] should defined when attr[localsid] == none")
					str += u'\t\tRoleData* _roledata = GLinkServer::GetInstance()->GetRoleInfo(%s);' % torole + os.linesep
					str += u'\t\tif(!_roledata) return;' + os.linesep
					str += u'\t\tint localsid = _roledata->sid;' + os.linesep
					str += os.linesep
				str += u'\t\tGLinkServer::GetInstance()->Send(localsid, this);' + os.linesep
			elif proto == "gamed":
				str += u'\t\tSessionInfo* sinfo = GLinkServer::GetInstance()->GetSessionInfo(sid);' + os.linesep
				str += u'\t\tif(!sinfo) return;' + os.linesep
				str += u'\t\tGProviderServer::GetInstance()->DispatchProtocol(sinfo->gsid, this);' + os.linesep
			elif proto == "gdeliveryd":
				str += u'\t\tGDeliveryClient::GetInstance()->SendProtocol(this);' + os.linesep


		str += u"\t}" + os.linesep
		str += u"};" + os.linesep
		str += u"};" + os.linesep
		str += u"#endif" + os.linesep
		return str
	def toAS(self, project, rpcdatas):
		#str  = os.linesep
		str  = 'package ' + project.lower() + '.net.gnet {' + os.linesep
		str += os.linesep
		#import
		for var in self.vars:
			if var.type != "RpcRetcode":
				if var.type in rpcdatas.keys():
					str += u'import ' + project + '.net.gnet.beans.' + var.type + ';' + os.linesep
				elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
					str += u'import ' + project + '.net.gnet.beans.' + var.type[0:var.type.find("Vector")] + u';' + os.linesep
				elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
					str += u'import ' + project + '.net.gnet.beans.' + var.type[var.type.find("std::vector<") + 12:var.type.find(">")] + u';' + os.linesep
		str += os.linesep
		str += 'import com.wanmei.marshal.Bean;' + os.linesep
		str += 'import com.wanmei.marshal.Stream;' + os.linesep
		str += 'import com.wanmei.types.*;' + os.linesep
		str += 'import com.wanmei.marshal.Stream;' + os.linesep
		str += 'import ' + project.lower() + '.net.BasicProtocol;' + os.linesep
		str += os.linesep
		str += 'public class ' + self.name + ' extends ' + project.lower() + '.net.BasicProtocol {' + os.linesep
		str += '\tpublic static const PROTOCOL_TYPE : int = ' + self.type + ";" + os.linesep
		str += os.linesep
		#comment
		str += u"\t/*" + os.linesep
		str += self.comment + os.linesep
		str += u"\t*/" + os.linesep
		#variables
		for var in self.vars:
			str += '\t' + 'public var ' + var.name + ' : '
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
				str += 'int;'
			elif var.type in ('double', 'float'):
				str += 'Number;'
			elif var.type == 'int64_t':
				str += 'com.wanmei.types.Int64;'
			elif var.type == 'uint64_t':
				str += 'com.wanmei.types.UInt64;'
			elif var.type == 'Octets':
				str += 'com.wanmei.types.Octets;'
			elif var.type in rpcdatas.keys():
				str += project + '.net.gnet.beans.' + var.type + ';'
			elif var.type == 'ByteVector':
				str += 'Vector.<int>;'
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'Vector.<' + project + '.net.gnet.beans.' + var.type[0:var.type.find("Vector")] + u'>;'
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'Vector.<' + project + '.net.gnet.beans.' + vartype + u'>;'
				elif vartype in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
					str += 'Vector.<int>;'
				elif vartype in ('double', 'float'):
					str += 'Vector.<Number>;'
				elif vartype == 'int64_t':
					str += 'Vector.<com.wanmei.types.Int64>;'
				elif vartype == 'uint64_t':
					str += 'Vector.<com.wanmei.types.UInt64>;'
				elif vartype == 'Octets':
					str += 'Vector.<com.wanmei.types.Octets>;'
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
			if len(var.comment) != 0:
				str += u"\t/* " + var.comment + " */" + os.linesep;
			else:
				str += os.linesep
		str += os.linesep
		#constructor
		str += "\tpublic function " + self.name + "() {" + os.linesep
		str += "\t\tptype = PROTOCOL_TYPE;" + os.linesep
		str += os.linesep
		for var in self.vars:
			str += "\t\t" + var.name + " = "
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
				str += '0;' + os.linesep
			elif var.type in ('double', 'float'):
				str += 'new Number();' + os.linesep
			elif var.type == 'int64_t':
				str += 'new com.wanmei.types.Int64();' + os.linesep
			elif var.type == 'uint64_t':
				str += 'new com.wanmei.types.UInt64();' + os.linesep
			elif var.type == 'Octets':
				str += 'new com.wanmei.types.Octets();' + os.linesep
			elif var.type in rpcdatas.keys():
				str += 'new ' + project + '.net.gnet.beans.' + var.type + ';' + os.linesep
			elif var.type == 'ByteVector':
				str += 'new Vector.<int>;' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'new Vector.<' + project + '.net.gnet.beans.' + var.type[0:var.type.find("Vector")] + u'>();' + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'new Vector.<' + project + '.net.gnet.beans.' + vartype + u'>();' + os.linesep
				elif vartype in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'unsigned long', 'long'):
					str += 'new Vector.<int>();' + os.linesep
				elif vartype in ('double', 'float'):
					str += 'new Vector.<Number>();' + os.linesep
				elif vartype == 'int64_t':
					str += 'new Vector.<com.wanmei.types.Int64>();' + os.linesep
				elif vartype == 'uint64_t':
					str += 'new Vector.<com.wanmei.types.UInt64>();' + os.linesep
				elif vartype == 'Octets':
					str += 'new Vector.<com.wanmei.types.Octets>();' + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t}" + os.linesep + os.linesep
		#marshal
		str += "\tpublic override function marshal(_os_ : Stream) : Stream {" + os.linesep
		str += "\t\tvar i:int = 0;" + os.linesep
		for var in self.vars:
			if var.type in ('unsigned char', 'char'):
				str += "\t\t" + "_os_.marshal" + 'Int8(' + var.name + ");" + os.linesep
			elif var.type in ('unsigned short', 'short'):
				str += "\t\t" + "_os_.marshal" + 'Int16(' + var.name + ");" + os.linesep
			elif var.type in ('unsigned int', 'int', 'unsigned long', 'long'):
				str += "\t\t" + "_os_.marshal" + 'Int32(' + var.name + ");" + os.linesep
			elif var.type == 'double':
				str += "\t\t" + "_os_.marshal" + 'Double(' + var.name + ");" + os.linesep
			elif var.type == 'float':
				str += "\t\t" + "_os_.marshal" + 'Float(' + var.name + ");" + os.linesep
			elif var.type == 'int64_t':
				str += "\t\t" + "_os_.marshal" + 'Int64(' + var.name + ");" + os.linesep
			elif var.type == 'uint64_t':
				str += "\t\t" + "_os_.marshal" + 'UInt64(' + var.name + ");" + os.linesep
			elif var.type == 'Octets':
				str += "\t\t" + "_os_.marshal" + 'Octets(' + var.name + ");" + os.linesep
			elif var.type in rpcdatas.keys():
				str += "\t\t" + "_os_.marshal" + '(' + var.name + ');' + os.linesep
			elif var.type == 'ByteVector':
				str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t" + "\t\t" + "_os_.marshalInt8" + '(' + var.name +'[i]);' + os.linesep
				str += "\t\t}" + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t" + "\t\t" + "_os_.marshal" + '(' + var.name +'[i]);' + os.linesep
				str += "\t\t}" + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshal" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned char', 'char'):
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt8" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned short', 'short'):
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt16" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned int', 'int', 'unsigned long', 'long'):
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt32" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'double':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalDouble" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'float':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalFloat" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'int64_t':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalInt64" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'uint64_t':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalUInt64" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'Octets':
					str += "\t\t_os_.compactUInt32(" + var.name + ".length);" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t" + "\t\t" + "_os_.marshalOctets" + '(' + var.name +'[i]);' + os.linesep
					str += "\t\t}" + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\treturn _os_;" + os.linesep
		str += "\t}" + os.linesep + os.linesep
		#unmarshal
		str += "\tpublic override function unmarshal(_os_ : Stream) : Stream {" + os.linesep
		v = 0
		str += "\t\tvar i:int = 0;" + os.linesep
		for var in self.vars:
			v += 1
			if var.type == 'char':
				str += "\t\t" + var.name + " = _os_.unmarshalInt8();" + os.linesep
			elif var.type == 'unsigned char':
				str += "\t\t" + var.name + " = _os_.unmarshalUInt8();" + os.linesep
			elif var.type == 'short':
				str += "\t\t" + var.name + " = _os_.unmarshalInt16();" + os.linesep
			elif var.type == 'unsigned short':
				str += "\t\t" + var.name + " = _os_.unmarshalUInt16();" + os.linesep
			elif var.type in ('int', 'long'):
				str += "\t\t" + var.name + " = _os_.unmarshalInt32();" + os.linesep
			elif var.type in ('unsigned int', 'unsigned long'):
				str += "\t\t" + var.name + " = _os_.unmarshalUInt32();" + os.linesep
			elif var.type == 'double':
				str += "\t\t" + var.name + " = _os_.unmarshalDouble();" + os.linesep
			elif var.type == 'float':
				str += "\t\t" + var.name + " = _os_.unmarshalFloat();" + os.linesep
			elif var.type == 'int64_t':
				str += "\t\t" + "_os_.unmarshalInt64(" + var.name + ");" + os.linesep
			elif var.type == 'uint64_t':
				str += "\t\t" + "_os_.unmarshalUInt64(" + var.name + ");" + os.linesep
			elif var.type == 'Octets':
				str += "\t\t" + "_os_.unmarshalOctets(" + var.name + ");" + os.linesep
			elif var.type in rpcdatas.keys():
				str += "\t\t" + "_os_.unmarshal" + '(' + var.name + ');' + os.linesep
			elif var.type == 'ByteVector':
				str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t\t\t" + "var v" + "%d" % v + ":int = new int;" + os.linesep
				str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt8" + '();' + os.linesep
				str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
				str += "\t\t}" + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
				str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
				str += "\t\t\t" + "var v" + "%d" % v + ":" + var.type[0:var.type.find("Vector")] + " = new " + var.type[0:var.type.find("Vector")] + "();" + os.linesep
				str += "\t" + "\t\t" + "_os_.unmarshal" + '(v' + "%d" % v + ');' + os.linesep
				str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
				str += "\t\t}" + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":"+ vartype + " = new " + vartype + "();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshal(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'char':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt8" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'unsigned char':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalUInt8" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'unsigned short':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalUInt16" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + "" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in 'short':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt16" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('unsigned int', 'unsigned long'):
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalUInt32" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype in ('int', 'long'):
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":int = new int();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalInt32" + '();' + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'double':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Number = new Number();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalDouble();" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'float':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Number = new Number();" + os.linesep
					str += "\t" + "\t\tv" + "%d" % v + " = _os_.unmarshalFloat();" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'int64_t':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Int64 = new Int64();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshalInt64(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'uint64_t':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":UInt64 = new UInt64();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshalUInt64(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				elif vartype == 'Octets':
					str += "\t\t" + var.name + ".length = _os_.uncompactUInt32();" + os.linesep
					str += "\t\tfor(i = 0; i < " + var.name + ".length; ++i) {" + os.linesep
					str += "\t\t\t" + "var v" + "%d" % v + ":Octets = new Octets();" + os.linesep
					str += "\t" + "\t\t_os_.unmarshalOctets(v" + "%d" % v + ");" + os.linesep
					str += "\t\t\t" + var.name + "[i] = v" + "%d" % v + ";" + os.linesep
					str += "\t\t}" + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")

		str += "\t\treturn _os_;" + os.linesep
		str += "\t}" + os.linesep + os.linesep
		str += "\t" + "public override function getMaxSize() : uint { " + os.linesep
		str += "\t\t" + "return " + self.maxsize + ";" + os.linesep
		str += "\t}" + os.linesep + os.linesep

		str += "}" + os.linesep
		str += "}" + os.linesep

		return str
	def toCSharp(self, namespace, rpcdatas):
		linesep = os.linesep
		os.linesep = "\r\n"
		str  = u'using System;' + os.linesep
		str += u'using GNET.IO;' + os.linesep
		str += u'using GNET.Common;' + os.linesep
		str += u'using GNET.Common.Security;' + os.linesep
		str += os.linesep 
		#using
		#for var in self.vars:
		#	if var.type != "RpcRetcode":
		#		if var.type in rpcdatas.keys():
		#			str += u'using GNET.Rpcdata.' + var.type + os.linesep
		#		elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
		#			str += u'using GNET.Rpcdata.' + var.type[0:var.type.find("Vector")] + os.linesep
		#		elif var.type[var.type.find("std::vector<") + 12:var.type.find(">")] in rpcdatas.keys() and var.type[var.type.find("std::vector<") + 12:var.type.find(">")] != "RpcRetcode":
		#			str += u'using GNET.Rpcdata.' + var.type[var.type.find("std::vector<") + 12:var.type.find(">")] + os.linesep
		str += "using GNET.Rpcdata;" + os.linesep
		str += os.linesep
		#class
		str += u'namespace GNET' + os.linesep
		str += u'{' + os.linesep
		#comment
		str += u"\t/*" + os.linesep
		str += self.comment + os.linesep
		str += u"\t*/" + os.linesep
		#variables
		str += u'\tpublic class ' + self.name + ' : Protocol' + os.linesep
		str += u'\t{' + os.linesep
		str += u'\t\tpublic const int PROTOCOL_TYPE = ' + self.type + ";" + os.linesep
		for var in self.vars:
			str += '\t\t' + 'public '
			if var.type == 'unsigned char':
				str += 'byte '
			elif var.type == 'char':
				str += 'sbyte '
			elif var.type == 'short':
				str += 'short '
			elif var.type == 'unsigned short':
				str += 'ushort '
			elif var.type == 'int':
				str += 'int '
			elif var.type == 'unsigned int':
				str += 'uint '
			elif var.type == 'int64_t':
				str += 'long '
			elif var.type in ('float', 'double'):
				str += var.type + ' '
			elif var.type == 'Octets':
				str += 'Octets '
			elif var.type in rpcdatas.keys():
				str += var.type + ' '
			elif var.type == 'ByteVector':
				str += 'ByteVector '
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'RpcDataVector<' + var.type[0:var.type.find("Vector")] + u'> '
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'RpcDataVector<' + vartype + u'> '
				elif vartype in ('unsigned char', 'char'):
					str += 'ByteVector '
				elif vartype in ('unsigned short', 'short'):
					str += 'ShortVector '
				elif vartype in ('unsigned int', 'int'):
					str += 'IntVector '
				elif vartype == 'int64_t':
					str += 'LongVector '
				elif vartype == 'Octets':
					str += 'OctetsVector '
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
			str += var.name + ';\t' 
			if len(var.comment) != 0:
				str += u"\t/* " + var.comment + " */" + os.linesep;
			else:
				str += os.linesep
		str += os.linesep
		#constructor
		str += "\t\tpublic " + self.name + "()" + os.linesep
		str += "\t\t\t: base(PROTOCOL_TYPE, " + self.maxsize + ", " + self.prior + ")" + os.linesep
		str += "\t\t{" + os.linesep
		for var in self.vars:
			str += "\t\t\t" + var.name + " = "
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'int64_t', 'float', 'double'):
				str += '0;' + os.linesep
			elif var.type == 'Octets':
				str += 'new Octets();' + os.linesep
			elif var.type in rpcdatas.keys():
				str += 'new ' + var.type + '();' + os.linesep
			elif var.type == 'ByteVector':
				str += 'new ByteVector();' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += 'new RpcDataVector<' + var.type[0:var.type.find("Vector")] + u'>();' + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += 'new RpcDataVector<' + vartype + u'>();' + os.linesep
				elif vartype in ('unsigned char', 'char'):
					str += 'new ByteVector();' + os.linesep
				elif vartype in ('unsigned short', 'short'):
					str += 'new ShortVector();' + os.linesep
				elif vartype in ('unsigned int', 'int'):
					str += 'new IntVector();' + os.linesep
				elif vartype == 'int64_t':
					str += 'new LongVector();' + os.linesep
				elif vartype == 'Octets':
					str += 'new OctetsVector();' + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\t}" + os.linesep + os.linesep
		#Clone
		str += "\t\tpublic override Object Clone()" + os.linesep
		str += "\t\t{" + os.linesep
		str += "\t\t\t" + self.name + " obj = new " + self.name + "();" + os.linesep
		for var in self.vars:
			str += "\t\t\tobj." + var.name + " = "
			if var.type in ('unsigned char', 'char', 'unsigned short', 'short', 'unsigned int', 'int', 'int64_t', 'float', 'double'):
				str += var.name + ";" + os.linesep
			elif var.type == 'Octets':
				str += '(Octets)' + var.name + '.Clone();' + os.linesep
			elif var.type in rpcdatas.keys():
				str += '(' + var.type + ')' + var.name + '.Clone();' + os.linesep
			elif var.type == 'ByteVector':
				str += '(ByteVector)' + var.name + '.Clone();' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += '(RpcDataVector<' + var.type[0:var.type.find("Vector")] + u'>)' + var.name + '.Clone();' + os.linesep
			else:
				vartype = var.type[var.type.find("std::vector<") + 12:var.type.find(">")]
				if vartype in rpcdatas.keys() and vartype != "RpcRetcode":
					str += '(RpcDataVector<' + vartype + u'>)' + var.name + '.Clone();' + os.linesep
				elif vartype in ('unsigned char', 'char'):
					str += '(ByteVector)' + var.name + '.Clone();' + os.linesep
				elif vartype in ('unsigned short', 'short'):
					str += '(ShortVector)' + var.name + '.Clone();' + os.linesep
				elif vartype in ('unsigned int', 'int'):
					str += '(IntVector)' + var.name + '.Clone();' + os.linesep
				elif vartype == 'int64_t':
					str += '(LongVector)' + var.name + '.Clone();' + os.linesep
				elif vartype == 'Octets':
					str += '(OctetsVector)' + var.name + '.Clone();' + os.linesep
				else:
					raise RpcException("Client rpcdata '" + self.name + "' can't use variable '" + var.name + "'")
		str += "\t\t\treturn obj;" + os.linesep
		str += "\t\t}" + os.linesep + os.linesep
		#marshal
		str += "\t\tpublic override OctetsStream marshal(OctetsStream os)" + os.linesep
		str += "\t\t{" + os.linesep
		for var in self.vars:
			str += "\t\t\tos.marshal(" + var.name + ");" + os.linesep;
		str += "\t\t\treturn os;" + os.linesep
		str += "\t\t}" + os.linesep + os.linesep
		#unmarshal
		str += "\t\tpublic override OctetsStream unmarshal(OctetsStream os)" + os.linesep
		str += "\t\t{" + os.linesep
		for var in self.vars:
			if var.type == 'char':
				str += "\t\t\t" + var.name + " = os.unmarshal_sbyte();" + os.linesep
			elif var.type == 'unsigned char':
				str += "\t\t\t" + var.name + " = os.unmarshal_byte();" + os.linesep
			elif var.type == 'short':
				str += "\t\t\t" + var.name + " = os.unmarshal_short();" + os.linesep
			elif var.type == 'unsigned short':
				str += "\t\t\t" + var.name + " = os.unmarshal_ushort();" + os.linesep
			elif var.type == 'int':
				str += "\t\t\t" + var.name + " = os.unmarshal_int();" + os.linesep
			elif var.type == 'unsigned int':
				str += "\t\t\t" + var.name + " = os.unmarshal_uint();" + os.linesep
			elif var.type == 'int64_t':
				str += "\t\t\t" + var.name + " = os.unmarshal_long();" + os.linesep
			elif var.type == 'double':
				str += "\t\t\t" + var.name + " = os.unmarshal_double();" + os.linesep
			elif var.type == 'float':
				str += "\t\t\t" + var.name + " = os.unmarshal_float();" + os.linesep
			elif var.type == 'Octets':
				str += "\t\t\t" + var.name + " = os.unmarshal_Octets();" + os.linesep
			elif var.type in rpcdatas.keys():
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
			elif var.type == 'ByteVector':
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
			elif var.type[0:var.type.find("Vector")] in rpcdatas.keys() and var.type[0:var.type.find("Vector")] != "RpcRetcode":
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
			else:
				str += "\t\t\t" + "os.unmarshal" + '(' + var.name + ');' + os.linesep
		str += "\t\t\treturn os;" + os.linesep
		str += "\t\t}" + os.linesep + os.linesep
		str += "\t}" + os.linesep
		str += "}" + os.linesep
		os.linesep = linesep
		return str

	

class Rpc:
	def __init__(self, name, type, maxsize, namespace=u'GNET', argument='', result='', prior=1, timeout=30, debug=0):
		self.name = name
		self.type = type
		self.maxsize = maxsize
		self.argument = argument
		self.result = result
		self.prior = prior
		self.timeout = timeout
		self.debug = debug
		self.baseclass = ''
		self.sendmanager = ''
	def __str__(self):
		return self.name + " " + self.type + " " + self.maxsize + " " + self.prior + " " + self.argument + " " + self.result + " " + self.timeout
	def toInl(self):
		#class clone
		str  = u"\t\tGNET::Protocol *Clone() const { return new " + self.name + u"(*this); }" + os.linesep
		#class variable
		str += u"\tpublic:" + os.linesep
		str += u"\t\tenum { PROTOCOL_TYPE = RPC_" + self.name.upper() + u" };" + os.linesep
		#class constructor
		str += u"\t\t" + self.name + u"(Type type, Rpc::Data *argument, Rpc::Data *result): RPC_BASECLASS(type, argument, result, \"" + self.name + u"\") { }" + os.linesep
		#class copy constructor
		str += u"\t\t" + self.name + u"(const " + self.name + "& rhs): RPC_BASECLASS(rhs) { }" + os.linesep
		#class PriorPolicy
		str += u"\t\tint PriorPolicy() const { return " + self.prior + u"; }" + os.linesep
		#class SizePolicy
		str += u"\t\tbool SizePolicy(size_t size) const { return size <= " + self.maxsize + u"; }" + os.linesep
		#class TimePolicy
		str += u"\t\tbool TimePolicy(int timeout) const { return timeout <= " + self.timeout + u"; }" + os.linesep
		return str

class State:
	def __init__(self, name, timeout=86400):
		self.name = name
		self.timeout = timeout
		self.protocols = []
		self.rpcs = []
	def __str__(self):
		return self.name + " " + self.timeout
	def addProtocolRef(self, ref):
		if ref in self.protocols:
			raise RpcException("State '" + self.name + "' has protocol ref=" + ref + " yet")
		self.protocols.append(ref)
	def addRpcRef(self, ref):
		if ref in self.rpcs:
			raise RpcException("State '" + self.name + "' has rpc ref=" + ref + " yet")
		self.rpcs.append(ref)

class ServiceRpc:
	def __init__(self, rpc, baseclass="Rpc", sendmanager=''):
		self.rpc = rpc
		self.baseclass = baseclass
		self.sendmanager = sendmanager
	def __str__(self):
		return self.rpc.name + " " + self.baseclass + " " + self.sendmanager
	def isProxyRpc(self):
		return self.baseclass == u'ProxyRpc'
	def toHrp(self, namespace):
		str  = u'#ifndef __' + namespace.upper() + u'_' + self.rpc.name.upper() + u'_HPP' + os.linesep
		str += u'#define __' + namespace.upper() + u'_' + self.rpc.name.upper() + u'_HPP' + os.linesep
		str += os.linesep
		str += u'#include "rpcdefs.h"' + os.linesep
		str += u'#include "callid.hxx"' + os.linesep
		str += u'#include "state.hxx"' + os.linesep
		str += os.linesep
		if self.rpc.argument != '' and self.rpc.argument != 'RpcRetcode':
			str += u'#include "' + self.rpc.argument.lower() + '"' + os.linesep
		elif self.rpc.argument != 'RpcRetcode':
			str += u'#include "' + self.rpc.name.lower() + 'arg"' + os.linesep
		if self.rpc.result != '' and self.rpc.result != 'RpcRetcode':
			str += u'#include "' + self.rpc.result.lower() + '"' + os.linesep
		elif self.rpc.result != 'RpcRetcode':
			str += u'#include "' + self.rpc.name.lower() + 'res"' + os.linesep
		str += os.linesep
		str += u"namespace " + namespace.upper() + os.linesep
		str += u"{" + os.linesep
		str += u"class " + self.rpc.name + u" : public GNET::Rpc" + os.linesep
		str += u"{" + os.linesep
		str += os.linesep
		#include
		str += u"#define RPC_BASECLASS Rpc" + os.linesep
		str += u'\t#include "' + self.rpc.name.lower() + '" ' + os.linesep
		str += u"#undef RPC_BASECLASS" + os.linesep
		str += os.linesep
		#server
		str += u"\tvoid Server(Rpc::Data *argument, Rpc::Data *result, Manager *manager, Manager::Session::ID sid)" + os.linesep
		str += u"\t{" + os.linesep
		if self.rpc.argument != '':
			str += u"\t\t// " + self.rpc.argument + "* arg = (" + self.rpc.argument + "* ) argument;" + os.linesep
		else:
			str += u"\t\t// " + self.rpc.name + "Arg* arg = (" + self.rpc.name + "Arg* ) argument;" + os.linesep
		if self.rpc.result != '':
			str += u"\t\t// " + self.rpc.result + "* res = (" + self.rpc.result + "* ) result;" + os.linesep
		else:
			str += u"\t\t// " + self.rpc.name + "Res* res = (" + self.rpc.name + "Res* ) result;" + os.linesep
		str += u"\t}" + os.linesep
		str += os.linesep
		#client
		str += u"\tvoid Client(Rpc::Data *argument, Rpc::Data *result, Manager *manager, Manager::Session::ID sid)" + os.linesep
		str += u"\t{" + os.linesep
		if self.rpc.argument != '':
			str += u"\t\t// " + self.rpc.argument + "* arg = (" + self.rpc.argument + "* ) argument;" + os.linesep
		else:
			str += u"\t\t// " + self.rpc.name + "Arg* arg = (" + self.rpc.name + "Arg* ) argument;" + os.linesep
		if self.rpc.result != '':
			str += u"\t\t// " + self.rpc.result + "* res = (" + self.rpc.result + "* ) result;" + os.linesep
		else:
			str += u"\t\t// " + self.rpc.name + "Res* res = (" + self.rpc.name + "Res* ) result;" + os.linesep
		str += u"\t}" + os.linesep
		str += os.linesep
		#timeout
		str += u"\tvoid OnTimeout()" + os.linesep
		str += u"\t{" + os.linesep
		str += u"\t\t// TODO Client Only" + os.linesep
		str += u"\t}" + os.linesep
		str += os.linesep
		str += u"};" + os.linesep
		str += u"};" + os.linesep
		str += u"#endif" + os.linesep
		return str
	def toProxyHrp(self, namespace, sendmanager):
		str  = u'#ifndef __' + namespace.upper() + u'_' + self.rpc.name.upper() + u'_HPP' + os.linesep
		str += u'#define __' + namespace.upper() + u'_' + self.rpc.name.upper() + u'_HPP' + os.linesep
		str += os.linesep
		str += u'#include "rpcdefs.h"' + os.linesep
		str += u'#include "callid.hxx"' + os.linesep
		str += u'#include "state.hxx"' + os.linesep
		str += os.linesep
		if self.rpc.argument != '' and self.rpc.argument != 'RpcRetcode':
			str += u'#include "' + self.rpc.argument.lower() + '"' + os.linesep
		elif self.rpc.argument != 'RpcRetcode':
			str += u'#include "' + self.rpc.name.lower() + 'arg"' + os.linesep
		if self.rpc.result != '' and self.rpc.result != 'RpcRetcode':
			str += u'#include "' + self.rpc.result.lower() + '"' + os.linesep
		elif self.rpc.result != 'RpcRetcode':
			str += u'#include "' + self.rpc.name.lower() + 'res"' + os.linesep
		str += os.linesep
		if sendmanager != '':
			str += u'#include "' + sendmanager.lower() + '.hpp"' + os.linesep + os.linesep
		str += u"namespace " + namespace.upper() + os.linesep
		str += u"{" + os.linesep
		str += u"class " + self.rpc.name + u" : public GNET::ProxyRpc" + os.linesep
		str += u"{" + os.linesep
		str += os.linesep
		#include
		str += u"#define RPC_BASECLASS ProxyRpc" + os.linesep
		str += u'\t#include "' + self.rpc.name.lower() + '" ' + os.linesep
		str += u"#undef RPC_BASECLASS" + os.linesep
		str += os.linesep
		#delivery
		str += u"\tbool Delivery(Manager::Session::ID proxy_sid, const OctetsStream& osArg)" + os.linesep
		str += u"\t{" + os.linesep
		str += u"\t\t// TODO" + os.linesep
		arg = ''
		if self.rpc.argument != '':
			arg = self.rpc.argument + " arg;" + os.linesep
		else:
			arg = self.rpc.name + 'Arg arg;' + os.linesep
		if sendmanager.endswith('Client'):
			str += u"\t\t// " + arg;
			str += u"\t\t// osArg >> arg;" + os.linesep
			str += u"\t\tif(" + sendmanager + "::GetInstance()->SendProtocol(*this))" + os.linesep
		else:
			str += u"\t\t" + arg; 
			str += u"\t\tosArg >> arg;" + os.linesep
			str += u"\t\tif(" + sendmanager + "::GetInstance()->Send(arg.localsid, this))" + os.linesep
		str += u"\t\t{" + os.linesep
		str += u"\t\t\treturn true;" + os.linesep
		str += u"\t\t}" + os.linesep
		str += u"\t\telse" + os.linesep
		str += u"\t\t{" + os.linesep
		str += u"\t\t\tSetResult(" 
		if self.rpc.result != '': 
			str += self.rpc.result + "(ERR_DELIVER_SEND));" + os.linesep
		else :
			str += self.rpc.name + "Res(ERR_DELIVER_SEND));" + os.linesep
		str += u"\t\t\tSendToSponsor();" + os.linesep
		str += u"\t\t\treturn false;" + os.linesep
		str += u"\t\t}" + os.linesep
		str += u"\t}" + os.linesep
		str += os.linesep
		#postprocess
		str += u"\tvoid PostProcess(Manager::Session::ID proxy_sid,const OctetsStream& osArg, const OctetsStream& osRes)" + os.linesep
		str += u"\t{" + os.linesep
		str += u"\t\t// TODO" + os.linesep
		if self.rpc.argument != '':
			str += u"\t\t// " + self.rpc.argument + " arg;" + os.linesep
		else:
			str += u"\t\t// " + self.rpc.name + 'Arg arg;' + os.linesep
		str += u"\t\t// osArg >> arg;" + os.linesep
		if self.rpc.result != '':
			str += u"\t\t// " + self.rpc.result + " res;" + os.linesep
		else:
			str += u"\t\t// " + self.rpc.name + 'Res res;' + os.linesep
		str += u"\t\t// osRes >> res;" + os.linesep
		str += u"\t\t// SetResult( &res ); // if you modified res, do not forget to call this." + os.linesep
		str += u"\t}" + os.linesep
		str += os.linesep
		#timeout
		str += u"\tvoid OnTimeout()" + os.linesep
		str += u"\t{" + os.linesep
		str += u"\t\t// TODO Client Only" + os.linesep
		str += u"\t}" + os.linesep
		str += os.linesep
		str += u"};" + os.linesep
		str += u"};" + os.linesep
		str += u"#endif" + os.linesep
		return str

		
class Manager:
	def __init__(self, name, type, initstate, reconnect='0'):
		self.name = name
		self.type = type
		self.initstate = initstate
		self.reconnect = reconnect
	def __str__(self):
		return self.name + " " + self.type + " " + self.initstate + " " + self.reconnect

class Service:
	def __init__(self, name):
		self.name = name
		self.managers = {}
		self.states = {}
		self.protocols = []
		self.rpcs = {}
	def __str__(self):
		return self.name
	def addManager(self, manager):
		if manager in self.managers.keys():
			raise RpcException("Service '" + self.name + "' has manager '" + manager.name + "' yet")
		self.managers[manager.name] = manager
	def hasSendManager(self, sendmanager):
		if sendmanager.endswith('Server'):
			sendmanagername = sendmanager[0:sendmanager.find('Server')]
			if sendmanagername in self.managers.keys():
				return True
			else:
				for manager in self.managers.values():
					if sendmanager == manager.initstate:
						return True
		elif sendmanager.endswith('Client'):
			sendmanagername = sendmanager[0:sendmanager.find('Client')]
			if sendmanagername in self.managers.keys():
				return True
			else:
				for manager in self.managers.values():
					if sendmanager == manager.initstate:
						return True
		return False
	def getSendManager(self, sendmanager):
		if sendmanager.endswith('Server'):
			sendmanagername = sendmanager[0:sendmanager.find('Server')]
			if sendmanagername in self.managers.keys():
				return sendmanager
			else:
				for manager in self.managers.values():
					if sendmanager == manager.initstate and manager.type.lower() == 'server':
						return manager.name + "Server"
		elif sendmanager.endswith('Client'):
			sendmanagername = sendmanager[0:sendmanager.find('Client')]
			if sendmanagername in self.managers.keys():
				return sendmanager
			else:
				for manager in self.managers.values():
					if sendmanager == manager.initstate and manager.type.lower() == 'client':
						return manager.name + "Client"
		return ''
	def addState(self, state):
		if state.name in self.states.keys():
			raise RpcException("State " + state.name + " has already defined!")
		self.states[state.name] = state
	def addProtocolRef(self, protocol):
		if protocol in self.protocols:
			raise RpcException("Service '" + self.name + "' has protocol ref=" + protocol.name + "' yet")
		self.protocols.append(protocol)
	def addServiceRpc(self, servicerpc):
		if servicerpc.rpc.name in self.rpcs.keys():
			raise RpcException("Service '" + self.name + "' has rpc '" + servicerpc.rpc.name + "' yet")
		self.rpcs[servicerpc.rpc.name] = servicerpc

class Application:
	def __init__(self):
		self.project = None
		self.namespace = u'GNET'
		self.services = {}
		self.protocols = {}
		self.types = {}
		self.rpcs = {}
		self.rpcdatas = {}
		# below is default rpcdata, rpc and protocol
		self.rpcdatas['RpcRetcode'] = RpcData('RpcRetcode') # Defined in rpc/rpcdefs.h
		self.protocols['BINDER'] = Protocol('BINDER', '0', '0')
		self.protocols['COMPRESSBINDER'] = Protocol('COMPRESSBINDER', '16', '0')
		self.types[0] = self.protocols['BINDER']
		self.types[16] = self.protocols['COMPRESSBINDER']
	def parse(self, node):
		parseMethod = getattr(self, 'parse_%s' % node.__class__.__name__)
		parseMethod(node)
	def parse_Document(self, node):
		self.parse(node.documentElement)
	def parse_Text(self, node):
		pass
	def parse_Comment(self, node):
		pass
	def parse_Element(self, node):
		if node.tagName != 'application':
			raise RpcException("The root element of xml file is not 'application'")
		handleMethod = getattr(self, 'do_%s' % node.tagName)
		handleMethod(node)
	def parse_NoneType(self, node):
		pass
	def addRpcData(self, rpcdata):
		if rpcdata.name in self.rpcdatas.keys():
			raise RpcException("Rpcdata " + rpcdata.name + " has already defined!")
		self.rpcdatas[rpcdata.name] = rpcdata
	def addProtocol(self, protocol):
		if protocol.name in self.protocols.keys():
			raise RpcException("Protocol " + protocol.name + " has already defined!")
		if protocol.type in self.types.keys():
			raise RpcException("Protocol " + protocol.name + "'s type '" + protocol.type + "' is duplicated!")
		self.protocols[protocol.name] = protocol
		self.types[protocol.type] = protocol.name
	def addRpc(self, rpc):
		if rpc.name in self.rpcs.keys() + self.protocols.keys():
			raise RpcException("Rpc " + rpc.name + " has already defined!")
		if rpc.type in self.types.keys():
			raise RpcException("Rpc " + rpc.name + "'s type '" + rpc.type + "' is duplicated!")
		self.rpcs[rpc.name] = rpc
		self.types[rpc.type] = rpc.name
	def addService(self, service):
		if service.name in self.services.keys():
			raise RpcException("Service " + service.name + " has already defined!")
		self.services[service.name] = service
	def do_application(self, node):
		if node.parentNode.nodeType != node.parentNode.DOCUMENT_NODE:
			raise RpcException("Application is not the root element!")
		if 'project' not in node.attributes.keys():
			raise RpcException("Application does not have attribute 'project'")
		if 'namespace' not in node.attributes.keys():
			raise RpcException("Application does not have attribute 'namespace'")
		self.project = node.attributes['project'].value
		self.namespace = node.attributes['namespace'].value
		print "Loading project", self.project, "..."
		# Load rpcdatas
		vars = node.getElementsByTagName('rpcdata')
		for var in vars:
			if var.parentNode == node:
				self.do_rpcdata(var)
		# Load protocols
		vars = node.getElementsByTagName('protocol')
		for var in vars:
			if var.parentNode == node:
				self.do_protocol(var)
		# Load rpcs
		vars = node.getElementsByTagName('rpc')
		for var in vars:
			if var.parentNode == node:
				self.do_rpc(var)
		# Load services
		if ROBOT:
			var = minidom.Element('sevice')
			var.setAttribute('name', 'client')
			self.do_service(var)
		else:
			vars = node.getElementsByTagName('service')
			for var in vars:
				if var.parentNode == node:
					self.do_service(var)
	def do_rpcdata(self, node):
		if 'name' not in node.attributes.keys():
			raise RpcException("Some rpcdata does not have attribute 'name'")
		name = node.attributes['name'].value
		rpcdata = RpcData(name)
		rpcdata.attr = node.getAttribute('attr')
		rpcdata.bdbtable = node.getAttribute('bdbtable')
		rpcdata.key = node.getAttribute('key')
		if DEBUG_MODE:
			print " Loading rpcdata", rpcdata, "..."
			print " ", rpcdata
		vars = node.getElementsByTagName('variable')
		varhasdefault = False
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('name'):
				raise RpcException("Rpcdata " + name + " 's variable does not have attribute 'name'")
			varname = var.getAttribute('name')
			if not var.hasAttribute('type'):
				raise RpcException("Rpcdata " + name + " 's variable " + varname + "does not have attribute 'type'")
			vartype = var.getAttribute('type')
			vardefault = var.getAttribute('default')
			if varhasdefault and vardefault == '':
				err = "Rpcdata " + name + "'s variable '" + varname + "' would better have attribute 'default' because previous variable has attribute default"
				#raise RpcException(err)
				if VERBOSE_MODE:
					print "Warn: ", err
			if vardefault != '':
				varhasdefault = True
			varattr = var.getAttribute('attr')
			variable = Variable(varname, vartype, vardefault, varattr)
			if var.hasAttribute('comment'):
				variable.comment = var.getAttribute('comment')
			if DEBUG_MODE:
				print "\t", variable
			rpcdata.addVariable(variable)
		cmts = node.getElementsByTagName('comment')
		for cmt in cmts:
			if cmt.parentNode != node:
				continue
			if not cmt.hasAttribute('text'):
				continue
			cmttext = cmt.getAttribute('text')
			rpcdata.addComment(cmttext)
		self.addRpcData(rpcdata)
	def do_protocol(self, node):
		if 'name' not in node.attributes.keys():
			raise RpcException("Some protocol does not have attribute 'name'")
		name = node.attributes['name'].value
		if not node.hasAttribute('type'):
			raise RpcException("Protocol " + name + " does not have attribute 'type'")
		type = node.getAttribute('type')
		if not node.hasAttribute('maxsize'):
			raise RpcException("Protocol " + name + " does not have attribute 'maxsize'")
		maxsize = node.getAttribute('maxsize')
		protocol = Protocol(name, type, maxsize)
		if node.hasAttribute('prior'):
			protocol.prior = node.getAttribute('prior')
		if node.hasAttribute('debug'):
			protocol.debug = node.getAttribute('debug')
		if DEBUG_MODE:
			print " Loading protocol", name, "..."
			print " ", protocol
		protocol.forwards = {}
		forwards = node.getElementsByTagName("forward")
		for forward in forwards:
			if not forward.hasAttribute("from"):
				raise RpcException("protocol %s , forward has not attribute 'from'" % name)
			if not forward.hasAttribute("relay"):
				raise RpcException("protocol %s , forward has not attribute 'relay'" % name)
			if not forward.hasAttribute("to"):
				raise RpcException("protocol %s , forward has not attribute 'to'" % name)
			protocol.forwards[getAttrValue(forward, "relay")] = forward
		vars = node.getElementsByTagName('variable')
		varhasdefault = False
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('name'):
				raise RpcException("Protocol " + name + " 's variable does not have attribute 'name'")
			varname = var.getAttribute('name')
			if not var.hasAttribute('type'):
				raise RpcException("Protocol " + name + " 's variable " + varname + "does not have attribute 'type'")
			vartype = var.getAttribute('type')
			vardefault = var.getAttribute('default')
			if varhasdefault and vardefault == '':
				err = "Protocol " + name + "'s variable '" + varname + "' must have attribute 'default' because previous variable has attribute default"
				raise RpcException(err)
			if vardefault != '':
				varhasdefault = True
			varattr = var.getAttribute('attr')
			variable = Variable(varname, vartype, vardefault, varattr)
			if var.hasAttribute('comment'):
				variable.comment = var.getAttribute('comment')
			if DEBUG_MODE:
				print "\t", variable
			protocol.addVariable(variable)
		cmts = node.getElementsByTagName('comment')
		for cmt in cmts:
			if cmt.parentNode != node:
				continue
			if not cmt.hasAttribute('text'):
				continue
			cmttext = cmt.getAttribute('text')
			protocol.addComment(cmttext)
		self.addProtocol(protocol)
	def do_rpc(self, node):
		if 'name' not in node.attributes.keys():
			raise RpcException("Some rpc does not have attribute 'name'")
		name = node.attributes['name'].value
		if not node.hasAttribute('type'):
			raise RpcException("Rpc " + name + " does not have attribute 'type'")
		type = node.getAttribute('type')
		if not node.hasAttribute('maxsize'):
			raise RpcException("Rpc " + name + " does not have attribute 'maxsize'")
		maxsize = node.getAttribute('maxsize')
		rpc = Rpc(name, type, maxsize)
		if not node.hasAttribute('argument'):
			if VERBOSE_MODE:
				print "\033[1;33mWarn:  \033[0mRpc " + name + " does not have attribute 'argument'"
		else:
			argument = node.getAttribute('argument')
			if argument not in self.rpcdatas.keys():
				raise RpcException("Rpc " + name + "'s argument '" + argument + "' is not defined")
			rpc.argument = 	argument
		if not node.hasAttribute('result'):
			if VERBOSE_MODE:
				print "\033[1;33mWarn:  \033[0mRpc " + name + " does not have attribute 'result'"
		else:
			result = node.getAttribute('result')
			if result not in self.rpcdatas.keys():
				raise RpcException("Rpc " + name + "'s result '" + result + "' is not defined")
			rpc.result = result
		if node.hasAttribute('prior'):
			rpc.prior = node.getAttribute('prior')
		else:
			raise RpcException("Rpc " + name + " does not have attribute 'prior'")
		if node.hasAttribute('timeout'):
			rpc.timeout = node.getAttribute('timeout')
		if node.hasAttribute('debug'):
			rpc.debug = node.getAttribute('debug')
		if DEBUG_MODE:
			print " Loading rpc", name, "..."
			print " ", rpc
		self.addRpc(rpc)
	def do_state(self, node, service):
		if 'name' not in node.attributes.keys():
			raise RpcException("Some state does not have attribute 'name'")
		name = node.attributes['name'].value
		state = State(name)
		if node.hasAttribute('timeout'):
			state.timeout = node.getAttribute('timeout')
		else:
			if VERBOSE_MODE:
				print "\033[1;33mWarn:  \033[0mstate '" + name + "' does not have attribute 'timeout'"
		if DEBUG_MODE:
			print " Loading state", name, "..."
			print " ", state
			print "  Protocols:" 
		vars = node.getElementsByTagName('protocol')
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('ref'):
				raise RpcException("state " + name + "'s some protocol does not have attribute 'ref'")
			ref = var.getAttribute('ref')
			if ref in self.protocols.keys():
				if ref == 'BINDER' or ref == 'COMPRESSBINDER':
					if var.hasAttribute('maxsize'):
						maxsize = var.getAttribute('maxsize')
						self.protocols[ref].maxsize = maxsize
					else:
						raise RpcException("state " + name + "'s reference a protocol '" + ref + "' which doest not have 'maxsize' attribute!")
				if DEBUG_MODE:
					print "\t", ref
				state.addProtocolRef(ref)
			else:
				raise RpcException("state " + name + "'s reference a protocol '" + ref + "' which is not defined'")
		if DEBUG_MODE:
			print "  Rpcs:"
		vars = node.getElementsByTagName('rpc')
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('ref'):
				raise RpcException("state " + name + "'s some rpc does not have attribute 'ref'")
			ref = var.getAttribute('ref')
			if ref in self.rpcs.keys():
				if DEBUG_MODE:
					print "\t", ref
				state.addRpcRef(ref)
			else:
				raise RpcException("state " + name + "'s reference a rpc '" + ref + "' which is not defined'")
		service.addState(state)
	def do_service(self, node):
		if 'name' not in node.attributes.keys():
			raise RpcException("Some service does not have attribute 'name'")
		name = node.attributes['name'].value
		service = Service(name)
		if not os.path.isfile(name + os.sep + 'service.xml'):
			print "\033[1;33;5mWarn:  \033[0m" + name + os.sep + 'service.xml' + " does not exist, so we don't generate this service"
			return
		sesock = openAnything(name + os.sep + 'service.xml')
		servicexml = minidom.parse(sesock).documentElement
		oldnode = node
		node = servicexml
		if DEBUG_MODE:
			print " Loading service", name, "..."
			print " ", service
		if DEBUG_MODE:
			print "  States:"
		vars = node.getElementsByTagName('state')
		for var in vars:
			if var.parentNode == node:
				self.do_state(var, service)
		if DEBUG_MODE:
			print "  Managers:"
		vars = node.getElementsByTagName('manager')
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('name'):
				raise RpcException("Service " + name + "'s some manager does not have attribute 'name'")
			varname = var.getAttribute('name')
			if not var.hasAttribute('type'):
				raise RpcException("Service " + name + "'s manager '" + varname + "' does not have attribute 'type'")
			vartype = var.getAttribute('type')
			if not var.hasAttribute('initstate'):
				raise RpcException("Service " + name + "'s manager '" + varname + "' does not have attribute 'initstate'")
			varinitstate = var.getAttribute('initstate')
			if varinitstate not in service.states.keys():
				raise RpcException("Manager " + varname + "'s initstate '" + varinitstate + "' in service '" + name + "' is not defined")
			manager = Manager(varname, vartype, varinitstate)
			if var.hasAttribute('reconnect'):
				manager.reconnect = var.getAttribute('reconnect')
			service.addManager(manager)
		if DEBUG_MODE:
			print "  Protocols:"
		vars = node.getElementsByTagName('protocol')
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('ref'):
				raise RpcException("Service " + name + "'s some protocol does not have attribute 'ref'")
			ref = var.getAttribute('ref')
			if ref in self.protocols.keys():
				if ref == 'BINDER' or ref == 'COMPRESSBINDER':
					if var.hasAttribute('maxsize'):
						maxsize = var.getAttribute('maxsize')
						self.protocols[ref].maxsize = maxsize
					else:
						raise RpcException("Service " + name + "'s reference a protocol '" + ref + "' which doest not have 'maxsize' attribute!")
				if DEBUG_MODE:
					print "\t", ref
				service.addProtocolRef(ref)
			else:
				raise RpcException("Service " + name + "'s reference a protocol '" + ref + "' which is not defined'")
		if DEBUG_MODE:
			print "  Rpcs:"
		vars = node.getElementsByTagName('rpc')
		for var in vars:
			if var.parentNode != node:
				continue
			if not var.hasAttribute('ref'):
				raise RpcException("Service " + name + "'s some rpc does not have attribute 'ref'")
			ref = var.getAttribute('ref')
			if ref in self.rpcs.keys():
				servicerpc = ServiceRpc(self.rpcs[ref])
				if var.hasAttribute('baseclass'):
					baseclass = var.getAttribute('baseclass')
					if baseclass != 'Rpc':
						if not var.hasAttribute('sendmanager'):
							raise RpcException("Service " + name + "'s rpc '" + ref + "' does not have attribute 'sendmanager'")
						sendmanager = var.getAttribute('sendmanager')
						if not service.hasSendManager(sendmanager):
							raise RpcException("Service " + name + "'s rpc '" + ref + "' has a sendmanager '" + sendmanager + "' which is not defined")
						servicerpc.sendmanager = service.getSendManager(sendmanager)
					servicerpc.baseclass = baseclass
				if DEBUG_MODE:
					print "\t", servicerpc
				service.addServiceRpc(servicerpc)
			else:
				raise RpcException("Service " + name + "'s reference a rpc '" + ref + "' which is not defined")
		self.addService(service)
		print service
	def generate(self):
		print "Generating project", self.project, "..."
		
		print " Generating rpcdatas in " + RPCDATA_DIR, "..."
		self.generate_rpcdata()
		print " Generating inls in " + INL_DIR, "..."
		self.generate_inl()
		for service in self.services.values():
			print "  Generating service", service.name, "..."
			self.generate_service_protocol(service)
			self.generate_service_rpc(service)
			self.generate_service_state(service)
			self.generate_service_stubs(service)
			self.generate_service_manager(service)
			self.generate_service_main(service)
			self.generate_service_makefile(service)
	def need_generate(self, name):
		if name == 'RpcRetcode' or name == 'BINDER' or name == 'COMPRESSBINDER':
			return False
		return True
	def generate_rpcdata(self):
		if not os.path.isdir(RPCDATA_DIR):
			os.mkdir(RPCDATA_DIR)
		for rpcdata in self.rpcdatas.values():
			if self.need_generate(rpcdata.name):
				str = rpcdata.toCPP(self.namespace, self.rpcdatas)
				rpcdatafile = file(RPCDATA_DIR + os.sep + rpcdata.name.lower(), 'wb')
				rpcdatafile.write(str.encode('UTF-8'))
				rpcdatafile.close()
				#print str
	def generate_inl(self):
		if not os.path.isdir(INL_DIR):
			os.mkdir(INL_DIR)
		for inl in self.protocols.values() + self.rpcs.values():
			if self.need_generate(inl.name):
				str = inl.toInl()
				inlfile = file(INL_DIR + os.sep + inl.name.lower(), 'wb')
				inlfile.write(str.encode('UTF-8'))
				inlfile.close()
				#print str
	def generate_service_protocol(self, service):
		if service.name == 'gdeliveryd' or service.name == 'glinkd' :
			SERVICE_DIR = service.name + os.sep + "protocol"
		else:
			SERVICE_DIR = service.name
		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		for pref in service.protocols:
			if self.need_generate(pref):
				if pref not in self.protocols.keys():
					raise RpcException("Protocol '" + pref + "' in Service '" + service.name + "' is not defined")
				p = self.protocols[pref]
				if not os.path.isfile(SERVICE_DIR + os.sep + p.name.lower() + u".hpp"):
					str = p.toHpp(self.namespace, service, self.rpcdatas)
					hppfile = file(SERVICE_DIR + os.sep + p.name.lower() + u".hpp", 'wb')
					hppfile.write(str.encode('UTF-8'))
					hppfile.close()
					#print str
		for state in service.states.values():
			for pref in state.protocols:
				if self.need_generate(pref):
					if pref not in self.protocols.keys():
						raise RpcException("Protocol '" + pref + "' in State '" + state.name + "' is not defined")
					p = self.protocols[pref]
					if not os.path.isfile(SERVICE_DIR + os.sep + p.name.lower() + u".hpp"):
						str = p.toHpp(self.namespace, service, self.rpcdatas)
						hppfile = file(SERVICE_DIR + os.sep + p.name.lower() + u".hpp", 'wb')
						hppfile.write(str.encode('UTF-8'))
						hppfile.close()
						#print str
	def generate_service_rpc(self, service):
		if service.name == 'gdeliveryd' or service.name == 'glinkd' :
			SERVICE_DIR = service.name + os.sep + "protocol"
		else:
			SERVICE_DIR = service.name

		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		for serpc in service.rpcs.values():
			if self.need_generate(serpc.rpc.name):
				if not os.path.isfile(SERVICE_DIR + os.sep + serpc.rpc.name.lower() + u".hrp"):
					if serpc.baseclass == 'ProxyRpc':
						str = serpc.toProxyHrp(self.namespace, service.getSendManager(serpc.sendmanager))
					else:
						str = serpc.toHrp(self.namespace)
					hrpfile = file(SERVICE_DIR + os.sep + serpc.rpc.name.lower() + u".hrp", 'wb')
					hrpfile.write(str.encode('UTF-8'))
					hrpfile.close()
					#print str
		for state in service.states.values():
			for rpcname in state.rpcs:
				if self.need_generate(rpcname):
					if rpcname not in self.rpcs.keys():
						raise RpcException("Rpc '" + rpcname + "' in State '" + state.name + "' is not defined")
					rpc = self.rpcs[rpcname]
					if not os.path.isfile(SERVICE_DIR + os.sep + rpc.name.lower() + u".hrp"):
						serpc = ServiceRpc(rpc)
						str = serpc.toHrp(self.namespace)
						hrpfile = file(SERVICE_DIR + os.sep + rpc.name.lower() + u".hrp", 'wb')
						hrpfile.write(str.encode('UTF-8'))
						hrpfile.close()
						#print str
	def generate_service_state(self, service):
		if service.name == 'gdeliveryd' or service.name == 'glinkd' :
			SERVICE_DIR = service.name + os.sep + "protocol"
		else:
			SERVICE_DIR = service.name

		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		statehxx = file(SERVICE_DIR + os.sep + "state.hxx", 'wb')
		statecxx = file(SERVICE_DIR + os.sep + "state.cxx", 'wb')
		#state.hxx
		statehxx.write("#ifndef __" + self.namespace.upper() + "_" + service.name.upper() + "_STATE" + os.linesep)
		statehxx.write("#define __" + self.namespace.upper() + "_" + service.name.upper() + "_STATE" + os.linesep)
		statehxx.write(os.linesep)
		statehxx.write("#ifdef WIN32" + os.linesep)
		statehxx.write('#include "gnproto.h"' + os.linesep)
		statehxx.write('#else' + os.linesep)
		statehxx.write('#include "protocol.h"' + os.linesep)
		statehxx.write('#endif' + os.linesep)
		statehxx.write(os.linesep)
		statehxx.write("namespace " + self.namespace + os.linesep)
		statehxx.write("{" + os.linesep)
		statehxx.write(os.linesep)
		#state.cxx
		statecxx.write('#include "callid.hxx"' + os.linesep)
		statecxx.write(os.linesep)
		statecxx.write('#ifdef WIN32' + os.linesep)
		statecxx.write('#include <winsock2.h>' + os.linesep)
		statecxx.write('#include "gnproto.h"' + os.linesep)
		statecxx.write('#include "gncompress.h"' + os.linesep)
		statecxx.write('#else' + os.linesep)
		statecxx.write('#include "protocol.h"' + os.linesep)
		statecxx.write('#include "binder.h"' + os.linesep)
		statecxx.write('#endif' + os.linesep)
		statecxx.write(os.linesep)
		statecxx.write("namespace " + self.namespace + os.linesep)
		statecxx.write("{" + os.linesep)
		statecxx.write(os.linesep)
		for state in service.states.values():
			#state.hxx
			statehxx.write("extern GNET::Protocol::Manager::Session::State state_" + state.name + ";" + os.linesep + os.linesep)
			#state.cxx
			statecxx.write("static GNET::Protocol::Type _state_" + state.name + "[] = " + os.linesep)
			statecxx.write("{" + os.linesep)
			for prot in state.protocols:
				statecxx.write("\tPROTOCOL_" + prot.upper() + "," + os.linesep)
			for rpc in state.rpcs:
				statecxx.write("\tRPC_" + rpc.upper() + "," + os.linesep)
			statecxx.write("};" + os.linesep)
			statecxx.write(os.linesep)
			statecxx.write("GNET::Protocol::Manager::Session::State state_" + state.name + "(_state_" + state.name + "," + os.linesep)
			statecxx.write("\t\t\t\t\t\tsizeof(_state_" + state.name + ")/sizeof(GNET::Protocol::Type), " + state.timeout + ");" + os.linesep)
			statecxx.write(os.linesep)
		statehxx.write("};" + os.linesep + os.linesep + "#endif" + os.linesep)
		statecxx.write("};" + os.linesep + os.linesep)
		statehxx.close()
		statecxx.close()
	def get_stub_cxx_file(self, dir, num):
		if num <= 1 :
			stubscxx = file(dir + os.sep + "stubs.cxx", 'wb')
		else: stubscxx = file(dir + os.sep + "stubs" + '%d'%num + ".cxx", 'wb')
		stubscxx.write('#include "stubs.hxx"' + os.linesep)
		stubscxx.write("namespace " + self.namespace + os.linesep)
		stubscxx.write("{" + os.linesep)
		stubscxx.write(os.linesep)
		return stubscxx
	def close_stub_cxx_file(self, stubscxx):
		stubscxx.write("};" + os.linesep + os.linesep)
		stubscxx.close()
	def generate_service_stubs(self, service):
		#print "generate_service_stubs begin..."
		IS_LINK = False
		if service.name == 'gdeliveryd' :
			SERVICE_DIR = service.name + os.sep + "protocol"
		elif service.name == 'glinkd' :
			SERVICE_DIR = service.name + os.sep + "protocol"
			IS_LINK = True
		else:
			SERVICE_DIR = service.name

		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		callidhxx = file(SERVICE_DIR + os.sep + "callid.hxx", 'wb')
		#callid.hxx
		callidhxx.write("#ifndef __" + self.namespace.upper() + "_" + service.name.upper() + "_CALLID" + os.linesep)
		callidhxx.write("#define __" + self.namespace.upper() + "_" + service.name.upper() + "_CALLID" + os.linesep)
		callidhxx.write(os.linesep)
		callidhxx.write("namespace " + self.namespace + os.linesep)
		callidhxx.write("{" + os.linesep)
		callidhxx.write(os.linesep)
		callidhxx.write("enum CallID" + os.linesep + "{" + os.linesep)
		addlist = []
		#stubs.hxx
		stubshxx = file(SERVICE_DIR + os.sep + "stubs.hxx", 'wb')
		stubshxx.write("#ifdef WIN32" + os.linesep)
		stubshxx.write("#include <winsock2.h>" + os.linesep)
		stubshxx.write('#include "gncompress.h"' + os.linesep)
		stubshxx.write('#else' + os.linesep)
		stubshxx.write('#include "binder.h"' + os.linesep)
		stubshxx.write('#endif' + os.linesep + os.linesep)

		for serpc in service.rpcs.values():
			if self.need_generate(serpc.rpc.name) and serpc.rpc.name not in addlist:
				callidhxx.write("\tRPC_" + serpc.rpc.name.upper() + "\t=\t" + serpc.rpc.type + "," + os.linesep)
				stubshxx.write('#include "' + serpc.rpc.name.lower() + '.hrp"' + os.linesep)
				addlist.append(serpc.rpc.name)
		for state in service.states.values():
			for rpcname in state.rpcs:
				if self.need_generate(rpcname) and rpcname not in addlist:
					if rpcname not in self.rpcs.keys():
						raise RpcException("Rpc '" + rpcname + "' in State '" + state.name + "' is not defined")
					rpc = self.rpcs[rpcname]
					callidhxx.write("\tRPC_" + rpc.name.upper() + "\t=\t" + rpc.type + "," + os.linesep)
					stubshxx.write('#include "' + rpc.name.lower() + '.hrp"' + os.linesep)
					addlist.append(rpc.name)
		callidhxx.write("};" + os.linesep + os.linesep)
		addlist = []
		callidhxx.write("enum ProtocolType" + os.linesep + "{" + os.linesep)
		for protname in service.protocols:
			if self.need_generate(protname) and protname not in addlist:
				if protname not in self.protocols.keys():
					raise RpcException("Protocol '" + protname + "' in Service '" + service.name + "' is not defined")
				p = self.protocols[protname]
				callidhxx.write("\tPROTOCOL_" + p.name.upper() + "\t=\t" + p.type + "," + os.linesep)
				stubshxx.write('#include "' + p.name.lower() + '.hpp"' + os.linesep)
				addlist.append(p.name)
		for state in service.states.values():
			for protname in state.protocols:
				if self.need_generate(protname) and protname not in addlist:
					if protname not in self.protocols.keys():
						raise RpcException("Protocol '" + protname + "' in State '" + state.name + "' is not defined")
					p = self.protocols[protname]
					callidhxx.write("\tPROTOCOL_" + p.name.upper() + "\t=\t" + p.type + "," + os.linesep)
					stubshxx.write('#include "' + p.name.lower() + '.hpp"' + os.linesep)
					addlist.append(p.name)
		callidhxx.write("};" + os.linesep + os.linesep)
		callidhxx.write("};" + os.linesep + os.linesep + "#endif" + os.linesep)
		callidhxx.close()
		#stubs.cxx
		stubshxx.write(os.linesep)
		stubshxx.close()
		addlist = []
		stubcxx_num = 1
		protocol_num = 0
		max_num_one_file = 50
		stubscxx = self.get_stub_cxx_file(SERVICE_DIR, stubcxx_num)
		#print "generate_service_stubs rpc..." + '%d'%protocol_num + " " + '%d'%stubcxx_num
		for serpc in service.rpcs.values():
			if self.need_generate(serpc.rpc.name) and serpc.rpc.name not in addlist:
				protocol_num = protocol_num + 1
				rpc = serpc.rpc
				str = 'static ' + rpc.name + ' __stub_' + rpc.name + " (RPC_" + rpc.name.upper() + ", new "
				if rpc.argument != '':
					str += rpc.argument + ", new "
				else:
					str += rpc.name + "Arg, new "
				if rpc.result != '':
					str += rpc.result + ");" + os.linesep
				else:
					str += rpc.name + "Res);" + os.linesep
				stubscxx.write(str)
				if protocol_num > max_num_one_file and IS_LINK:
					self.close_stub_cxx_file(stubscxx)
					stubcxx_num = stubcxx_num + 1
					stubscxx = self.get_stub_cxx_file(SERVICE_DIR, stubcxx_num)
					protocol_num = 0
				addlist.append(serpc.rpc.name)
		for state in service.states.values():
			for rpcname in state.rpcs:
				if self.need_generate(rpcname) and rpcname not in addlist:
					if rpcname not in self.rpcs.keys():
						raise RpcException("Rpc '" + rpcname + "' in State '" + state.name + "' is not defined")
					protocol_num = protocol_num + 1
					rpc = self.rpcs[rpcname]
					str = 'static ' + rpc.name + ' __stub_' + rpc.name + " (RPC_" + rpc.name.upper() + ", new "
					if rpc.argument != '':
						str += rpc.argument + ", new "
					else:
						str += rpc.name + "Arg, new "
					if rpc.result != '':
						str += rpc.result + ");" + os.linesep
					else:
						str += rpc.name + "Res);" + os.linesep
					stubscxx.write(str)
					if protocol_num > max_num_one_file and IS_LINK:
						self.close_stub_cxx_file(stubscxx)
						stubcxx_num = stubcxx_num + 1
						stubscxx = self.get_stub_cxx_file(SERVICE_DIR, stubcxx_num)
						protocol_num = 0
					addlist.append(rpc.name)

		#print "generate_service_stubs protocol..." + '%d'%protocol_num + " " + '%d'%stubcxx_num
		for protname in service.protocols:
			if protname not in addlist:
				protocol_num = protocol_num + 1
				if protname != 'BINDER' and protname != 'COMPRESSBINDER':
					if protname not in self.protocols.keys():
						raise RpcException("Protocol '" + protname + "' in Service '" + service.name + "' is not defined")
					p = self.protocols[protname]
					stubscxx.write('static ' + p.name + " __stub_" + p.name + "((void*)0);" + os.linesep)
				elif protname == 'BINDER':
					stubscxx.write("#ifndef WIN32" + os.linesep)
					stubscxx.write("static ProtocolBinder __ProtocolBinder_stub(PROTOCOL_BINDER, " + p.maxsize + ");" + os.linesep)
					stubscxx.write("#endif" + os.linesep)
				elif protname == 'COMPRESSBINDER':
					stubscxx.write("#ifndef WIN32" + os.linesep)
					stubscxx.write("static CompressBinder __CompressBinder_stub(PROTOCOL_COMPRESSBINDER, " + p.maxsize + ");" + os.linesep)
					stubscxx.write("#endif" + os.linesep)

				if protocol_num > max_num_one_file and IS_LINK:
					self.close_stub_cxx_file(stubscxx)
					stubcxx_num = stubcxx_num + 1
					stubscxx = self.get_stub_cxx_file(SERVICE_DIR, stubcxx_num)
					protocol_num = 0

				addlist.append(protname)
		#print "generate_service_stubs protocol state..." + '%d'%protocol_num + " " + '%d'%stubcxx_num
		for state in service.states.values():
			for protname in state.protocols:
				if protname not in addlist:
					protocol_num = protocol_num + 1
					if protname != 'BINDER' and protname != 'COMPRESSBINDER':
						if protname not in self.protocols.keys():
							raise RpcException("Protocol '" + protname + "' in State '" + state.name + "' is not defined")
						p = self.protocols[protname]
						stubscxx.write('static ' + p.name + " __stub_" + p.name + " ((void*)0);" + os.linesep)
					elif protname == 'BINDER':
						stubscxx.write("#ifndef WIN32" + os.linesep)
						stubscxx.write("static ProtocolBinder __ProtocolBinder_stub(PROTOCOL_BINDER, " + p.maxsize + ");" + os.linesep)
						stubscxx.write("#endif" + os.linesep)
					elif protname == 'COMPRESSBINDER':
						stubscxx.write("#ifndef WIN32" + os.linesep)
						stubscxx.write("static CompressBinder __CompressBinder_stub(PROTOCOL_COMPRESSBINDER, " + p.maxsize + ");" + os.linesep)
						stubscxx.write("#endif" + os.linesep)
					if protocol_num > max_num_one_file and IS_LINK:
						self.close_stub_cxx_file(stubscxx)
						stubcxx_num = stubcxx_num + 1
						stubscxx = self.get_stub_cxx_file(SERVICE_DIR, stubcxx_num)
						protocol_num = 0
					addlist.append(protname)
		stubscxx.write("};" + os.linesep + os.linesep)
		stubscxx.close()
		#print "generate_service_stubs successed..."
	def generate_service_manager(self, service):
		if service.name == 'gdeliveryd' or service.name == 'glinkd' :
			SERVICE_DIR = service.name + os.sep + "protocol"
		else:
			SERVICE_DIR = service.name

		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		for manager in service.managers.values():
			managerfilename = manager.name.lower() + manager.type.lower()
			classname = manager.name + manager.type.capitalize()
			if not os.path.isfile(SERVICE_DIR + os.sep + managerfilename + ".hpp"):
				managerhpp = file(SERVICE_DIR + os.sep + managerfilename + ".hpp", 'wb')
				if manager.type.lower() == 'client':
					managerhpp.write("#ifndef __" + self.namespace.upper() + "_" + manager.name.upper() + manager.type.upper() + "_HPP" + os.linesep)
					managerhpp.write("#define __" + self.namespace.upper() + "_" + manager.name.upper() + manager.type.upper() + "_HPP" + os.linesep)
					managerhpp.write('#include "protocol.h"' + os.linesep)
					managerhpp.write('#include "thread.h"' + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("namespace " + self.namespace + os.linesep)
					managerhpp.write("{" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("class " + manager.name + manager.type.capitalize() + " : public Protocol::Manager" + os.linesep)
					managerhpp.write("{" + os.linesep)
					managerhpp.write("\tstatic " + manager.name + manager.type.capitalize() + " instance;" + os.linesep)
					managerhpp.write("\tsize_t\taccumulate_limit;" + os.linesep)
					managerhpp.write("\tSession::ID\tsid;" + os.linesep)
					managerhpp.write("\tbool\tconn_state;" + os.linesep)
					managerhpp.write("\tThread::Mutex\tlocker_state;" + os.linesep)
					if manager.reconnect == '1':
						managerhpp.write("\tenum { BACKOFF_INIT = 2, BACKOFF_DEADLINE = 256 };" + os.linesep)
						managerhpp.write("\tsize_t\tbackoff;" + os.linesep)
						managerhpp.write("\tvoid Reconnect();" + os.linesep)
					managerhpp.write("\tconst Session::State *GetInitState() const;" + os.linesep)
					managerhpp.write("\tbool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }" + os.linesep)
					managerhpp.write("\tvoid OnAddSession(Session::ID sid);" + os.linesep)
					managerhpp.write("\tvoid OnDelSession(Session::ID sid);" + os.linesep)
					managerhpp.write("\tvoid OnAbortSession(const SockAddr &sa);" + os.linesep)
					managerhpp.write("\tvoid OnCheckAddress(SockAddr &) const;" + os.linesep)
					managerhpp.write("public:" + os.linesep)
					managerhpp.write("\tstatic " + classname + "* GetInstance() { return &instance; }" + os.linesep)
					managerhpp.write('\tstd::string Identification() const { return "' + classname + '"; }' + os.linesep)
					managerhpp.write("\tvoid SetAccumulate(size_t size) { accumulate_limit = size; }" + os.linesep)
					if manager.reconnect == '1':
						managerhpp.write("\t" + classname + '() : accumulate_limit(0), conn_state(false), locker_state("' + classname + "::locker_state" + '"), backoff(BACKOFF_INIT) { }' + os.linesep)
					else:
						managerhpp.write("\t" + classname + '() : accumulate_limit(0), conn_state(false), locker_state("' + classname + "::locker_state" + '") { }' + os.linesep)
					managerhpp.write("\tbool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }" + os.linesep)
					managerhpp.write("\tbool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }" + os.linesep)
					managerhpp.write("\tbool SendProtocol(\tProtocol &protocol) { return conn_state && Send(sid, protocol); }" + os.linesep)
					managerhpp.write("\tbool SendProtocol(\tProtocol *protocol) { return conn_state && Send(sid, protocol); }" + os.linesep)
					managerhpp.write("};" + os.linesep)
					managerhpp.write("};" + os.linesep)
					managerhpp.write("#endif" + os.linesep)
				elif manager.type.lower() == 'server':
					managerhpp.write("#ifndef __" + self.namespace.upper() + "_" + manager.name.upper() + manager.type.upper() + "_HPP" + os.linesep)
					managerhpp.write("#define __" + self.namespace.upper() + "_" + manager.name.upper() + manager.type.upper() + "_HPP" + os.linesep)
					managerhpp.write('#include "protocol.h"' + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("namespace " + self.namespace + os.linesep)
					managerhpp.write("{" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("class " + manager.name + manager.type.capitalize() + " : public Protocol::Manager" + os.linesep)
					managerhpp.write("{" + os.linesep)
					managerhpp.write("\tstatic " + manager.name + manager.type.capitalize() + " instance;" + os.linesep)
					managerhpp.write("\tsize_t\taccumulate_limit;" + os.linesep)
					managerhpp.write("\tconst Session::State *GetInitState() const;" + os.linesep)
					managerhpp.write("\tbool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }" + os.linesep)
					managerhpp.write("\tvoid OnAddSession(Session::ID sid);" + os.linesep)
					managerhpp.write("\tvoid OnDelSession(Session::ID sid);" + os.linesep)
					managerhpp.write("public:" + os.linesep)
					classname = manager.name + manager.type.capitalize()
					managerhpp.write("\tstatic " + classname + "* GetInstance() { return &instance; }" + os.linesep)
					managerhpp.write('\tstd::string Identification() const { return "' + classname + '"; }' + os.linesep)
					managerhpp.write("\tvoid SetAccumulate(size_t size) { accumulate_limit = size; }" + os.linesep)
					managerhpp.write("\t" + classname + '() : accumulate_limit(0) { }' + os.linesep)
					managerhpp.write("};" + os.linesep)
					managerhpp.write("};" + os.linesep)
					managerhpp.write("#endif" + os.linesep)
				else:
					raise RpcException("Manager '" + manager.name + "' in Service '" + service.name + "' has unknown 'type' attribute")
				managerhpp.close()
			if not os.path.isfile(SERVICE_DIR + os.sep + managerfilename + ".cpp"):
				managercpp = file(SERVICE_DIR + os.sep + managerfilename + ".cpp", 'wb')
				if manager.type.lower() == 'client':
					managercpp.write('#include "' + managerfilename + '.hpp"' + os.linesep)
					managercpp.write('#include "state.hxx"' + os.linesep)
					if manager.reconnect == '1':
						managercpp.write('#include "timertask.h"' + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("namespace " + self.namespace + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write(classname + " " + classname + "::instance;" + os.linesep)
					managercpp.write(os.linesep)
					if manager.reconnect == '1':
						managercpp.write("void " + classname + "::Reconnect()" + os.linesep)
						managercpp.write("{" + os.linesep)
						managercpp.write("\tThread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);" + os.linesep)
						managercpp.write("\tbackoff *= 2;" + os.linesep)
						managercpp.write("\tif (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;" + os.linesep)
						managercpp.write("}" + os.linesep)
						managercpp.write(os.linesep)
					managercpp.write("const Protocol::Manager::Session::State* " + classname + "::GetInitState() const" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\treturn &state_" + manager.initstate + ";" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("void " + classname + "::OnAddSession(Session::ID sid)" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\tThread::Mutex::Scoped l(locker_state);" + os.linesep)
					managercpp.write("\tif (conn_state)" + os.linesep)
					managercpp.write("\t{" + os.linesep)
					managercpp.write("\t\tClose(sid);" + os.linesep) 
					managercpp.write("\t\treturn;" + os.linesep)
					managercpp.write("\t}" + os.linesep)
					managercpp.write("\tconn_state = true;" + os.linesep)
					managercpp.write("\tthis->sid = sid;" + os.linesep)
					if manager.reconnect == '1':
						managercpp.write("\tbackoff = BACKOFF_INIT;" + os.linesep)
					managercpp.write("\t//TODO" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("void " + classname + "::OnDelSession(Session::ID sid)" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\tThread::Mutex::Scoped l(locker_state);" + os.linesep)
					managercpp.write("\tconn_state = false;" + os.linesep)
					if manager.reconnect == '1':
						managercpp.write("\tReconnect();" + os.linesep)
					managercpp.write("\t//TODO" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("void " + classname + "::OnAbortSession(const SockAddr &sa)" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\tThread::Mutex::Scoped l(locker_state);" + os.linesep)
					managercpp.write("\tconn_state = false;" + os.linesep)
					if manager.reconnect == '1':
						managercpp.write("\tReconnect();" + os.linesep)
					managercpp.write("\t//TODO" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("void " + classname + "::OnCheckAddress(SockAddr &sa) const" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\t//TODO" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("};" + os.linesep)
				elif manager.type.lower() == 'server':
					managercpp.write('#include "' + managerfilename + '.hpp"' + os.linesep)
					managercpp.write('#include "state.hxx"' + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("namespace " + self.namespace + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write(classname + " " + classname + "::instance;" + os.linesep)
					managercpp.write("const Protocol::Manager::Session::State* " + classname + "::GetInitState() const" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\treturn &state_" + manager.initstate + ";" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("void " + classname + "::OnAddSession(Session::ID sid)" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\t//TODO" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("void " + classname + "::OnDelSession(Session::ID sid)" + os.linesep)
					managercpp.write("{" + os.linesep)
					managercpp.write("\t//TODO" + os.linesep)
					managercpp.write("}" + os.linesep)
					managercpp.write(os.linesep)
					managercpp.write("};" + os.linesep)
				else:
					raise RpcException("Manager '" + manager.name + "' in Service '" + service.name + "' has unknown 'type' attribute")
				managercpp.close()
	def generate_service_main(self, service):
		SERVICE_DIR = service.name
		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		if not os.path.isfile(SERVICE_DIR + os.sep + service.name.lower() + ".cpp"):
			maincpp = file(SERVICE_DIR + os.sep + service.name.lower() + ".cpp", 'wb')
			maincpp.write('#include "conf.h"' + os.linesep)
			maincpp.write('#include "log.h"' + os.linesep)
			maincpp.write('#include "pollio.h"' + os.linesep)
			maincpp.write('#include "thread.h"' + os.linesep)
			maincpp.write('#include <iostream>' + os.linesep)
			maincpp.write('#include <unistd.h>' + os.linesep)
			maincpp.write(os.linesep)
			for manager in service.managers.values():
				classname = manager.name + manager.type.capitalize()
				maincpp.write('#include "' + classname.lower() + '.hpp"' + os.linesep)
			maincpp.write(os.linesep)
			maincpp.write("using namespace " + self.namespace + ";" + os.linesep)
			maincpp.write(os.linesep)
			maincpp.write("int main(int argc, char *argv[])" + os.linesep)
			maincpp.write("{" + os.linesep)
			maincpp.write("\tif (argc != 2 || access(argv[1], R_OK) == -1)" + os.linesep)
			maincpp.write("\t{" + os.linesep)
			maincpp.write('\t\tstd::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;' + os.linesep)
			maincpp.write("\t\texit(-1);" + os.linesep)
			maincpp.write("\t}" + os.linesep)
			maincpp.write(os.linesep)
			maincpp.write("\tConf *conf = Conf::GetInstance(argv[1]);" + os.linesep)
			maincpp.write('\tLog::setprogname("' + service.name + '");' + os.linesep)
			for manager in service.managers.values():
				classname = manager.name + manager.type.capitalize()
				maincpp.write("\t{" + os.linesep)
				maincpp.write("\t\t" + classname + "* manager = " + classname + "::GetInstance();" + os.linesep)
				maincpp.write('\t\tmanager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));' + os.linesep)
				maincpp.write("\t\tProtocol::" + manager.type.capitalize() + "(manager);" + os.linesep)
				maincpp.write("\t}" + os.linesep)
			maincpp.write(os.linesep)
			maincpp.write("\tThread::Pool::AddTask(PollIO::Task::GetInstance());" + os.linesep)
			maincpp.write("\tThread::Pool::Run();" + os.linesep)
			maincpp.write("\treturn 0;" + os.linesep)
			maincpp.write("}" + os.linesep)
			maincpp.write(os.linesep)
	def generate_service_makefile(self, service):
		SERVICE_DIR = service.name
		if not os.path.isdir(SERVICE_DIR):
			os.mkdir(SERVICE_DIR)
		if not os.path.isfile(SERVICE_DIR + os.sep + "Makefile"):
			if service.name == 'gdeliveryd' or service.name == 'glinkd' :
				PROTOCOL_DIR = 'protocol/'
			else:
			     	PROTOCOL_DIR = ''
			objs = []
			for manager in service.managers.values():
				managerfilename = manager.name.lower() + manager.type.lower()
				objs.append(PROTOCOL_DIR + managerfilename + ".o")
			objs += [PROTOCOL_DIR + 'stubs.o', PROTOCOL_DIR + 'state.o', service.name + '.o']
			makefile = file(SERVICE_DIR + os.sep + "Makefile", 'wb')
			makefile.write("TOP_SRCDIR = .." + os.linesep)
			makefile.write(os.linesep)
			makefile.write("SINGLE_THREAD = true" + os.linesep)
			makefile.write("DEBUG_VERSION = false" + os.linesep)
			makefile.write(os.linesep)
			makefile.write("include ../mk/gcc.defs.mk" + os.linesep)
			makefile.write(os.linesep)
			makefile.write("INCLUDES += -I$(TOP_SRCDIR)/include" + os.linesep)			  
			makefile.write(os.linesep)
			makefile.write("OBJS = ");
			for obj in objs:
				makefile.write(obj + " ")
			makefile.write(os.linesep)
			makefile.write(os.linesep)
			makefile.write("all : " + service.name + os.linesep);
			makefile.write(os.linesep)
			makefile.write(service.name + ' : $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ)' + os.linesep);
			makefile.write("\t$(LD) $(LDFLAGS) -o $@ $(OBJS) $(SHAREOBJ) $(SHARE_SOBJ)" + os.linesep);
			makefile.write(os.linesep)
			makefile.write("include ../mk/gcc.rules.mk")
			makefile.close()
	def toasclient(self):
		print "Generating to Action Script Client file ..."
		if 'client' not in self.services.keys():
			raise RpcException("client service is not defined!")
		#检查没有rpc
		#TODO 遍历一遍protocol，得到其中的rpcdata，然后再得到rpcdata中的rpcdata，然后将这个列表先输出，然后再输出protocol
		#输出state
		client = self.services['client']
		if len(client.rpcs) != 0:
			raise RpcException("client must have no rpcs!")
		GCLIENT_DIR = 'client' + os.sep + 'gnetnew'
		if not os.path.isdir(GCLIENT_DIR):
			os.mkdir(GCLIENT_DIR)
		if not os.path.isdir(GCLIENT_DIR + os.sep + 'beans'):
			os.mkdir(GCLIENT_DIR + os.sep + 'beans')
		protocollist = {}
		for protname in client.protocols:
			if protname not in self.protocols.keys():
				raise RpcException("client's protocol '" + protname + "' is not defined")
			protocol = self.protocols[protname]
			rpcdatanames = protocol.getRpcDatas(self.rpcdatas)
			#print "debug: " + protocol.name
			#print rpcdatanames
			for rpcdataname in rpcdatanames:
				if rpcdataname not in self.rpcdatas.keys():
					raise RpcException("client's rpcdata '" + rpcdataname + "' is not defined!")
				rpcdata = self.rpcdatas[rpcdataname]
				for rpcdatainname in rpcdata.getRpcDatas(self.rpcdatas):
					if rpcdatainname not in self.rpcdatas.keys():
						raise RpcException("client's rpcdata '" + rpcdatainname + "' is not defined!")
					rpcdatain = self.rpcdatas[rpcdatainname]
					str = rpcdatain.toAS(self.project.lower(), self.rpcdatas)
					rpcdatainfile = file(GCLIENT_DIR + os.sep + 'beans' + os.sep + rpcdatainname + ".as", 'wb')
					rpcdatainfile.write(str.encode('UTF-8'))
					rpcdatainfile.close()
				str = rpcdata.toAS(self.project.lower(), self.rpcdatas)
				rpcdatafile = file(GCLIENT_DIR + os.sep + 'beans' + os.sep + rpcdataname + ".as", 'wb')
				rpcdatafile.write(str.encode('UTF-8'))
				rpcdatafile.close()
			#print "debug: " + protocol.name
			str = protocol.toAS(self.project.lower(), self.rpcdatas)
			if protname != 'ClientNeedRpcDatas':
				protocollist[protocol.name] = protocol.type
			protocolfile = file(GCLIENT_DIR + os.sep + protocol.name + ".as", 'wb')
			protocolfile.write(str.encode('UTF-8'))
			protocolfile.close()
		for state in client.states.values():
			for protname in state.protocols:
				if protname not in self.protocols.keys():
					raise RpcException("client's protocol '" + protname + "' is not defined")
				protocol = self.protocols[protname]
				rpcdatanames = protocol.getRpcDatas(self.rpcdatas)
				#print "debug: " + protocol.name
				#print rpcdatanames
				for rpcdataname in rpcdatanames:
					if rpcdataname not in self.rpcdatas.keys():
						raise RpcException("client's rpcdata '" + rpcdataname + "' is not defined!")
					rpcdata = self.rpcdatas[rpcdataname]
					for rpcdatainname in rpcdata.getRpcDatas(self.rpcdatas):
						if rpcdatainname not in self.rpcdatas.keys():
							raise RpcException("client's rpcdata '" + rpcdatainname + "' is not defined!")
						rpcdatain = self.rpcdatas[rpcdatainname]
						str = rpcdatain.toAS(self.project.lower(), self.rpcdatas)
						rpcdatainfile = file(GCLIENT_DIR + os.sep + 'beans' + os.sep + rpcdatainname + ".as", 'wb')
						rpcdatainfile.write(str.encode('UTF-8'))
						rpcdatainfile.close()
					str = rpcdata.toAS(self.project.lower(), self.rpcdatas)
					rpcdatafile = file(GCLIENT_DIR + os.sep + 'beans' + os.sep + rpcdataname + ".as", 'wb')
					rpcdatafile.write(str.encode('UTF-8'))
					rpcdatafile.close()
				#print "debug: " + protocol.name
				str = protocol.toAS(self.project.lower(), self.rpcdatas)
				if protname != 'ClientNeedRpcDatas':
					protocollist[protocol.name] = protocol.type
				protocolfile = file(GCLIENT_DIR + os.sep + protocol.name + ".as", 'wb')
				protocolfile.write(str.encode('UTF-8'))
				protocolfile.close()
		#protocol list
		protocollistfile = file(GCLIENT_DIR + os.sep + "ProtocolList.as", 'wb')
		protocollistfile.write("package grandline.net" + os.linesep)
		protocollistfile.write("{" + os.linesep)
		protocollistfile.write("\timport grandline.net.gnet.*;" + os.linesep)
		protocollistfile.write("\timport com.wanmei.io.ProtocolStub;" + os.linesep)
		protocollistfile.write(os.linesep)
		protocollistfile.write("\tpublic class ProtocolList" + os.linesep)
		protocollistfile.write("\t{" + os.linesep)
		protocollistfile.write("\t\tpublic static function register( pb:ProtocolStub ): void" + os.linesep)
		protocollistfile.write("\t\t{" + os.linesep)
		for prot in protocollist.keys():
			protocollistfile.write("\t\t\tpb.registerProtocol(" + protocollist[prot] + ',\t"' + prot + '",\t\t' + prot + ");" + os.linesep)
		protocollistfile.write("\t\t}" + os.linesep)
		protocollistfile.write("\t}" + os.linesep)
		protocollistfile.write("}" + os.linesep)
		protocollistfile.close()
	

	def inner_gen_rpcdata_file(self, rpcdata, rpcdatadir):
		# print "rpcdata: " + rpcdata.name
		for rpcdatanamein in rpcdata.getRpcDatas(self.rpcdatas):
			if rpcdatanamein not in self.rpcdatas.keys():
				raise RpcException("client's rpcdata'" + rpcdatanamein + "' is not defined!")
			rpcdatain = self.rpcdatas[rpcdatanamein]
			self.inner_gen_rpcdata_file(rpcdatain, rpcdatadir)
		str = rpcdata.toCSharp(self.project.lower(), self.rpcdatas)
		rpcdatafile = file(rpcdatadir + os.sep + rpcdata.name + ".cs", 'wb')
		rpcdatafile.write(str.encode('UTF-8'))
		rpcdatafile.close()

	def tocsharp(self):
		print "Generating to C# Client file ..."
		if 'client' not in self.services.keys():
			raise RpcException("client service is not defined!")
		#检查没有rpc
		#TODO 遍历一遍protocol，得到其中的rpcdata，然后再得到rpcdata中的rpcdata，然后将这个列表先输出，然后再输出protocol
		#输出state
		client = self.services['client']
		if len(client.rpcs) != 0:
			raise RpcException("client must have no rpcs!")
		GCLIENT_TOP = 'client' + os.sep + 'csharp'
		if not os.path.isdir(GCLIENT_TOP):
			os.mkdir(GCLIENT_TOP)
		GCLIENT_MANAGER = GCLIENT_TOP + os.sep + 'Manager'
		if not os.path.isdir(GCLIENT_MANAGER):
			os.mkdir(GCLIENT_MANAGER)
		GCLIENT_DIR = GCLIENT_TOP + os.sep + 'Protocol'
		if not os.path.isdir(GCLIENT_DIR):
			os.mkdir(GCLIENT_DIR)
		if not os.path.isdir(GCLIENT_DIR + os.sep + 'Rpcdata'):
			os.mkdir(GCLIENT_DIR + os.sep + 'Rpcdata')
		#Manager
		for manager in client.managers.values():
			managerfilename = manager.name.lower() + manager.type.lower()
			classname = manager.name + manager.type.capitalize()
			if not os.path.isfile(GCLIENT_MANAGER + os.sep + classname + ".cs"):
				managerhpp = file(GCLIENT_MANAGER + os.sep + classname + ".cs", 'wb')
				if manager.type.lower() == 'client':
					managerhpp.write("using System;" + os.linesep)
					managerhpp.write("using GNET.IO;" + os.linesep)
					managerhpp.write('using GNET.Common;' + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("namespace " + self.namespace + os.linesep)
					managerhpp.write("{" + os.linesep)
					managerhpp.write("\tpublic class " + manager.name + manager.type.capitalize() + " : Manager" + os.linesep)
					managerhpp.write("\t{" + os.linesep)
					managerhpp.write("\t\tprivate Session session = null;" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t\tprivate static readonly " + manager.name + manager.type.capitalize() + " instance = new " + classname + "();" + os.linesep)
					managerhpp.write("\t\tpublic static " + classname + " GetInstance()" + os.linesep)
					managerhpp.write("\t\t{" + os.linesep)
					managerhpp.write("\t\t\treturn instance;" + os.linesep)
					managerhpp.write("\t\t}" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t\tpublic Session GetSession() { return session; }" + os.linesep)
					managerhpp.write("\t\tprotected internal override void OnAddSession (Session session)" + os.linesep)
					managerhpp.write("\t\t{" + os.linesep)
					managerhpp.write('\t\t\tConsole.WriteLine("' + classname + '::OnAddSession");' + os.linesep)
					managerhpp.write('\t\t\tthis.session = session;' + os.linesep)
					managerhpp.write("\t\t}" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t\tprotected internal override void OnDelSession (Session session)" + os.linesep)
					managerhpp.write("\t\t{" + os.linesep)
					managerhpp.write('\t\t\tif(this.session != null)' + os.linesep)
					managerhpp.write('\t\t\t\tConsole.WriteLine("' + classname + '::OnDelSession " + this.session.getPeerAddress ().ToString ());' + os.linesep)
					managerhpp.write('\t\t\tthis.session = null;' + os.linesep)
					managerhpp.write('\t\t\t//reconnect' + os.linesep)
					managerhpp.write("\t\t}" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t\tprotected internal override void OnAbortSession (Session session)" + os.linesep)
					managerhpp.write("\t\t{" + os.linesep)
					managerhpp.write('\t\t\tif(this.session != null)' + os.linesep)
					managerhpp.write('\t\t\t\tConsole.WriteLine("' + classname + '::OnAbortSession " + this.session.getPeerAddress ().ToString ());' + os.linesep)
					managerhpp.write('\t\t\tthis.session = null;' + os.linesep)
					managerhpp.write('\t\t\t//reconnect' + os.linesep)
					managerhpp.write("\t\t}" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t\tpublic override String Identification()" + os.linesep)
					managerhpp.write("\t\t{" + os.linesep)
					managerhpp.write('\t\t\treturn "' + classname + '";' + os.linesep)
					managerhpp.write("\t\t}" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t\tpublic bool SendProtocol(Protocol protocol) { return (session != null) && Send(session, protocol); }" + os.linesep)
					managerhpp.write("\t\tpublic override void OnRecvProtocol(Session session, Protocol protocol)" + os.linesep)
					managerhpp.write("\t\t{" + os.linesep)
					managerhpp.write('\t\t\t//TODO' + os.linesep)
					managerhpp.write("\t\t}" + os.linesep)
					managerhpp.write(os.linesep)
					managerhpp.write("\t}" + os.linesep)
					managerhpp.write("}" + os.linesep)
				else:
					raise RpcException("Manager '" + manager.name + "' in Service '" + service.name + "' has unknown 'type' attribute")
				managerhpp.close()
		#Protocol and Rpcdata
		protocollist = {}
		for protname in client.protocols:
			if protname not in self.protocols.keys():
				raise RpcException("client's protocol '" + protname + "' is not defined")
			protocol = self.protocols[protname]
			rpcdatanames = protocol.getRpcDatas(self.rpcdatas)
			#print "debug: " + protocol.name
			#print rpcdatanames
			rpcdatadir = GCLIENT_DIR + os.sep + 'Rpcdata'
			for rpcdataname in rpcdatanames:
				if rpcdataname not in self.rpcdatas.keys():
					raise RpcException("client's rpcdata '" + rpcdataname + "' is not defined!")
				rpcdata = self.rpcdatas[rpcdataname]
				self.inner_gen_rpcdata_file(rpcdata, rpcdatadir)
			#print "debug: " + protocol.name
			str = protocol.toCSharp(self.project.lower(), self.rpcdatas)
			if protname != 'ClientNeedRpcDatas':
				protocollist[protocol.name] = protocol.type
			protocolfile = file(GCLIENT_DIR + os.sep + protocol.name + ".cs", 'wb')
			protocolfile.write(str.encode('UTF-8'))
			protocolfile.close()
		for state in client.states.values():
			rpcdatadir = GCLIENT_DIR + os.sep + 'Rpcdata'
			for protname in state.protocols:
				if protname not in self.protocols.keys():
					raise RpcException("client's protocol '" + protname + "' is not defined")
				protocol = self.protocols[protname]
				rpcdatanames = protocol.getRpcDatas(self.rpcdatas)
				#print "debug: " + protocol.name
				#print rpcdatanames
				for rpcdataname in rpcdatanames:
					if rpcdataname not in self.rpcdatas.keys():
						raise RpcException("client's rpcdata '" + rpcdataname + "' is not defined!")
					rpcdata = self.rpcdatas[rpcdataname]
					self.inner_gen_rpcdata_file(rpcdata, rpcdatadir)
				#print "debug: " + protocol.name
				str = protocol.toCSharp(self.project.lower(), self.rpcdatas)
				if protname != 'ClientNeedRpcDatas':
					protocollist[protocol.name] = protocol.type
				protocolfile = file(GCLIENT_DIR + os.sep + protocol.name + ".cs", 'wb')
				protocolfile.write(str.encode('UTF-8'))
				protocolfile.close()
		#protocol list
		protocollistfile = file(GCLIENT_DIR + os.sep + "ProtocolList.cs", 'wb')
		protocollistfile.write("using System;" + os.linesep)
		protocollistfile.write("using GNET.IO;" + os.linesep)
		protocollistfile.write("using GNET.Common;" + os.linesep + os.linesep)
		protocollistfile.write("namespace GNET" + os.linesep)
		protocollistfile.write("{" + os.linesep)
		protocollistfile.write("\tpublic class ProtocolList" + os.linesep)
		protocollistfile.write("\t{" + os.linesep)
		protocollistfile.write("\t\tpublic static System.Collections.IEnumerable RegisterProtocols()" + os.linesep)
		protocollistfile.write("\t\t{" + os.linesep)
		protocol_num = 0
		protocol_count_per_tick = 10
		for prot in protocollist.keys():
			protocol_num = protocol_num + 1
			protocollistfile.write("\t\t\tProtocol.Register(" + prot + '.PROTOCOL_TYPE, new ' + prot + '());\t\t\t\t/* Protocol Type = ' + protocollist[prot] + ' */' + os.linesep)
			if protocol_num >= protocol_count_per_tick :
				protocollistfile.write("\t\t\tyield return null;" + os.linesep);
				protocol_num = 0
		protocollistfile.write("\t\t}" + os.linesep)
		protocollistfile.write("\t}" + os.linesep)
		protocollistfile.write("}" + os.linesep)
		protocollistfile.close()

				
			

from xml.dom import minidom
import getopt

def usage():
	print __doc__.encode('UTF-8')


def main(argv):
	global DEBUG_MODE, VERBOSE_MODE, ROBOT
	DEBUG_MODE = False
	VERBOSE_MODE = False
	ROBOT = False
	GEN = False
	TO_AS_CLIENT = False
	TO_CSHARP_CLIENT = False;
	source = "rpcalls.xml"
	try:
		opts, args = getopt.getopt(argv, "chdvf:g", ["help", "debug", "verbose", "file=", "generate", "toasclient", "tocsharp"])
	except getopt.GetoptError:
		usage()
		sys.exit(2)
	for opt, arg in opts:
		if opt in ("-c"):
			ROBOT = True
		elif opt in ("-h", "--help"):
			usage()
			sys.exit()
		elif opt in ("-f", "--file"):
			source = arg
		elif opt in ("-d", "--debug"):
			DEBUG_MODE = True
		elif opt in ("-v", "--verbose"):
			VERBOSE_MODE = True
		elif opt in ("-g", "--generate"):
			GEN = True
		elif opt in ("--toasclient"):
			TO_AS_CLIENT = True
		elif opt in ("--tocsharp"):
			TO_CSHARP_CLIENT = True
		
	if len(args) != 0:
		print "Unknown args: ", args
		usage()
		sys.exit(2)
	try:
		sock = openAnything(source)
		rpcalls = minidom.parse(sock).documentElement
		app = Application()
		if DEBUG_MODE:
			DEBUG_MODE = True
		if VERBOSE_MODE:
			VERBOSE_MODE = True
		app.parse(rpcalls)
		if GEN:
			app.generate()
		if TO_AS_CLIENT:
			app.toasclient()
		if TO_CSHARP_CLIENT:
			app.tocsharp()
		sock.close()
	except Exception, e:
		print "Error: ", e

if __name__ == "__main__":
	main(sys.argv[1:])

