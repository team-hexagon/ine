# Create With DBServerCreater:RintIanTta:index.js
# 모듈을 추출합니다.
mongoose = require "mongoose"
log = console.log

# 데이터베이스 연결을 수행합니다.
mongoose.connect "mongodb://127.0.0.1/inevent", (error) ->
    if error
        console.error "connect error to mongodb://127.0.0.1/inevent"
        process.exit 1

# 모듈을 생성합니다.ㅇㅂㅇ
exports.User = require "./user"
exports.Reply = require "./reply"
exports.Event = require "./event"
exports.Review = require "./review"
exports.Category = require "./category"

