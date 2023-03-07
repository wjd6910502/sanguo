#!/usr/bin/python
#encoding=utf-8

import cgi, cgitb

print "Content-type:text/html"
print
print "<html>"
print "<head>"
print "<title>客服工具</title>"
print "</head>"

print """<form action="/cgi-bin/find_role.py" method="post">"""
print """<table><tbody>"""
print """<tr><td>角色ID:</td> <td><input type="text" name="roleid"/></td></tr>"""
print """<tr><td>角色名字:</td> <td><input type="text" name="rolename"/></td></tr>"""
print """<tr><td>角色服务器ID:</td> <td><input type="text" name="serverid"/></td></tr>"""
print """</tbody></table>"""
print """<input type="submit" value="查找"/><p/>"""
print "</form>"
print "</html>"
