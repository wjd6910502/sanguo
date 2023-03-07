#!/bin/sh

killall ssh
sleep 1
ssh -f -N -C -p 9229 game@211.157.164.224 -L 0.0.0.0:8873:127.0.0.1:873




#mv /var/www/sanguo-android-tiyan/update/bin/apk ~/bak/android-tiyan
rsync -avzLc --delete --progress  --password-file=/home/test/wjd/rsyncd.passwd rsync://game@127.0.0.1:8873/Dist/for_check/xom/xom-android-lite/update /var/www/xom-android-lite

#mv ~/bak/android-tiyan/apk /var/www/sanguo-android-tiyan/update/bin/

#rsync -avzLc --delete --progress  --password-file=/home/test/wjd/rsyncd.passwd rsync://game@127.0.0.1:8873/Dist/for_check/sanguo/android-tiyan/update/bin/* /var/www/sanguo-android-tiyan/update/bin/apk




chown -R root.root /var/www/xom-android-lite





killall ssh
sleep 1

