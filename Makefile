default: protocol.md

protocol.md: ./schemas/*
	@echo "Generating protocol.md"
	@./schemas/schema2md.py ./schemas/index.json > protocol.md

check: ./schemas/*
	@./schemas/schema2md.py ./schemas/index.json > /tmp/protocol_new.md
	@if ! cmp -s /tmp/protocol_new.md protocol.md; then \
        echo "===================================="; \
        echo "ERROR: protocol.md is not up-to-date"; \
        echo "===================================="; \
        rm /tmp/protocol_new.md; \
        exit 1; \
    else \
        echo "protocol.md is up-to-date"; \
        rm /tmp/protocol_new.md; \
    fi

.PHONY: clean

clean:
	rm protocol.md
