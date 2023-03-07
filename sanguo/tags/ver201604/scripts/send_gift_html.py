#!/usr/bin/python
#encoding=utf-8

import cgi, cgitb

print "Content-type:text/html"
print
print "<html>"
print "<head>"
print "<title>客服工具</title>"
print "</head>"

print """<form action="/cgi-bin/send_gift.py" method="post">"""
print """<table><tbody>"""
print """<tr><td>角色ID:</td> <td><input type="text" name="roleid"/></td></tr>"""
print """<tr><td>角色服务器ID:</td> <td><input type="text" name="serverid"/></td></tr>"""
print """<tr><td>发放的物品:</td> <td><input type="text" name="itemid"/></td></tr>"""
print """<tr><td>邮件ID:</td> <td><input type="text" name="mailid"/></td></tr>"""
print """<tr><td>邮件标题:</td> <td><input type="text" name="mail_title"/></td></tr>"""
print """<tr><td>邮件内容:</td> <td><input type="text" name="mail_context"/></td></tr>"""
print """</tbody></table>"""
print """<input type="submit" value="发放"/><p/>"""
print "</form>"
print "</html>"
