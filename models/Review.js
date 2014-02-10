(function() {
  var ObjectId, Review, ReviewSchema, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  ReviewSchema = new Schema({
    _author: {
      type: ObjectId,
      ref: "User"
    },
    title: {
      type: String,
      trim: true,
      required: true
    },
    content: {
      type: String,
      trim: true,
      required: true
    },
    _comments: [
      {
        type: ObjectId,
        ref: "Review"
      }
    ],
    create_at: {
      type: Number,
      "default": Date.now
    }
  });

  Review = mongoose.model("Review", ReviewSchema);

  module.exports = Review;

}).call(this);
