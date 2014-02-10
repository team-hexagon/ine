(function() {
  var ObjectId, Reply, ReplySchema, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  ReplySchema = new Schema({
    _author: {
      type: ObjectId,
      ref: "User"
    },
    content: {
      type: String,
      trim: true,
      required: true
    },
    _comments: [
      {
        type: ObjectId,
        ref: "Reply"
      }
    ],
    create_at: {
      type: Number,
      "default": Date.now
    }
  });

  Reply = mongoose.model("Reply", ReplySchema);

  module.exports = Reply;

}).call(this);
