UNAME?=$(shell uname)
DOCKER?= true

ifeq ($(UNAME), Linux)
	TOOLCHAIN_TRIPLE = -x86_64-unknown-linux-gnu
endif
ifeq ($(UNAME), Darwin)
	TOOLCHAIN_TRIPLE = -x86_64-apple-darwin
endif

TOOLCHAIN_DATE = -2017-12-15

TOOLCHAIN = nightly${TOOLCHAIN_DATE}${TOOLCHAIN_TRIPLE}

.PHONY: all
all: node_modules/typescript/bin/tsc
	cargo +${TOOLCHAIN} build --release --target wasm32-unknown-unknown
	wasm-bindgen target/wasm32-unknown-unknown/release/rust_wasm.wasm \
		--output-ts site.ts \
		--output-wasm site.wasm
	./node_modules/typescript/bin/tsc site.ts --lib es6 --module es2015 --declaration --pretty
	mkdir --parents site
	cp index.html site/
	mv site.js site/
	# Might be pointless...might already be run
	# wasm-gc site.wasm site/site.wasm
	cp site.wasm site/site.wasm
	rm site.wasm

node_modules/typescript/bin/tsc:
	# Super lame, but it was easier to get this working when it was installed locally
	npm install --local typescript@2.6.2 @types/webassembly-js-api @types/text-encoding

.PHONY: install
install:
	rustup update
	rustup toolchain install ${TOOLCHAIN}
	rustup target add wasm32-unknown-unknown --toolchain ${TOOLCHAIN}
	which wasm-bindgen > /dev/null || cargo +${TOOLCHAIN} install --git https://github.com/alexcrichton/wasm-bindgen
	which wasm-gc > /dev/null || cargo +${TOOLCHAIN} install --git https://github.com/alexcrichton/wasm-gc

.PHONY: clean
clean:
	cargo clean
	rm --recursive --force site
