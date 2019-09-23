export SHELL = sh
PACKAGE = rsp
VERSION = 0.0.2-1
COPYRIGHTYEAR = 2019
AUTHOR = Rsp Team
EMAIL = rsp@intel.com

all: debian

debian: 
	[ ! -d ./build/debian/ ] || rm -r ./build/debian/
	mkdir -p ./build/debian/
	mkdir -p ./dist
	
	cp -r src/* ./build/debian/
	
	./tools/debian-package.sh "$(PACKAGE)" "$(VERSION)" "$(AUTHOR)" "$(EMAIL)" "all"


clean:
	rm -rf dist
	rm -rf build

