#CC=gcc
#CXX=g++

CC= clang -I/usr/include/x86_64-linux-gnu/ -I/usr/include/c++/4.5 -I/usr/include/c++/4.5/x86_64-linux-gnu
CXX= clang++ -I/usr/include/x86_64-linux-gnu/ -I/usr/include/c++/4.5 -I/usr/include/c++/4.5/x86_64-linux-gnu

#CFLAGS= -g -O1 -Wall -Wextra
CFLAGS= -g -O2 -D__AES__ -mssse3 -Wall -Wextra
#CFLAGS= -g -O2 -Wall -Wextra -mno-sse2
LDFLAGS= -g

all: raw_random test_random bench

test_random: test_random.o crandom.o chacha.o aes.o intrinsics.o
	$(CXX) $(LDFLAGS) -o $@ $^

raw_random: raw_random.o crandom.o chacha.o aes.o intrinsics.o
	$(CXX) $(LDFLAGS) -o $@ $^

bench: bench.o chacha.o aes.o intrinsics.o
	$(CXX) $(LDFLAGS) -o $@ $^

chacha.o: chacha.c chacha.hpp intrinsics.h Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

aes.o: aes.c aes.hpp intrinsics.h Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

intrinsics.o: intrinsics.c intrinsics.h Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

crandom.o: crandom.cpp crandom.hpp chacha.hpp Makefile
	$(CXX) $(CFLAGS) -c -o $@ $<

test_random.o: test_random.cpp crandom.hpp chacha.hpp aes.hpp Makefile
	$(CXX) $(CFLAGS) -c -o $@ $<

raw_random.o: raw_random.cpp crandom.hpp chacha.hpp aes.hpp Makefile
	$(CXX) $(CFLAGS) -c -o $@ $<

bench.o: bench.cpp chacha.hpp aes.hpp Makefile
	$(CXX) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o raw_random test_random bench