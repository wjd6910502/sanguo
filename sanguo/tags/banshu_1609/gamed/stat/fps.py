#!/usr/bin/env python

import sys

def main():
	if len(sys.argv)!=2:
		print "%s infile"%sys.argv[0]
		return

	first_ln = ""
	last_ln = ""

        rfp = open(sys.argv[1])
        ln = rfp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
		if first_ln=="":
			first_ln = ln
		last_ln = ln
                ln = rfp.readline()
	#print first_ln 
	#print last_ln
	cols = first_ln.split()
	bt = float(cols[0].strip(":"))
	cols = last_ln.split()
	et = float(cols[0].strip(":"))
	frame = float(cols[3])
	print (et-bt)/1000, frame*1000/(et-bt)

if __name__ == "__main__":
        main()

