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

Then serve the contents of `./target/deploy` and navigate to `index.html` using a modern
browser. (E.g., if you have Ruby installed, you'd do

```sh
ruby -run -e httpd target/deploy
```

and then navigate to `localhost:8080`.)
