#!/usr/bin/env python

#grep PVPOperationSet client_logs.txt | grep sid=3 > 1

def main():
        prev_time = 0
        expect_time = 0

        fp = open("1")
        ln = fp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
		logs = ln.split("]]]|[[[")

		for log in logs[1:]:
			#print log
			if log.find("PVPOperationSet")==-1:
				continue
                	cols = log.split()
                	#print cols[0].strip(":")
                	cur_time = int(cols[0].strip(":"))
                	if prev_time==0:
                	        prev_time = cur_time
                	        expect_time = cur_time+33.333333
                	else:
                	        delta1 = cur_time-prev_time
                	        delta2 = cur_time-expect_time
                	        print delta1, delta2, cols[2]
                	        prev_time = cur_time
                	        expect_time += 33.333333

                ln = fp.readline()

if __name__ == "__main__":
        main()

