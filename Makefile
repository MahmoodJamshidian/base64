CC=g++
CC_ARGS=-Wall -shared
CPP_FILE=base64.hpp
ifeq ($(OS),Windows_NT)
CPP_OUT_FILE=base64.dll
python?=python
else
CPP_OUT_FILE=b64.so
python?=python3
endif
PYC_OUT_PKG=b64

compile-all:
	@make py-compile python=$(python)
	@make cpp-compile
	@echo done

test:
	@echo $(INCLUDE_PATH)

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
else
	rm -rf venv build b64.cpp
endif
	@echo done
	