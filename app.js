(function() {
  var app, express, http, log, path, port, routes, server;

  express = require("express");

  http = require("http");

  path = require("path");

  routes = require("./routes");

  app = express();

  log = console.log;

  app.set("port", process.env.PORT || 3000);

  app.set("views", path.join(__dirname, "views"));

  app.set("view engine", "jade");

  app.use(express.favicon());

  app.use(express.logger("dev"));

  app.use(express.bodyParser());

  app.use(express.cookieParser("your secret here"));

  app.use(express.session());

  app.use(express.json());

  app.use(express.urlencoded());

  app.use(express.methodOverride());

  app.use(app.router);

  app.use(express["static"](path.join(__dirname, "public")));

  if ("development" === app.get("env")) {
    app.use(express.errorHandler);
  }

  routes.active(app);

  server = http.createServer(app);

  port = app.get("port");

  server.listen(port, function() {
    return log("Express server listening on port " + app.get("port"));
  });

}).call(this);
