# How to Contribute

Yay, you're interested in helping this thing suck less.  Good for you!

Some things you should be familiar with before getting started

  - [Coffeescript](http://coffeescript.org/)
  - Unit testing (with [QUnit](http://qunitjs.com))
  - [Grunt](http://gruntjs.org) (available via `npm install -g grunt-cli`)
  - [Node/NPM](https://npmjs.org/) (available via homebrew)

## Project Layout

  - `src/`  - Coffeescript Source files
  - `lib/`  - Compiled individual JavaScript files
  - `dist/` - Compiled, Concatinated, and Minified
  - `test/` - Unit Testing Resources


## Development

Once you have NPM and Grunt installed, clone the repository and install all dependancies

    git clone git@.....bubblechart.git bubblechart
    cd bubblechart
    npm install

Then to build a distribution run this grunt task

    grunt dist

This will generate the compiled (and minified) sourc in your `dist/` directory
along with a distributable zip archive.

Any time you change any of the `src/**/*.coffee` files you'll
need to re-run this command.

You can also use

    grunt watch

to automatically recompile and concat the unminified file everytime you
change any of the `src/**/*.coffee` files.

## Testing

### Writing Tests

The `test/` directory mirrors the `src/` directory for test organization, make
sure to organize and produce tests that fit the patterns present.

### Running Tests

    grunt test

## On Contribution

### Be a Chameleon

Try your best to follow the present code formatting and patterns in place.

### Pull Requests

Pull Request requirements

  - Include a clear explaination of the problem (or enhancement)
  - Include a use case that clearly demonstrates said issue (or enhancement)
  - Clean commit history (squash where it makes sense)
  - Relevant Tests (either updated and/or new)

# TODO

A few things it currently lacks that I'd like to see improved

  - Better touch support
  - Responsive interactivity
  - Better handling of a large number of "bubbles"
