# slush-coffeescript

[![NPM version][npm-image]][npm-url] [![Dependency Status][daviddm-image]][daviddm-url] [![Dev. Dependency Status][daviddm-dev-image]][daviddm-dev-url]

> Generates a Node module written in CoffeeScript


### Installing

Install `slush-coffeescript` globally:

```bash
$ npm install -g slush-coffeescript
```


### Usage

Create a new folder for your project:

```bash
$ mkdir my-slush-coffeescript
```

Run the generator from within the new folder:

```bash
$ cd my-slush-coffeescript && slush CoffeeScript
```

and answer the proceeding questions.

* _Add bin script for CLI?_

  Answering __yes__ to this question generates an executable script (by default in the `bin` directory) to be run from the command line, which calls a module `cli` to handle processing command-line arguments and running the application.

* _Compile CoffeeScript to JS?_

  Answering __no__ (the default) to this means that the module will contain pure CoffeeScript source and extend Node's `require` function to recognise CoffeeScript modules and automatically compile them at run-time when requested (via the [coffee-script/register](http://coffeescript.org/documentation/docs/register.html) module).

  To have a more traditional module with CoffeeScript source compiled to JavaScript answering __yes__ to this prompt lets you specify a build directory which the included `Gulpfile.js` will build to.


#### Automating module generation

Instead of answering the prompts to configure the generator you can specify the answers in a file called `slush-config.json` in the directory you run the generator from. If the generator finds this file in the current directory when it is run then it reads `slush-config.json` and overrides the default settings with any data it finds.

The following examples show all of the settings the generator currently supports:


###### `slush-config.json`

Basic CoffeeScript module designed to be directly used as a library - compilation is done at run-time.

```js
{
  "app_name": "my-node-lib",
  "app_description": "My CoffeeScript library",
  "app_version": "0.0.1",
  "author_name": "James Skinner",
  "author_email": "spiralx@gmail.com",
  "user_name": "spiralx",
  "license": "MIT",
  "bin": false,
  "compiled": false,
  "source_dir": "lib",
  "test_dir": "test"
}
```


###### `slush-config-cli.json`

A CoffeeScript module that can be run from the command-line and typically installed globally.

```js
{
  "app_name": "my-node-command",
  "app_description": "My CoffeeScript CLI module",
  "bin": true
}
```


###### `slush-config-compiled.json`

A JavaScript module built from CoffeeScript source using the included `gulp` build script.

```js
{
  "app_name": "my-compiled-node-lib",
  "app_description": "My CoffeeScript module",
  "compiled": true,
  "source_dir": "coffee",
  "build_dir": "lib",
  "test_dir": "test"
}
```


__slush-config-both.json__

A module with a CLI script, written in CoffeeScript and compiled to JavaScript.

```js
{
  "bin": true,
  "compiled": true
}
```


### Getting To Know Slush

Slush is a tool that uses Gulp for project scaffolding.

Slush does not contain anything "out of the box", except the ability to locate installed slush generators and to run them with [liftoff](https://github.com/tkellen/node-liftoff).

To find out more about Slush, check out the [documentation](https://github.com/klei/slush).


### Contributing

See the [CONTRIBUTING Guidelines](https://github.com/spiralx/slush-coffeescript/blob/master/CONTRIBUTING.md)


### Support

If you have any problem or suggestion please open an issue [here](https://github.com/spiralx/slush-coffeescript/issues).


### License

> The MIT License
>
> Copyright (c) 2014, James Skinner
>
> Permission is hereby granted, free of charge, to any person
> obtaining a copy of this software and associated documentation
> files (the "Software"), to deal in the Software without
> restriction, including without limitation the rights to use,
> copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the
> Software is furnished to do so, subject to the following
> conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> OTHER DEALINGS IN THE SOFTWARE.

[npm-url]: https://npmjs.org/package/slush-coffeescript
[npm-image]: https://badge.fury.io/js/slush-coffeescript.svg
[daviddm-url]: https://david-dm.org/spiralx/slush-coffeescript
[daviddm-image]: https://david-dm.org/spiralx/slush-coffeescript.svg?theme=shields.io
[daviddm-dev-url]: https://david-dm.org/spiralx/slush-coffeescript#info=devDependencies
[daviddm-dev-image]: https://david-dm.org/spiralx/slush-coffeescript/dev-status.svg?theme=shields.io
