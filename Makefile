default: protocol.md

protocol.md: ./schemas/*
	./schemas/schema2md.py ./schemas/index.json > protocol.md

.PHONY: clean

clean:
	rm -f protocol.md
