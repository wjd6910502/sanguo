#!/usr/bin/env python

#grep "roleid=1005" client_logs.txt > 1005

def main():
        fp = open("1005")
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

