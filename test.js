(function() {
  var Category, Event, Reply, Review, User, async, createHash, crypto, fs, global, log, models;

  async = require("async");

  fs = require("fs");

  crypto = require("crypto");

  models = require("./models");

  log = console.log;

  createHash = function(input) {
    var hash;
    if (!input) {
      return null;
    }
    hash = crypto.createHash("sha1");
    hash.update(input);
    return hash.digest("hex");
  };

  Category = models.Category;

  Event = models.Event;

  Reply = models.Reply;

  Review = models.Review;

  User = models.User;

  global = {};

  /* 사용자 중복 테스트
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
  */


  async.series({
    reset: function(callback) {
      return async.parallel([
        function(callback) {
          return Category.remove(callback);
        }, function(callback) {
          return User.remove(callback);
        }, function(callback) {
          return Reply.remove(callback);
        }, function(callback) {
          return Review.remove(callback);
        }, function(callback) {
          return Event.remove(callback);
        }
      ], callback);
    },
    create: function(callback) {
      var category, comment, event, reply, review, user;
      category = new Category({
        name: "음식"
      });
      user = new User({
        login: "rintiantta",
        password: createHash("123456789")
      });
      comment = new Reply({
        _author: user._id,
        content: "아 'ㅁ' , 써있군요 'ㅁ' 죄송 'ㅁ'"
      });
      reply = new Reply({
        _author: user._id,
        content: "언제까지 참여 가능한가요 'ㅁ'",
        _comments: [comment._id]
      });
      review = new Review({
        _author: user._id,
        title: "맛있었어요 'ㅁ'",
        content: "사장님이 친절하시군요 'ㅂ'"
      });
      event = new Event({
        title: "홍대 점심 식사 모임",
        content: "<p>Content of HTML</p>",
        _category: category._id,
        _author: user._id,
        price: 10000,
        address: "서울특별시 서대문구",
        location: "인카페",
        latitude: 127.2,
        longitude: 30.1,
        max_participators: 4,
        _participators: [user._id],
        due_day_start: Date.now(),
        due_day_end: Date.now() + 1000 * 60 * 60 * 24 * 1,
        on_day_start: Date.now() + 1000 * 60 * 60 * 24 * 2,
        on_day_end: Date.now() + 1000 * 60 * 60 * 24 * 2 + 1000 * 60 * 60,
        _replies: [reply._id],
        _reviews: [review._id]
      });
      log(event);
      return async.parallel([
        function(callback) {
          return category.save(callback);
        }, function(callback) {
          return user.save(callback);
        }, function(callback) {
          return comment.save(callback);
        }, function(callback) {
          return reply.save(callback);
        }, function(callback) {
          return review.save(callback);
        }, function(callback) {
          return event.save(callback);
        }
      ], function(error) {
        log(error);
        return callback(null);
      });
    },
    populate: function(callback) {
      return Event.find().populate("_author _category _participators _replies _reviews").exec(function(error, items) {
        var output;
        output = JSON.stringify(items, null, 4);
        log(output);
        return callback(null);
      });
    }
  }, function() {
    log(arguments);
    return log("test complete");
  });

}).call(this);
