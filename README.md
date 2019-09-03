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

Then serve the contents of the current directory and navigate to `index.html`
using a modern browser. (E.g., if you have `microserver` installed, you'd do

```sh
microserver --port 8000
```

(To install microserver, run `cargo install microserver`.)

and then navigate to `localhost:8080`.)
