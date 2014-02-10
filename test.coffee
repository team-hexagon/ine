# 모듈을 추출합니다.
async = require "async"
fs = require "fs"
crypto = require "crypto"
models = require "./models"
log = console.log
createHash = (input) ->
    return null unless input
    hash = crypto.createHash "sha1"
    hash.update input
    return hash.digest "hex"

# 모델을 추출합니다.
Category = models.Category
Event = models.Event
Reply = models.Reply
Review = models.Review
User = models.User

# 모델을 생성합니다.
global = {}

### 사용자 중복 테스트
async.series
    reset: (callback) ->
        async.parallel [
            (callback) -> Category.remove callback
            (callback) -> User.remove callback
            (callback) -> Reply.remove callback
            (callback) -> Review.remove callback
            (callback) -> Event.remove callback
        ], callback
    create: (callback) ->
        User.create
            login: "rintiantta"
            password: "123456789"
        , () ->
            User.create
                login: "rintiantta"
                password: "123456789"
            , () ->
                log arguments
###
async.series
    reset: (callback) ->
        async.parallel [
            (callback) -> Category.remove callback
            (callback) -> User.remove callback
            (callback) -> Reply.remove callback
            (callback) -> Review.remove callback
            (callback) -> Event.remove callback
        ], callback
    create: (callback) ->
        category = new Category
            name: "음식"
        user = new User
            login: "rintiantta"
            password: createHash "123456789"
        comment = new Reply
            _author: user._id
            content: "아 'ㅁ' , 써있군요 'ㅁ' 죄송 'ㅁ'"
        reply = new Reply
            _author: user._id
            content: "언제까지 참여 가능한가요 'ㅁ'"
            _comments: [comment._id]
        review = new Review
            _author: user._id
            title: "맛있었어요 'ㅁ'"
            content: "사장님이 친절하시군요 'ㅂ'"
        event = new Event
            title: "홍대 점심 식사 모임"
            content: "<p>Content of HTML</p>"
            _category: category._id
            _author: user._id
            price: 10000
            address: "서울특별시 서대문구"
            location: "인카페"
            latitude: 127.2
            longitude: 30.1
            max_participators: 4
            _participators: [user._id]
            due_day_start: Date.now()
            due_day_end: Date.now() + 1000 * 60 * 60 * 24 * 1
            on_day_start: Date.now() + 1000 * 60 * 60 * 24 * 2
            on_day_end: Date.now() + 1000 * 60 * 60 * 24 * 2 + 1000 * 60 * 60
            _replies: [reply._id]
            _reviews: [review._id]
        log event
        async.parallel [
            (callback) -> category.save callback
            (callback) -> user.save callback
            (callback) -> comment.save callback
            (callback) -> reply.save callback
            (callback) -> review.save callback
            (callback) -> event.save callback
        ], (error) ->
            log error
            callback null
    populate: (callback) ->
        Event.find().populate("_author _category _participators _replies _reviews").exec (error, items) ->
            output = JSON.stringify items, null, 4
            log output
            callback null
, () ->
    log arguments
    log "test complete"
###