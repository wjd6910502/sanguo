#!/usr/bin/env python

import sys

def main():
	if len(sys.argv)!=3:
		print "%s roleid infile"%sys.argv[0]
		return

	fno = 0

        rfp = open(sys.argv[2])
        ln = rfp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
		if ln.find("BEGIN BEGIN BEGIN!!!")!=-1:
			fno = fno+1
			if fno!=1:
				wfp.close()
			wfp = open("tmp.%s.%d"%(sys.argv[1],fno), "w")
		wfp.write(ln+"\n")
			
                ln = rfp.readline()
	#wfp.close()

if __name__ == "__main__":
        main()

