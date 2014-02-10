# 모듈을 추출합니다.
crypto = require "crypto"
models = require "../models"
log = console.log

# 모델을 추출합니다.
Category = models.Category
Event = models.Event
Reply = models.Reply
Review = models.Review
User = models.User

# 전역 변수를 생성합니다.
LIMIT = 10

# 보조 함수를 생성합니다.
createHash = (input) ->
    return null unless input
    hash = crypto.createHash "sha1"
    hash.update input
    return hash.digest "hex"
createCategory = () ->
    Category.remove () ->
        [].forEach (name) ->
            Category.create
                name: name
            , (error, category) ->
                log "create category #{name}"
                log category
            
# 라우트합니다.
exports.active = (app) ->
    # 카테고리 관련
    app.get "/category", (request, response, next) ->
        # 데이터베이스 요청을 수행합니다.
        Category.find (error, items) ->
            return next error if error
            response.send items
    app.post "/category", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        name = request.param "name"
        # 유효성 검사를 수행합니다.
        return next "no category name" unless name
        # 데이터베이스 요청을 수행합니다.
        Category.create
            name: name
        , (error, category) ->
            return next error if error
            response.send category
    # 이벤트 관련
    app.get "/event", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        page = request.param "page"
        category = request.param "category"
        # 요청 매개 변수를 보완합니다.
        page = Number page or 0
        skip = page * LIMIT
        # 데이터베이스 요청을 수행합니다.
        unless category
            # 카테고리를 지정하지 않은 경우
            Event.find({}, null, {
                skip: skip
                limit: LIMIT
            }).populate("_author _category _participators _replies _reviews").exec (error, items) ->
                return next error if error
                response.send items
        else
            # 카테고리를 지정한 경우
            Category.findOne
                name: category
            , (error, category) ->
                return next error if error
                return next "no category" unless category
                Event.find({
                    _category: category._id
                }, null, {
                    skip: skip
                    limit: LIMIT
                }).populate("_author _category _participators _replies _reviews").exec (error, items) ->
                    return next error if error
                    response.send items
    app.get "/event/:id", (request, response, next) ->
        id = request.param "id"
        Event.findById id, (error, event) ->
            return next error if error
            return next "no event" unless event
            response.send event
    app.post "/event/create", (request, response, next) ->
        # 사용자 검사
        return next "not login" unless request.session.user
        # 요청 매개 변수를 추출합니다.
        title = request.param "title"
        content = request.param "content"
        category = request.param "category"
        price = Number request.param "price"
        address = request.param "address"
        location = request.param "location"
        latitude = Number request.param "latitude"
        longitude = Number request.param "longitude"
        max_participators = Number request.param "max_participators"
        due_day_start = request.param "due_day_start"
        due_day_end = request.param "due_day_end"
        on_day_start = request.param "on_day_start"
        on_day_end = request.param "on_day_end"
        # 존재 검사를 수행합니다.
        return next "no title" unless title
        return next "no content" unless content
        return next "no category" unless category
        return next "no address" unless address
        return next "no location" unless location
        return next "no latitude" unless latitude
        return next "no longitude" unless longitude
        return next "no max_participators" unless max_participators
        # return next "no due_day_start" unless due_day_start # 없어도 자동으로 기입됩니다.
        return next "no due_day_end" unless due_day_end
        return next "no on_day_start" unless on_day_start
        return next "no on_day_end" unless on_day_end
        # 시간 유효성 검사를 수행합니다.
        return next "date errorA" if due_day_end < due_day_start
        return next "date errorB" if on_day_start < due_day_end
        # 카테고리 확인
        Category.findOne
            name: category
        , (error, category) ->
            return next error if error
            return next "no category" unless category
            # 이벤트를 생성합니다.
            Event.create {
                title: title.trim()
                content: content.trim()
                _category: category._id
                _author: request.session.user._id
                price: price
                address: address.trim()
                location: location.trim()
                latitude: latitude
                longitude: longitude
                max_participators: max_participators
                _participators: [request.session.user._id]
                due_day_start: due_day_start
                due_day_end: due_day_end
                on_day_start: on_day_start
                on_day_end: on_day_end
            }, (error, event) ->
                return next error if error
                response.send event
    
    # 댓글 관련
    app.get "/reply", (request, response, next) ->
        # 데이터베이스 요청을 수행합니다.
        Reply.find (error, items) ->
            return next error if error
            response.send items
    app.post "/reply", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        _id = request.param "_id"
        _author = request.param "_author"
        content = request.param "content"
        # 데이터베이스 요청을 수행합니다.
        Reply.find (error, items) ->
            return next error if error
            response.send items
    app.post "/reply/:id", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        id = request.param "id"
        _author = request.param "_author"
        content = request.param "content"
        # 데이터베이스 요청을 수행합니다.
        Reply.findById id, (error, targetReply) ->
            return next error if error
            return next "no reply" unless targetReply
            Reply.create {
                _author: author
                content: content
            }, (error, reply) ->
                return next error if error
                targetReply._comment.push reply._id
                targetReply.save (error) ->
                    return next error if error
                    response.send reply
    # 리뷰 관련
    app.get "/review", (request, response, next) ->
        Review.find (error, items) ->
            return next error if error
            response.send items
    app.post "/review", (request, response, next) ->
        # {기능 미구현}
        Review.find (error, items) ->
            return next error if error
            response.send items

    # 사용자 관련
    app.get "/user", (request, response, next) ->
        User.find (error, items) ->
            return next error if error
            response.send items
    app.get "/user/me", (request, response, next) ->
        return next "not login" unless request.session.user
        response.send request.session.user
    app.post "/user/create", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        login = request.param "login"
        password = request.param "password"
        # 사용자를 생성합니다.
        User.create
            login: login
            password: createHash password
        , (error, user) ->
            return next error if error
            response.send user
    app.post "/user/login", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        login = request.param "login"
        password = request.param "password"
        # 유효성 검사를 수행합니다.
        next "no login" unless login
        next "no password" unless password
        # 사용자를 생성합니다.
        User.findOne {
            login: login
        }, (error, user) ->
            return next error if error
            return next "no user" unless user
            log user
            log password
            password = createHash password
            log user.password
            log password
            if password is user.password
                request.session.user = user
                response.send "success"
            else return next "not match password"
    app.get "/user/logout", (request, response, next) ->
        # 세션을 제거합니다.
        request.session.user = null
        response.send "success"
    app.get "/user/:id", (request, response, next) ->
        # 요청 매개 변수를 추출합니다.
        id = request.param "id"
        # 데이터베이스 요청을 수행하니다.
        User.findById(id).populate("_reviews _replies _create_events").exec (error, user) ->
            return next error if error
            return next "no user" unless user
            response.send user