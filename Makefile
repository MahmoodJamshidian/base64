CC=g++
CC_ARGS=-Wall -shared
CPP_FILE=base64.hpp
CPP_OUT_FILE=base64.so

compile:
	$(CC) $(CC_ARGS) $(CPP_FILE) -o $(CPP_OUT_FILE)