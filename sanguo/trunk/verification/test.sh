export LD_LIBRARY_PATH=/home/anyazhou/new_sanguo/trunk/verification/validator
echo
cd /home/anyazhou/new_sanguo/trunk/verification/persist
svn up
make 
make clean
cp libpersist.so /home/anyazhou/new_sanguo/trunk/verification/validator
echo
#cd /home/anyazhou/ayz_dir/SANGUO_Project/FTG_source/FTG
#svn up
#cp -R -f /home/anyazhou/ayz_dir/SANGUO_Project/FTG_source/FTG  /home/anyazhou/ayz_dir/SANGUO_Project/
cd /home/anyazhou/new_sanguo/trunk/verification/FTG
svn up
make
make clean
cp libftg.so /home/anyazhou/new_sanguo/trunk/verification/validator/
cd /home/anyazhou/new_sanguo/trunk/verification/validator/Lua
echo
svn up
cd /home/anyazhou/new_sanguo/trunk/verification/validator/Datapool
svn up
echo
cd /home/anyazhou/new_sanguo/trunk/verification/validator
#g++ -ggdb -D _LinuxServer -std=c++0x -o test8 test_8.cpp -L. -lftg -lpersist -ldatapool -lpthread -L=/home/anyazhou/ayz_dir/SANGUO_Project/base/LuaJIT-2.0.4/src -lluajit -ltolua  -ldl
