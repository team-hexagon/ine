# ����� �����մϴ�.
crypto = require "crypto"
models = require "../models"
log = console.log

# ���� �����մϴ�.
Category = models.Category
Event = models.Event
Reply = models.Reply
Review = models.Review
User = models.User

# ���� ������ �����մϴ�.
LIMIT = 10

# ���� �Լ��� �����մϴ�.
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
            
# ���Ʈ�մϴ�.
exports.active = (app) ->
    # ī�װ� ����
    app.get "/category", (request, response, next) ->
        # �����ͺ��̽� ��û�� �����մϴ�.
        Category.find (error, items) ->
            return next error if error
            response.send items
    app.post "/category", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        name = request.param "name"
        # ��ȿ�� �˻縦 �����մϴ�.
        return next "no category name" unless name
        # �����ͺ��̽� ��û�� �����մϴ�.
        Category.create
            name: name
        , (error, category) ->
            return next error if error
            response.send category
    # �̺�Ʈ ����
    app.get "/event", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        page = request.param "page"
        category = request.param "category"
        # ��û �Ű� ������ �����մϴ�.
        page = Number page or 0
        skip = page * LIMIT
        # �����ͺ��̽� ��û�� �����մϴ�.
        unless category
            # ī�װ��� �������� ���� ���
            Event.find({}, null, {
                skip: skip
                limit: LIMIT
            }).populate("_author _category _participators _replies _reviews").exec (error, items) ->
                return next error if error
                response.send items
        else
            # ī�װ��� ������ ���
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
        # ����� �˻�
        return next "not login" unless request.session.user
        # ��û �Ű� ������ �����մϴ�.
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
        # ���� �˻縦 �����մϴ�.
        return next "no title" unless title
        return next "no content" unless content
        return next "no category" unless category
        return next "no address" unless address
        return next "no location" unless location
        return next "no latitude" unless latitude
        return next "no longitude" unless longitude
        return next "no max_participators" unless max_participators
        # return next "no due_day_start" unless due_day_start # ��� �ڵ����� ���Ե˴ϴ�.
        return next "no due_day_end" unless due_day_end
        return next "no on_day_start" unless on_day_start
        return next "no on_day_end" unless on_day_end
        # �ð� ��ȿ�� �˻縦 �����մϴ�.
        return next "date errorA" if due_day_end < due_day_start
        return next "date errorB" if on_day_start < due_day_end
        # ī�װ� Ȯ��
        Category.findOne
            name: category
        , (error, category) ->
            return next error if error
            return next "no category" unless category
            # �̺�Ʈ�� �����մϴ�.
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
    
    # ��� ����
    app.get "/reply", (request, response, next) ->
        # �����ͺ��̽� ��û�� �����մϴ�.
        Reply.find (error, items) ->
            return next error if error
            response.send items
    app.post "/reply", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        _id = request.param "_id"
        _author = request.param "_author"
        content = request.param "content"
        # �����ͺ��̽� ��û�� �����մϴ�.
        Reply.find (error, items) ->
            return next error if error
            response.send items
    app.post "/reply/:id", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        id = request.param "id"
        _author = request.param "_author"
        content = request.param "content"
        # �����ͺ��̽� ��û�� �����մϴ�.
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
    # ���� ����
    app.get "/review", (request, response, next) ->
        Review.find (error, items) ->
            return next error if error
            response.send items
    app.post "/review", (request, response, next) ->
        # {��� �̱���}
        Review.find (error, items) ->
            return next error if error
            response.send items

    # ����� ����
    app.get "/user", (request, response, next) ->
        User.find (error, items) ->
            return next error if error
            response.send items
    app.get "/user/me", (request, response, next) ->
        return next "not login" unless request.session.user
        response.send request.session.user
    app.post "/user/create", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        login = request.param "login"
        password = request.param "password"
        # ����ڸ� �����մϴ�.
        User.create
            login: login
            password: createHash password
        , (error, user) ->
            return next error if error
            response.send user
    app.post "/user/login", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        login = request.param "login"
        password = request.param "password"
        # ��ȿ�� �˻縦 �����մϴ�.
        next "no login" unless login
        next "no password" unless password
        # ����ڸ� �����մϴ�.
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
        # ������ �����մϴ�.
        request.session.user = null
        response.send "success"
    app.get "/user/:id", (request, response, next) ->
        # ��û �Ű� ������ �����մϴ�.
        id = request.param "id"
        # �����ͺ��̽� ��û�� �����ϴϴ�.
        User.findById(id).populate("_reviews _replies _create_events").exec (error, user) ->
            return next error if error
            return next "no user" unless user
            response.send user