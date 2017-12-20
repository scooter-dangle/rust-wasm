.PHONY: all
all:
	cargo +nightly-x86_64-apple-darwin build --release --target wasm32-unknown-unknown
	wasm-bindgen target/wasm32-unknown-unknown/release/rust_wasm.wasm \
		--output-ts site.ts \
		--output-wasm site.wasm
	./node_modules/typescript/bin/tsc site.ts --lib es6 --module es2015
	mkdir --parents site
	cp index.html site/
	mv site.js site/
	# Might be pointless...might already be run
	wasm-gc site.wasm site/site.wasm

.PHONY: install
install:
	rustup update
	rustup target add wasm32-unknown-unknown --toolchain nightly-x86_64-apple-darwin
	which wasm-bindgen > /dev/null || cargo +nightly-x86_64-apple-darwin install --git https://github.com/alexcrichton/wasm-bindgen
	which wasm-gc > /dev/null || cargo +nightly-x86_64-apple-darwin install --git https://github.com/alexcrichton/wasm-gc
	npm install typescript @types/webassembly-js-api @types/text-encoding

.PHONY: clean
clean:
	cargo clean
	rm --recursive --force site
