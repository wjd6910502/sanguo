#!/usr/bin/python
#encoding=utf-8

import cgi, cgitb, os

form = cgi.FieldStorage()

roleid=form.getvalue('roleid')
serverid=form.getvalue('serverid')
itemid=form.getvalue('itemid')
mailid=form.getvalue('mailid')
mail_title=form.getvalue('mail_title')
mail_context=form.getvalue('mail_context')

#res=os.popen('/home/anyazhou/sanguo_test/gm/gm /home/anyazhou/sanguo_test/gm/gamesys.conf 1000')
res=os.popen('./gm gamesys.conf 1000')
#res=os.popen('./main')
result = res.read()


print "Content-type:text/html"
print
print "<html>"
print "<head>"
print "<title>客服工具礼包发放</title>"
print "</head>"

print "<text>"
print result
print "</text>"
print "</html>"
