Basic Rust WebAssembly Mini-page
================================

Sure, I can play around sometimes.

```sh
# fish
docker build . --tag (basename $PWD)
docker run --rm --workdir /src --volume $PWD:/src (basename $PWD) make

# all (or most of) teh others
docker build . --tag $(basename $PWD)
docker run --rm --workdir /src --volume $PWD:/src $(basename $PWD) make
```

Then either serve the contents of `./site` or navigate directly to
`./site/index.html` using a modern browser.
