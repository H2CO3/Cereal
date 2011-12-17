CLIENT = CerealClient.dylib
SERVER = CerealServer.dylib

CC = gcc
LD = $(CC)
CFLAGS = -isysroot /User/sysroot \
	 -std=gnu99 \
	 -Wall \
	 -c
LDFLAGS = -isysroot /User/sysroot \
	  -w \
	  -dynamiclib \
	  -F/System/Library/PrivateFrameworks \
	  -lobjc \
	  -lsubstrate \
	  -lactivator \
	  -framework Foundation \
	  -framework AppSupport \
	  -framework UIKit

CLIENT_OBJECTS = CerealClient.o
SERVER_OBJECTS = CerealServer.o

all: $(CLIENT_OBJECTS) $(SERVER_OBJECTS)
	$(LD) $(LDFLAGS) -o $(CLIENT) $(CLIENT_OBJECTS)
	$(LD) $(LDFLAGS) -o $(SERVER) $(SERVER_OBJECTS)
	cp $(CLIENT) /Library/MobileSubstrate/DynamicLibraries
	cp $(SERVER) /Library/MobileSubstrate/DynamicLibraries

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $^

