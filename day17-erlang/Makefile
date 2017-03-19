clean:
	rm *.dump || true
	rm *.beam || true

run: clean
	erlc day.erl daymd5.erl
	erl -noshell -s day start -s init stop
