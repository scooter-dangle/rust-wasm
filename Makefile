build:
	wasm-pack build \
		--target web \
		--out-name package \
		--dev
.PHONY: build

serve:
	microserver \
		--port 8000
.PHONY: serve
