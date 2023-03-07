#!/usr/bin/env python

#find . -type f | xargs /export/ver/decode_path.py >/tmp/list

import sys, base64

def main():
	for path in sys.argv[1:]:
		#print path
		parts = path.split("/")
		new_parts = []
		for p in parts:
			if p=="." or p=="..":
				new_parts.append(p)
			else:
				try:
					new_parts.append(base64.b64decode(p))
				except:
					new_parts.append(p)
		print "%s\t\t\t%s" % ("/".join(new_parts), path)


if __name__ == "__main__":
	main()

