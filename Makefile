CC=g++
CC_ARGS=-Wall -shared
CPP_FILE=base64.hpp
ifeq ($(OS),Windows_NT)
CPP_OUT_FILE=b64.dll
python?=python
python:=$(shell where $(python))
INCLUDE_PATH:=$(shell $(python) -c "from sysconfig import get_paths;print(get_paths()['include'])")
LIBS_PATH=$(INCLUDE_PATH)\\..\\libs
else
CPP_OUT_FILE=b64.so
python?=python3
python:=$(shell which $(python))
INCLUDE_PATH=/usr/include/$(python)
LIBS_PATH:=$(shell $(python) -c "from sysconfig import get_paths;print(get_paths()['stdlib'])")
endif
PYC_OUT_PKG=b64
LIB:=$(shell $(python) -c "import os;print(os.path.basename(b'$(python)'.decode()))")
ifeq ($(OS),Windows_NT)
LIB:=$(shell $(python) -c "import os;print(os.path.basename(os.path.dirname(b'$(python)'.decode()))))
endif

compile-all:
	@make py-compile python=$(python)
	@make cpp-compile
	@echo done

cpp-compile:
	$(CC) $(CC_ARGS) $(CPP_FILE) -o $(CPP_OUT_FILE)
	@echo done

py-compile:
	@echo python: $(python)
	@echo installing virtualenv
	@$(python) -m pip install virtualenv
	@echo creating a virtual environment
	@$(python) -m virtualenv venv
	@echo activating ...
ifeq ($(OS),Windows_NT)
	@venv\Scripts\activate
else
	@. venv/bin/activate
endif
	@echo virtual environment was activated
	@echo installing dependencies ...
	$(python) -m pip install -r requirements.txt
	@echo building ...
	$(python) setup.py build_ext --inplace
ifdef $(clean)
	make clean
endif
	@echo done

py-gpp-compile:
	@echo python: $(python)
ifeq ($(wildcard $(INCLUDE_PATH)),)
$(error include path not found)
endif
ifeq ($(wildcard $(LIBS_PATH)),)
$(error libs path not found)
endif
	@echo include path: $(INCLUDE_PATH)
	@echo libs path: $(LIBS_PATH)
	@echo installing virtualenv
	@$(python) -m pip install virtualenv
	@echo creating a virtual environment
	@$(python) -m virtualenv venv
	@echo activating ...
ifeq ($(OS),Windows_NT)
	@venv\Scripts\activate
else
	@. venv/bin/activate
endif
	@echo virtual environment was activated
	@echo installing dependencies ...
	$(python) -m pip install -r requirements.txt
	@echo building ...
	cython -o b64.cpp -3 --cplus b64.pyx
	g++ -c -DMS_WIN64 -Ofast -I$(INCLUDE_PATH) -o b64.o b64.cpp -fPIC
ifeq ($(OS),Windows_NT)
	g++ -L$(LIBS_PATH) -shared -o $(PYC_OUT_PKG).pyd b64.o -l$(LIB)
else
	g++ -L$(LIBS_PATH) -shared -o $(PYC_OUT_PKG).so b64.o -l$(LIB)
endif
ifdef $(clean)
	make clean
endif
	@echo done
clean:
ifeq ($(OS),Windows_NT)
ifneq ($(wildcard build),)
	rd /s /q build
endif
ifneq ($(wildcard venv),)
	rd /s /q venv
endif
ifneq ($(wildcard b64.cpp),)
	del /f /q b64.cpp
endif
ifneq ($(wildcard b64.o),)
	del /f /q b64.o
endif
else
	rm -rf venv build b64.cpp b64.o
endif
	@echo done
	