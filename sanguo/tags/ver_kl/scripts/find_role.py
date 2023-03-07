#!/usr/bin/python
#encoding=utf-8

import cgi, cgitb, os

form = cgi.FieldStorage()

roleid=form.getvalue('roleid')
rolename=form.getvalue('rolename')
serverid=form.getvalue('serverid')

res=os.popen('./gm gamesys.conf 1001')
result = res.read()

print "Content-type:text/html"
print
print "<html>"
print "<head>"
print "<title>客服工具角色查找</title>"
print "</head>"

print "<text>"
print result
print "</text>"
print "</html>"
