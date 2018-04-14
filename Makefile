all: remove_output
	cargo +stable web build --release --target wasm32-unknown-emscripten
	cargo +stable web deploy --release --target wasm32-unknown-emscripten
.PHONY: all

# Lame but for some reason it's necessary for the build/deploy to function
remove_output:
	rm --recursive --force target/wasm32-unknown-emscripten target/deploy
.PHONY: remove_output

clean: remove_output
	cargo clean
.PHONY: clean
