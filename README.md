# [LochlanMcIntosh.com](http://www.lochlanmcintosh.com/)

## Please note that this project is no longer being updated.  This front end has been integrated into my "[LochlanMcIntosh.com](https://github.com/Lochlan/LochlanMcIntosh.com)" repo, a Python/Django project.  Please go there and take a look!


[![Build Status](https://travis-ci.org/Lochlan/LochlanMcIntosh.com-frontend.png?branch=master)](https://travis-ci.org/Lochlan/LochlanMcIntosh.com-frontend)

My personal website!  This repo also serves as a living example of what I think a well-written and modern front-end project might look like, represented by the front-end stack I am partial towards and most experienced with.

This website is powered by:
- [Backbone.js](http://backbonejs.org/)
- [Underscore.js](http://underscorejs.org/)
- [jQuery](http://jquery.com/)
- [Require.js](http://requirejs.org/)
- [Handlebars](http://handlebarsjs.com/)
- [Sass](http://sass-lang.com/)

And tested using:
- [Karma](http://karma-runner.github.io/)
- [Jasmine](http://jasmine.github.io/)

## Building and Testing

```bash
# To install dependencies, lint, test, and compile from source:
make

# To delete compiled files:
make clean

# To start over from scratch (also deleting vendor files, and `node_modules`):
make distclean
```

See [the Makefile](https://github.com/Lochlan/LochlanMcIntosh.com-frontend/blob/master/Makefile) for additional, more granular targets.  Using it requires:

- [GNU Make](http://www.gnu.org/software/make/), preferably 3.81 or better
- [Node.js](http://nodejs.org/) stable and [npm](https://www.npmjs.com/) to install and run most of the build dependencies
- [Ruby](https://www.ruby-lang.org/) and [Bundler](http://bundler.io/) to install and run Sass
