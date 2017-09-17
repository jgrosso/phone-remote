.PHONY: all
all: lib

lib: src lib/public
	node_modules/.bin/babel src -d lib

lib/public: public
	mkdir -p lib/public
	cp -R public lib/
	node_modules/.bin/babel public -d lib/public

.PHONY: lint
lint:
	node_modules/.bin/eslint src public

.PHONY: clean
clean:
	rm -rf lib

.PHONY: run
run:
	node lib/main.js
