clean:
	rm ./*.class || true

compile:
	scalac -Xlog-implicits ./*.scala

build: clean compile
	@echo -------------------------

exe:
	@scala Day

run: build exe
