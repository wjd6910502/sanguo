#!/usr/bin/env python

#grep -w OP pvpd.log | grep "fighter=1001" > 1

def main():
        prev_time = 0
        expect_time = 0

        fp = open("2")
        ln = fp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
                cols = ln.split()

                #print cols[2].strip(":")
                cur_time = int(cols[2].strip(":"))
                if prev_time==0:
                        prev_time = cur_time
                        expect_time = cur_time+33.333333
                else:
                        delta1 = cur_time-prev_time
                        delta2 = cur_time-expect_time
			if delta1>180:
                        	print "CAU6", delta1, int(delta2), cols[5]
			elif delta1>90:
                        	print "CAU3", delta1, int(delta2), cols[5]
			elif delta1>60:
                        	print "CAU2", delta1, int(delta2), cols[5]
			else:
                        	print delta1, int(delta2), cols[5]
                        prev_time = cur_time
                        expect_time += 33.333333

                ln = fp.readline()

if __name__ == "__main__":
        main()

