(function() {
  var Category, CategorySchema, ObjectId, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  CategorySchema = new Schema({
    name: {
      type: String,
      trim: true,
      required: true
    },
    children: [
      {
        type: ObjectId,
        ref: "Category"
      }
    ]
  });

  Category = mongoose.model("Category", CategorySchema);

  module.exports = Category;

}).call(this);
