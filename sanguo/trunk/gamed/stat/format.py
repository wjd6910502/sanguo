#!/usr/bin/env python

import sys

def main():
	if len(sys.argv)!=2:
		print "%s infile"%sys.argv[0]
		return

        fp = open(sys.argv[1])
        ln = fp.readline()
        while ln!="":
                #print ln
                ln = ln.strip()
		logs = ln.split("]]]|[[[")

		for log in logs[1:]:
			print log

                ln = fp.readline()

if __name__ == "__main__":
        main()

