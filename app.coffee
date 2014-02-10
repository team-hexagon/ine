# 모듈을 추출합니다.
express = require "express"
http = require "http"
path = require "path"
routes = require "./routes"

# 서버를 생성합니다.
app = express()
log = console.log

# 서버를 설정합니다.
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

# 라우트합니다.
routes.active app

# 서버를 실행합니다.
server = http.createServer app
port = app.get "port"
server.listen port, () ->
    log "Express server listening on port " + app.get "port"
