#!/bin/sh
#(nohup setsid ./get_update_restart.sh >&/dev/null &)

while true
do
	if [ -e /tmp/get_update_restart ]
	then
		ssh=`ps -ef | grep ssh | grep 8873 | awk '{ print $2 }'`
		/usr/bin/kill -9 ${ssh}
		ssh -f -N -C -p 9229 game@211.157.164.224 -L 8873:127.0.0.1:873

		cd /root/tmp

		echo "开始获取数据..." >/tmp/get_update_restart_out
		rsync -rLptgoDv rsync://game@127.0.0.1:8873/Dist/for_check/xayd.test . --password-file=passwd >>/tmp/get_update_restart_out
		
		echo "开始同步数据..." >>/tmp/get_update_restart_out
		dest=/export/xayd
		
		rsync -avzl ./xayd.test/gamed/gs64 ${dest}/gamed >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamed/libtask64.so ${dest}/gamed >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamed/libskill64.so ${dest}/gamed >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamed/aibase.lua ${dest}/gamed >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamed/aibase.lua.luac ${dest}/gamed >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamed/levelbase.lua ${dest}/gamed >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamed/levelbase.lua.luac ${dest}/gamed >>/tmp/get_update_restart_out
		
		rsync -avzl ./xayd.test/glinkd/glinkd ${dest}/glinkd >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gdeliveryd/gdeliveryd ${dest}/gdeliveryd >>/tmp/get_update_restart_out
		rsync -avzl ./xayd.test/gamedbd/gamedbd ${dest}/gamedbd >>/tmp/get_update_restart_out

		#rm ${dest}/gamed/config -rf
		rsync -avzl ./xayd.test/gamed/config ${dest}/gamed >>/tmp/get_update_restart_out
		
		echo "开始重启服务器..." >>/tmp/get_update_restart_out
		#${dest}/scripts/stop && ${dest}/scripts/start >>/tmp/get_update_restart_out
		${dest}/scripts/force_stop.sh && ${dest}/scripts/start >>/tmp/get_update_restart_out

		rm -f /tmp/get_update_restart
	fi

	if [ -e /tmp/get_update_restart_android ]
	then
		ssh=`ps -ef | grep ssh | grep 8873 | awk '{ print $2 }'`
		/usr/bin/kill -9 ${ssh}
		ssh -f -N -C -p 9229 game@211.157.164.224 -L 8873:127.0.0.1:873

		cd /root/tmp

		echo "开始获取数据..." >/tmp/get_update_restart_out_android
		rsync -rLptgoDv rsync://game@127.0.0.1:8873/Dist/for_check/xayd_android.test . --password-file=passwd >>/tmp/get_update_restart_out
		
		echo "开始同步数据..." >>/tmp/get_update_restart_out_android
		dest=/export/xayd
		
		rsync -avzl ./xayd_android.test/gamed/gs64 ${dest}/gamed >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamed/libtask64.so ${dest}/gamed >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamed/libskill64.so ${dest}/gamed >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamed/aibase.lua ${dest}/gamed >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamed/aibase.lua.luac ${dest}/gamed >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamed/levelbase.lua ${dest}/gamed >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamed/levelbase.lua.luac ${dest}/gamed >>/tmp/get_update_restart_out_android
		
		rsync -avzl ./xayd_android.test/glinkd/glinkd ${dest}/glinkd >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gdeliveryd/gdeliveryd ${dest}/gdeliveryd >>/tmp/get_update_restart_out_android
		rsync -avzl ./xayd_android.test/gamedbd/gamedbd ${dest}/gamedbd >>/tmp/get_update_restart_out_android

                rsync -avzl ./xayd.check/gdeliveryd/elements.data ${dest}/gdeliveryd >>/tmp/get_update_restart_out
                rsync -avzl ./xayd.check/gdeliveryd/ds_speak.lua ${dest}/gdeliveryd >>/tmp/get_update_restart_out

		#rm ${dest}/gamed/config -rf
		rsync -avzl ./xayd_android.test/gamed/config ${dest}/gamed >>/tmp/get_update_restart_out_android
		
		echo "开始重启服务器..." >>/tmp/get_update_restart_out_android
		#${dest}/scripts/stop && ${dest}/scripts/start >>/tmp/get_update_restart_out_android
		${dest}/scripts/force_stop.sh && ${dest}/scripts/start >>/tmp/get_update_restart_out_android

		rm -f /tmp/get_update_restart_android
	fi
	
	if [ -e /tmp/get_sanguo_update_restart ]
	then
		ssh=`ps -ef | grep ssh | grep 8873 | awk '{ print $2 }'`
		/usr/bin/kill -9 ${ssh}
		ssh -f -N -C -p 9229 game@211.157.164.224 -L 8873:127.0.0.1:873

		cd /root/tmp

		echo "开始获取数据..." >/tmp/get_sanguo_update_restart_out
		rsync -rLptgoDv rsync://game@127.0.0.1:8873/Dist/for_check/sanguo/test . --password-file=passwd >>/tmp/get_sanguo_update_restart_out
		
		echo "开始同步数据..." >>/tmp/get_sanguo_update_restart_out
		dest=/export/sanguo
	


		rm -rf ${dest}/gamed
		rm -rf ${dest}/elementdata.dpc
		rm -rf ${dest}/xlib
		rm -rf ${dest}/scripts
		rm -rf ${dest}/gamedbd/sanguodbd
		rm -rf ${dest}/pvp/pvpd
		rm -rf ${dest}/gcenterd/sanguogcenterd
			
		rsync -avzl ./test/gamed ${dest} >>/tmp/get_sanguo_update_restart_out
		rsync -avzl ./test/elementdata.dpc ${dest} >>/tmp/get_sanguo_update_restart_out
		rsync -avzl ./test/xlib ${dest} >>/tmp/get_sanguo_update_restart_out
		rsync -avzl ./test/scripts ${dest} >>/tmp/get_sanguo_update_restart_out
		rsync -avzl ./test/gamedbd ${dest}/gamedbd/sanguodbd >>/tmp/get_sanguo_update_restart_out
		rsync -avzl ./test/pvpd ${dest}/pvp >>/tmp/get_sanguo_update_restart_out
		rsync -avzl ./test/gcenterd ${dest}/gcenterd/sanguogcenterd >>/tmp/get_sanguo_update_restart_out

		
		echo "开始重启服务器sanguo_sanguo_..." >>/tmp/get_sanguo_update_restart_out
		#${dest}/scripts/stop && ${dest}/scripts/start >>/tmp/get_sanguo_update_restart_out
		${dest}/restart >>/tmp/get_sanguo_update_restart_out

		rm -f /tmp/get_sanguo_update_restart
	fi

	sleep 1
done

