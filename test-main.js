var allTestFiles = [];
var TEST_REGEXP = /(spec|test)\.js$/i;

var pathToModule = function(path) {
    return path.replace(/^\/base\//, '../../').replace(/\.js$/, '');
};

Object.keys(window.__karma__.files).forEach(function(file) {
    if (TEST_REGEXP.test(file)) {
        // Normalize paths to RequireJS module names.
        allTestFiles.push(pathToModule(file));
    }
});

require.config({
    baseUrl: '/base/src/js',
    map: {
      '*': { 'jquery': 'jquery-noconflict' },
      'jquery-noconflict': { 'jquery': 'jquery' },
    },
    paths: {
        'backbone': 'vendor/backbone',
        'handlebars.runtime': 'vendor/handlebars.runtime.amd',
        'jquery': 'vendor/jquery',
        'jquery-noconflict': 'lib/jquery-noconflict',
        'underscore': 'vendor/underscore',
    },

    // dynamically load all test files
    deps: allTestFiles,

    // we have to kickoff jasmine, as it is asynchronous
    callback: window.__karma__.start
});
