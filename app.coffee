# ����� �����մϴ�.
express = require "express"
http = require "http"
path = require "path"
routes = require "./routes"

# ������ �����մϴ�.
app = express()
log = console.log

# ������ �����մϴ�.
app.set "port", process.env.PORT or 3000
app.set "views", path.join __dirname, "views"
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger "dev"
app.use express.bodyParser()
app.use express.cookieParser "your secret here"
app.use express.session()
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static path.join __dirname, "public"
app.use express.errorHandler if "development" is app.get "env" 

# ���Ʈ�մϴ�.
routes.active app

# ������ �����մϴ�.
server = http.createServer app
port = app.get "port"
server.listen port, () ->
    log "Express server listening on port " + app.get "port"
