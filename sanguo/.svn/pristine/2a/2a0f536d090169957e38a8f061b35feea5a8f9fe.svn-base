#!/bin/sh

echo "Content-type: text/html; charset=gbk"
echo ""

touch /tmp/get_sanguo_update_restart

echo "<pre>"

while [ -e /tmp/get_sanguo_update_restart ]
do
	echo "正在处理中, 请稍等..."
	sleep 10
done
echo ""

cat /tmp/get_sanguo_update_restart_out
rm -f /tmp/get_sanguo_update_restart_out

echo "</pre>"

