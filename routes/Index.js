(function() {
  var Category, Event, LIMIT, Reply, Review, User, createCategory, createHash, crypto, log, models;

  crypto = require("crypto");

  models = require("../models");

  log = console.log;

  Category = models.Category;

  Event = models.Event;

  Reply = models.Reply;

  Review = models.Review;

  User = models.User;

  LIMIT = 10;

  createHash = function(input) {
    var hash;
    if (!input) {
      return null;
    }
    hash = crypto.createHash("sha1");
    hash.update(input);
    return hash.digest("hex");
  };

  createCategory = function() {
    return Category.remove(function() {
      return [].forEach(function(name) {
        return Category.create({
          name: name
        }, function(error, category) {
          log("create category " + name);
          return log(category);
        });
      });
    });
  };

  exports.active = function(app) {
    app.get("/category", function(request, response, next) {
      return Category.find(function(error, items) {
        if (error) {
          return next(error);
        }
        return response.send(items);
      });
    });
    app.post("/category", function(request, response, next) {
      var name;
      name = request.param("name");
      if (!name) {
        return next("no category name");
      }
      return Category.create({
        name: name
      }, function(error, category) {
        if (error) {
          return next(error);
        }
        return response.send(category);
      });
    });
    app.get("/event", function(request, response, next) {
      var category, page, skip;
      page = request.param("page");
      category = request.param("category");
      page = Number(page || 0);
      skip = page * LIMIT;
      if (!category) {
        return Event.find({}, null, {
          skip: skip,
          limit: LIMIT
        }).populate("_author _category _participators _replies _reviews").exec(function(error, items) {
          if (error) {
            return next(error);
          }
          return response.send(items);
        });
      } else {
        return Category.findOne({
          name: category
        }, function(error, category) {
          if (error) {
            return next(error);
          }
          if (!category) {
            return next("no category");
          }
          return Event.find({
            _category: category._id
          }, null, {
            skip: skip,
            limit: LIMIT
          }).populate("_author _category _participators _replies _reviews").exec(function(error, items) {
            if (error) {
              return next(error);
            }
            return response.send(items);
          });
        });
      }
    });
    app.get("/event/:id", function(request, response, next) {
      var id;
      id = request.param("id");
      return Event.findById(id, function(error, event) {
        if (error) {
          return next(error);
        }
        if (!event) {
          return next("no event");
        }
        return response.send(event);
      });
    });
    app.post("/event/create", function(request, response, next) {
      var address, category, content, due_day_end, due_day_start, latitude, location, longitude, max_participators, on_day_end, on_day_start, price, title;
      if (!request.session.user) {
        return next("not login");
      }
      title = request.param("title");
      content = request.param("content");
      category = request.param("category");
      price = Number(request.param("price"));
      address = request.param("address");
      location = request.param("location");
      latitude = Number(request.param("latitude"));
      longitude = Number(request.param("longitude"));
      max_participators = Number(request.param("max_participators"));
      due_day_start = request.param("due_day_start");
      due_day_end = request.param("due_day_end");
      on_day_start = request.param("on_day_start");
      on_day_end = request.param("on_day_end");
      if (!title) {
        return next("no title");
      }
      if (!content) {
        return next("no content");
      }
      if (!category) {
        return next("no category");
      }
      if (!address) {
        return next("no address");
      }
      if (!location) {
        return next("no location");
      }
      if (!latitude) {
        return next("no latitude");
      }
      if (!longitude) {
        return next("no longitude");
      }
      if (!max_participators) {
        return next("no max_participators");
      }
      if (!due_day_end) {
        return next("no due_day_end");
      }
      if (!on_day_start) {
        return next("no on_day_start");
      }
      if (!on_day_end) {
        return next("no on_day_end");
      }
      if (due_day_end < due_day_start) {
        return next("date errorA");
      }
      if (on_day_start < due_day_end) {
        return next("date errorB");
      }
      return Category.findOne({
        name: category
      }, function(error, category) {
        if (error) {
          return next(error);
        }
        if (!category) {
          return next("no category");
        }
        return Event.create({
          title: title.trim(),
          content: content.trim(),
          _category: category._id,
          _author: request.session.user._id,
          price: price,
          address: address.trim(),
          location: location.trim(),
          latitude: latitude,
          longitude: longitude,
          max_participators: max_participators,
          _participators: [request.session.user._id],
          due_day_start: due_day_start,
          due_day_end: due_day_end,
          on_day_start: on_day_start,
          on_day_end: on_day_end
        }, function(error, event) {
          if (error) {
            return next(error);
          }
          return response.send(event);
        });
      });
    });
    app.get("/reply", function(request, response, next) {
      return Reply.find(function(error, items) {
        if (error) {
          return next(error);
        }
        return response.send(items);
      });
    });
    app.post("/reply", function(request, response, next) {
      var content, _author, _id;
      _id = request.param("_id");
      _author = request.param("_author");
      content = request.param("content");
      return Reply.find(function(error, items) {
        if (error) {
          return next(error);
        }
        return response.send(items);
      });
    });
    app.post("/reply/:id", function(request, response, next) {
      var content, id, _author;
      id = request.param("id");
      _author = request.param("_author");
      content = request.param("content");
      return Reply.findById(id, function(error, targetReply) {
        if (error) {
          return next(error);
        }
        if (!targetReply) {
          return next("no reply");
        }
        return Reply.create({
          _author: author,
          content: content
        }, function(error, reply) {
          if (error) {
            return next(error);
          }
          targetReply._comment.push(reply._id);
          return targetReply.save(function(error) {
            if (error) {
              return next(error);
            }
            return response.send(reply);
          });
        });
      });
    });
    app.get("/review", function(request, response, next) {
      return Review.find(function(error, items) {
        if (error) {
          return next(error);
        }
        return response.send(items);
      });
    });
    app.post("/review", function(request, response, next) {
      return Review.find(function(error, items) {
        if (error) {
          return next(error);
        }
        return response.send(items);
      });
    });
    app.get("/user", function(request, response, next) {
      return User.find(function(error, items) {
        if (error) {
          return next(error);
        }
        return response.send(items);
      });
    });
    app.get("/user/me", function(request, response, next) {
      if (!request.session.user) {
        return next("not login");
      }
      return response.send(request.session.user);
    });
    app.post("/user/create", function(request, response, next) {
      var login, password;
      login = request.param("login");
      password = request.param("password");
      return User.create({
        login: login,
        password: createHash(password)
      }, function(error, user) {
        if (error) {
          return next(error);
        }
        return response.send(user);
      });
    });
    app.post("/user/login", function(request, response, next) {
      var login, password;
      login = request.param("login");
      password = request.param("password");
      if (!login) {
        next("no login");
      }
      if (!password) {
        next("no password");
      }
      return User.findOne({
        login: login
      }, function(error, user) {
        if (error) {
          return next(error);
        }
        if (!user) {
          return next("no user");
        }
        log(user);
        log(password);
        password = createHash(password);
        log(user.password);
        log(password);
        if (password === user.password) {
          request.session.user = user;
          return response.send("success");
        } else {
          return next("not match password");
        }
      });
    });
    app.get("/user/logout", function(request, response, next) {
      request.session.user = null;
      return response.send("success");
    });
    return app.get("/user/:id", function(request, response, next) {
      var id;
      id = request.param("id");
      return User.findById(id).populate("_reviews _replies _create_events").exec(function(error, user) {
        if (error) {
          return next(error);
        }
        if (!user) {
          return next("no user");
        }
        return response.send(user);
      });
    });
  };

}).call(this);
