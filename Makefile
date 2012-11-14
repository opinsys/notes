
install: npm-install build

npm-install:
	npm install

build:
	node_modules/.bin/r.js -o mainConfigFile=public/scripts/config.js name=start out=public/scripts/bundle.js
