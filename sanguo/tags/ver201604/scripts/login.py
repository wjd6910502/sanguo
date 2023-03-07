#!/usr/bin/python
#encoding=gbk

import cgi, cgitb

form = cgi.FieldStorage()

name=form.getvalue('name')
password=form.getvalue('password')
name_list={"anyazhou":"anyazhou"}

print "Content-type:text/html"
print
print "<html>"

print "<head>"
print "<title>客服工具</title>"
print "</head>"

print "<body>"
if name_list.has_key(name):
	if name_list[name] == password:
		print """<p><a href="/cgi-bin/send_gift_html.py">发放礼包</a></p>"""
		print """<p><a href="/cgi-bin/find_role.py">角色查找</a></p>"""
	else:
		print "password is error"
else:
	print "user does not exist"
print "</body>"

print "</html>"

