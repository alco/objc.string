test: tests/gh-unit/Project-MacOSX
	cd tests/gh-unit/Project-MacOSX; make
	@echo "All done. Open tests/ObjCStringTests.xcodeproj to run the tests."

tests/gh-unit/Project-MacOSX:
	git submodule update --init
