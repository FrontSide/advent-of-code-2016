clean:
	rm *.dump || true
	rm *.beam || true

run: clean
	erlc day.erl
	erl -noshell -s day start -s init stop
