objects=tolua_event.o tolua_is.o tolua_map.o tolua_to.o tolua_push.o
libtolua.so:$(objects)
	gcc -shared -fPIC -o libtolua.so $(objects)
tolua_event.o:tolua_event.c tolua_event.h
	gcc -fPIC -c tolua_event.c
tolua_is.o:tolua_is.c 
	gcc -fPIC -c tolua_is.c
tolua_map.o:tolua_map.c 
	gcc -fPIC -c tolua_map.c
tolua_to.o:tolua_to.c 
	gcc -fPIC -c tolua_to.c
tolua_push.o:tolua_push.c 
	gcc -fPIC -c tolua_push.c
clean:
	rm tolua_to.o tolua_is.o tolua_map.o tolua_push.o tolua_event.o 
