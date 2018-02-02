TOOLCHAIN_HOME ?= /usr
CPP_SHARED := -std=c++11 -Os -I src -shared -fPIC -DUWS_THREADSAFE src/Extensions.cpp src/Group.cpp src/Networking.cpp src/Hub.cpp src/Node.cpp src/WebSocket.cpp src/HTTPSocket.cpp src/Socket.cpp src/Epoll.cpp
CPP_OPENSSL_OSX := -L/usr/local/opt/openssl/lib -I/usr/local/opt/openssl/include
CPP_OSX := -stdlib=libc++ -mmacosx-version-min=10.7 -undefined dynamic_lookup $(CPP_OPENSSL_OSX)
ARMCXX := $(TOOLCHAIN_HOME)/bin/$(CROSS_PREFIX)g++ -D__STDC_LIMIT_MACROS
CPP_ARM := -lcrypto -lssl -s

default:
	make `(uname -s)`
Linux:
	$(CXX) $(CPPFLAGS) $(CFLAGS) $(CPP_SHARED) -s -o libuWS.so
arm-Linux:
	$(ARMCXX) $(CPPFLAGS) $(CFLAGS) $(CPP_SHARED) $(CPP_ARM) -o libuWS.so
Darwin:
	$(CXX) $(CPPFLAGS) $(CFLAGS) $(CPP_SHARED) $(CPP_OSX) -o libuWS.dylib
.PHONY: install
install:
	make install`(uname -s)`
.PHONY: installLinux
installLinux:
	if [ -d "/usr/lib64" ]; then cp libuWS.so /usr/lib64/; else cp libuWS.so /usr/lib/; fi
	mkdir -p /usr/include/uWS
	cp src/*.h /usr/include/uWS/
.PHONY: installDarwin
installDarwin:
	cp libuWS.dylib /usr/local/lib/
	mkdir -p /usr/local/include/uWS
	cp src/*.h /usr/local/include/uWS/
.PHONY: clean
clean:
	rm -f libuWS.so
	rm -f libuWS.dylib
.PHONY: tests
tests:
	$(CXX) $(CPP_OPENSSL_OSX) -std=c++11 -O3 tests/main.cpp -Isrc -o testsBin -lpthread -luWS -lssl -lcrypto -lz -luv
