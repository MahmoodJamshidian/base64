CC=g++
CC_ARGS=-Wall -shared
CPP_FILE=base64.hpp
ifeq ($(OS),Windows_NT)
CPP_OUT_FILE=base64.dll
else
CPP_OUT_FILE=base64.so
endif

compile:
	$(CC) $(CC_ARGS) $(CPP_FILE) -o $(CPP_OUT_FILE)