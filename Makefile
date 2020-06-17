all:
	cp -rf public/ build
	elm make src/Main.elm --output build/main.js

clean:
	rm -rf build/
