#!/bin/sh

killall ssh
sleep 1
ssh -f -N -C -p 9229 game@211.157.164.224 -L 0.0.0.0:8873:127.0.0.1:873




#mv /var/www/sanguo-android/update/bin/apk ~/bak/android
#rsync -avzLc --delete --exclude="*.apk" rsync://game@127.0.0.1:8873/Dist/for_check/sanguo/android/update /var/www/sanguo-android

#mv ~/bak/android/apk /var/www/sanguo-android/update/bin/
rsync -avzLc --delete rsync://game@127.0.0.1:8873/Dist/for_check/sanguo/android/update/bin/* /var/www/sanguo-android/update/bin/apk



#rsync -avzLc --delete rsync://game@127.0.0.1:8873/Dist/for_check/sanguo/android/update /var/www/sanguo-android

#cp /var/www/sanguo-android/update/bin/version-open.xml /var/www/sanguo-android/update/bin/version.xml
#rm -f /var/www/sanguo-android/update/bin/index.html
#rm -f /var/www/sanguo-android/update/bin/sangoku.html
#rm -f /var/www/sanguo-android/update/bin/SANGUO.apk

#cp -rf /var/www/android/download.html /var/www/sanguo-android/update/bin/
#cp -rf /var/www/android/download.html /var/www/sanguo-android/update/bin/apk/


chown -R root.root /var/www/sanguo-android




#rsync -avzL --delete rsync://game@127.0.0.1:8873/Dist/for_check/sanguo/ios/update /var/www/sanguo-ios
#
#cp /var/www/sanguo-ios/update/bin/version-open.xml /var/www/sanguo-ios/update/bin/version.xml
#rm -f /var/www/sanguo-ios/update/bin/index.html
#rm -f /var/www/sanguo-ios/update/bin/sangoku.html
#rm -f /var/www/sanguo-ios/update/bin/SANGUO.apk
#
#chown -R root.root /var/www/sanguo-ios




killall ssh
sleep 1

