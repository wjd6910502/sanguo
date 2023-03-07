#!/usr/bin/env python

#grep PVPOperationSet client_logs.txt | grep sid=3 > 1

def main():
        prev_time = 0
        expect_time = 0

	offset = 0

        fp = open("1")
        ln = fp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
		logs = ln.split("]]]|[[[")

		for log in logs[1:]:
			#print log
                	cols = log.split()
                	#print cols[0].strip(":")
                	cur_time = int(cols[0].strip(":"))
                	if prev_time==0:
                	        prev_time = cur_time
                	        expect_time = cur_time+33.333333
                	else:
                	        delta1 = cur_time-prev_time
                	        delta2 = cur_time-expect_time

				if delta2<offset:
					offset = delta2

                	        prev_time = cur_time
                	        expect_time += 33.333333

                ln = fp.readline()

        prev_time = 0
        expect_time = 0

	fp.seek(0)

        ln = fp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
		logs = ln.split("]]]|[[[")

		for log in logs[1:]:
			#print log
                	cols = log.split()
                	#print cols[0].strip(":")
                	cur_time = int(cols[0].strip(":"))
                	if prev_time==0:
                	        prev_time = cur_time
                	        expect_time = cur_time+33.333333
                	else:
                	        delta1 = cur_time-prev_time
                	        delta2 = cur_time-expect_time-offset
				if delta2>220:
				        print "CAU7", delta1, int(delta2), cols[2]
				elif delta2>140:
				        print "CAU5", delta1, int(delta2), cols[2]
				else:
                	        	print delta1, int(delta2), cols[2]
                	        prev_time = cur_time
                	        expect_time += 33.333333

                ln = fp.readline()

if __name__ == "__main__":
        main()

