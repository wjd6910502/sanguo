#!/bin/sh

/bin/rm -f tmp.*

for roleid in 1004
#for roleid in 1028 1029
do
	echo "----------------------- $roleid"
	/bin/grep "roleid=$roleid" ../client_logs.txt > 1
	./format.py 1 > 2
	./split.py $roleid 2
	for f in `ls tmp.$roleid.*`
	do
		echo "----------------------- $f"
		#ȥ��ĩβ����Чforcast tick
		FLN=`tac $f | grep Dump -n | head -n 1 | awk -F':' '{ print $1 }'`
		TLN=`wc -l $f | awk '{ print $1 }'`
		N=`echo "$TLN-$FLN+1" | bc`
		rm -f x*
		split -l $N $f
		mv xaa $f
		#ͳ��
		/bin/grep Dump $f -c
		/bin/grep Load $f -c
		/bin/grep Tick $f -c
		/bin/grep Tick $f | grep forcast -c
		/bin/grep Tick $f | grep forcast -v | wc -l
		./fps.py $f
	done
done
