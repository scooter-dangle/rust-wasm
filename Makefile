all:
	cargo +stable build --release --target wasm32-unknown-emscripten --verbose
	mkdir --parents site
	cp index.html site/
	find target/wasm32-unknown-emscripten/release/deps -type f -name "*.wasm" | xargs -I '{}' cp '{}' site/site.wasm
	find target/wasm32-unknown-emscripten/release/deps -type f ! -name "*.asm.js" -name "*.js" | xargs -I '{}' cp '{}' site/site.js
.PHONY: all

clean:
	cargo clean
	rm --recursive --force site
.PHONY: clean
