# functions

# $(call filter-partials,file-list)
# Removes underscore-prefixed files from file-list
define filter-partials
	$(foreach file,\
		$1,\
		$(eval FILE=$(notdir $(file)))\
			$(if $(FILE:_%=),$(file)))
endef

# $(call get-jshintignore-patterns,file-list)
# Changes .jshintignore entries from file-list into make-compatible patterns
# TODO handle glob pattern
define get-jshintignore-patterns
	$(foreach entry,\
		$1,\
		$(shell test -d "$(entry)" &&\
			echo $(entry:%/=%)/%\
		)\
		$(shell test -f "$(entry)" &&\
			echo $(entry)\
		)\
	)
endef

# settings
SRC_HBS_PATH = src/handlebars
SRC_HBS = $(shell find $(SRC_HBS_PATH) -type f -name '*.hbs')
BUILD_HBS_PATH = src/js/templates
BUILD_HBS = $(subst $(SRC_HBS_PATH),$(BUILD_HBS_PATH),$(SRC_HBS:.hbs=.js))

SRC_JS_PATH = src/js
SRC_JS = $(shell find $(SRC_JS_PATH) -type f -name '*.js')
BUILD_JS_PATH = static/js
BUILD_JS = $(addprefix $(BUILD_JS_PATH)/,\
	vendor/require.js\
	main.js\
	)

SRC_SCSS_PATH = src/scss
SRC_SCSS = $(shell find $(SRC_SCSS_PATH) -type f -name '*.scss')
BUILD_CSS_PATH = static/css
BUILD_CSS = $(call filter-partials,\
	$(subst $(SRC_SCSS_PATH),$(BUILD_CSS_PATH),$(SRC_SCSS:.scss=.css)))

SRC_SCSS_FONTS = $(SRC_SCSS_PATH)/partials/_fonts.scss
BUILD_FONTS_PATH = static/fonts

SRC_SCSS_VENDOR_PATH = $(SRC_SCSS_PATH)/vendor
SRC_SCSS_VENDOR = $(SRC_SCSS_VENDOR_PATH)/_normalize.scss
SRC_JS_VENDOR_PATH = $(SRC_JS_PATH)/vendor
SRC_JS_VENDOR = $(addprefix $(SRC_JS_VENDOR_PATH)/,\
	backbone.js\
	handlebars.runtime.amd.js\
	jquery.js\
	require.js\
	underscore.js\
	)

# targets

all: lint test build

build: $(BUILD_HBS) $(BUILD_CSS) $(BUILD_JS)

clean:
	rm -rfv\
		$(BUILD_CSS_PATH)\
		$(BUILD_FONTS_PATH)\
		$(BUILD_HBS_PATH)\
		$(BUILD_JS_PATH)\
		$(SRC_SCSS_FONTS)\

distclean: clean
	rm -rfv\
		$(SRC_JS_VENDOR_PATH)\
		$(SRC_SCSS_VENDOR_PATH)\
		node_modules\

lint: lint-js lint-travis
lint-js: makedeps/jshint.d
lint-travis: makedeps/travis-lint.d

test: $(SRC_JS_VENDOR) $(BUILD_HBS) node_modules/karma/bin/karma
	./node_modules/karma/bin/karma start

# file rules

$(BUILD_CSS_PATH)/%.css: $(SRC_SCSS_PATH)/%.scss $(SRC_SCSS) $(SRC_SCSS_FONTS) $(SRC_SCSS_VENDOR) makedeps/gemfile.d
	mkdir -p "$(@D)"
	sass --style compressed -I $(SRC_SCSS_PATH) -r sass-import_once $< $@

$(BUILD_HBS_PATH)/%.js: $(SRC_HBS_PATH)/%.hbs node_modules/.bin/handlebars
	mkdir -p "$(@D)"
	./node_modules/.bin/handlebars $< --output $@ --amd

$(BUILD_JS_PATH)/%.js: $(SRC_JS_VENDOR) $(SRC_JS) node_modules/.bin/r.js
	mkdir -p "$(@D)"
	./node_modules/.bin/r.js -o build-config.js name=$(basename $(@:$(BUILD_JS_PATH)/%=%)) out=$@

$(BUILD_JS_PATH)/require.js: node_modules/requirejs/require.js
	mkdir -p "$(@D)"
	cp ./node_modules/requirejs/require.js $@

$(SRC_JS_VENDOR_PATH)/backbone.js: node_modules/backbone/backbone.js
$(SRC_JS_VENDOR_PATH)/handlebars.runtime.amd.js: node_modules/handlebars/dist/handlebars.runtime.amd.js
$(SRC_JS_VENDOR_PATH)/jquery.js: node_modules/jquery/dist/jquery.js
$(SRC_JS_VENDOR_PATH)/require.js: node_modules/requirejs/require.js
$(SRC_JS_VENDOR_PATH)/underscore.js: node_modules/underscore/underscore.js
$(SRC_SCSS_VENDOR_PATH)/_normalize.scss: node_modules/normalize.css/normalize.css
$(SRC_JS_VENDOR) $(SRC_SCSS_VENDOR):
	mkdir -p "$(@D)"
	cp $? $@

$(SRC_SCSS_FONTS): node_modules/.bin/webfont-dl
	./node_modules/.bin/webfont-dl\
		"http://fonts.googleapis.com/css?family=Libre+Baskerville:400,700,400italic|Lato:300,400,700"\
		--css-rel=/$(BUILD_FONTS_PATH)\
		--font-out=$(BUILD_FONTS_PATH)\
		--out $@

node_modules: package.json
	npm install
	touch $@
node_modules/%: node_modules
	touch $@

makedeps/gemfile.d: Gemfile
	mkdir -p "$(@D)"
	bundle install
	touch $@

JSHINTIGNORE_ENTRIES = $(shell cat .jshintignore | sed 's/^\s*//' | sed '/^\#/d')
JSHINT_IGNORE_PATTERNS = $(call get-jshintignore-patterns,$(JSHINTIGNORE_ENTRIES))
JSHINT_JS_DEPENDENCIES = $(filter-out $(JSHINT_IGNORE_PATTERNS), $(SRC_JS))
makedeps/jshint.d: .jshintignore .jshintrc $(JSHINT_JS_DEPENDENCIES) node_modules/.bin/jshint
	mkdir -p "$(@D)"
	./node_modules/.bin/jshint $(SRC_JS_PATH)
	touch $@

makedeps/travis-lint.d: .travis.yml makedeps/gemfile.d
	mkdir -p "$(@D)"
	travis-lint
	touch $@

# performance settings

# turn off built-in implicit rules
MAKEFLAGS = --no-builtin-rules

# delete default suffixes
.SUFFIXES:

# declare phony targets
.PHONY: all build clean distclean lint lint-js lint-travis test
