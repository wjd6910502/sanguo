#!/usr/bin/env python
#encoding=utf8

import sys 

def remove(path):
        fp = open(path, "r+")
        hdr = ""
        try:
                hdr = fp.read(3)
        except:
                return #涓嶅甫BOM
        if hdr[0]!="\xef" or hdr[1]!="\xbb" or hdr[2]!="\xbf":
                return #涓嶅甫BOM
        #鍔犱釜澶|4
        content = fp.read()
        fp.seek(0)
        fp.truncate(0)
        fp.write(content)
        fp.close()

def main():
        if len(sys.argv) < 2:
                print "Usage: %s file1 file2 ..." % sys.argv[0]
                sys.exit(1)
        fs = sys.argv[1:]
        for f in fs: 
                print "Remove BOM from", f
                remove(f)

if __name__ == "__main__":
        main()

