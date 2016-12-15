clean:
	rm ./*.class || true

compile:
	scalac ./*.scala

build: clean compile
	@echo -------------------------

exe:
	@scala Day

run: build exe
