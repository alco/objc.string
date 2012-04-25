test: gh_unit
	cd tests/gh-unit/Project-MacOSX; make

gh_unit: tests/gh-unit
	git submodule update --init
