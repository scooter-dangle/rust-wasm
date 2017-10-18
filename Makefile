all:
	cargo +stable build --release --target wasm32-unknown-emscripten --manifest-path wasm-ffi/Cargo.toml
	mkdir --parents target/site
	cp wasm-ffi/index.html target/site/
	find target/wasm32-unknown-emscripten/release/deps -type f -name "*.wasm" | xargs -I '{}' cp '{}' target/site/site.wasm
	find target/wasm32-unknown-emscripten/release/deps -type f ! -name "*.asm.js" -name "*.js" | xargs -I '{}' cp '{}' target/site/site.js
.PHONY: all

clean:
	cargo clean
	rm --recursive --force target/site
.PHONY: clean
