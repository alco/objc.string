test: tests/gh-unit
	cd tests/gh-unit/Project-MacOSX; make

tests/gh-unit:
	git submodule update --init
