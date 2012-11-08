require.config({
  hbs: {
    disableI18n: true
  },
  shim: {
    underscore: {
      exports: "_"
    },
    backbone: {
      deps: ["underscore", "jquery"],
      exports: "Backbone"
    },
    "socket.io": {
      exports: "io"
    },
    "backbone.io": {
      deps: ["backbone", "socket.io"],
      exports: "Backbone.io"
    },
    "uri": {
      exports: "URI"
    },
    "iscroll": {
      exports: "iScroll"
    }
  },
  paths: {
    jquery: "vendor/jquery",
    handlebars: "vendor/handlebars",
    json2: "vendor/json2",
    i18nprecompile: "vendor/i18nprecompile",
    underscore: "vendor/underscore",
    "underscore.string": "vendor/underscore.string",
    backbone: "vendor/backbone",
    moment: "vendor/moment",
    "moment-fi": "vendor/moment-fi",
    uri: "vendor/URI",
    "socket.io": "vendor/socket.io",
    "backbone.io": "vendor/backbone.io",
    "coffee-script": "vendor/coffee-script",
    "backbone.sharedcollection": "vendor/backbone.sharedcollection/src/backbone.sharedcollection",
    spin: "vendor/spin",
    iscroll: "vendor/iscroll"
  }
});
