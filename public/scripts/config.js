require.config({
  hbs: {
    disableI18n: true
  },
  shim: {
    backbone: {
      deps: ["underscore", "jquery"],
      exports: "Backbone"
    },
    "socket.io": {
      exports: "io"
    },
    sockjs: {
      exports: "SockJS"
    },
    "uri": {
      exports: "URI"
    },
    "iscroll": {
      exports: "iScroll"
    },
    "progress": {
      exports: "Progress"
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
    iscroll: "vendor/iscroll",
    "backbone.viewmaster": "vendor/backbone.viewmaster/backbone.viewmaster",
    sockjs: "vendor/sockjs",
    progress: "vendor/progress"
  }
});
