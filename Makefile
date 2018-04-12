UNAME?=$(shell uname)
DOCKER?= true

ifeq ($(UNAME), Linux)
	TOOLCHAIN_TRIPLE = -x86_64-unknown-linux-gnu
endif
ifeq ($(UNAME), Darwin)
	TOOLCHAIN_TRIPLE = -x86_64-apple-darwin
endif

TOOLCHAIN_DATE = -2018-04-07

TOOLCHAIN = nightly${TOOLCHAIN_DATE}${TOOLCHAIN_TRIPLE}

.PHONY: all
all: node_modules/typescript/bin/tsc
	cargo +${TOOLCHAIN} build --release --target wasm32-unknown-unknown
	wasm-bindgen target/wasm32-unknown-unknown/release/rust_wasm.wasm \
		--typescript \
		--browser \
		--out-dir .
	# ./node_modules/typescript/bin/tsc site.ts --lib es6 --module es2015 --declaration --pretty
	# Might be pointless...might already be run
	wasm-gc rust_wasm_bg.wasm rust_wasm_bg.wasm
	# Workaround for Chrome
	wasm2es6js --base64 --output rust_wasm_bg.js rust_wasm_bg.wasm
# wasm2es6js --base64 -o hello_world_bg.js hello_world_bg.wasm
	rm rust_wasm_bg.wasm


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
