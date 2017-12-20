TOOLCHAIN_DATE = 2017-12-15-
TOOLCHAIN = nightly-${TOOLCHAIN_DATE}x86_64-unknown-linux-gnu
# TOOLCHAIN = nightly-${TOOLCHAIN_DATE}x86_64-apple-darwin

.PHONY: all
all:
	cargo +${TOOLCHAIN} build --release --target wasm32-unknown-unknown
	wasm-bindgen target/wasm32-unknown-unknown/release/rust_wasm.wasm \
		--output-ts site.ts \
		--output-wasm site.wasm
	./node_modules/typescript/bin/tsc site.ts --lib es6 --module es2015 --declaration --pretty
	mkdir --parents site
	cp index.html site/
	mv site.js site/
	# Might be pointless...might already be run
	wasm-gc site.wasm site/site.wasm

.PHONY: install
install:
	rustup update
	rustup toolchain install ${TOOLCHAIN}
	rustup target add wasm32-unknown-unknown --toolchain ${TOOLCHAIN}
	which wasm-bindgen > /dev/null || cargo +${TOOLCHAIN} install --git https://github.com/alexcrichton/wasm-bindgen
	which wasm-gc > /dev/null || cargo +${TOOLCHAIN} install --git https://github.com/alexcrichton/wasm-gc
	# cargo +${TOOLCHAIN} install --force --git https://github.com/alexcrichton/wasm-bindgen
	# cargo +${TOOLCHAIN} install --force --git https://github.com/alexcrichton/wasm-gc
	npm install typescript @types/webassembly-js-api @types/text-encoding

.PHONY: clean
clean:
	cargo clean
	rm --recursive --force site
