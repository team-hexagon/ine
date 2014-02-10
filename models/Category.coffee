# Create With DBServerCreater:RintIanTta
# ModelName: Category
# ����� �����մϴ�.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# ��Ű���� �����մϴ�.
CategorySchema = new Schema
    name:
        type: String
        trim: true
        required: true
    children: [{
        type: ObjectId
        ref: "Category"
    }]
# ���� �����մϴ�.
Category = mongoose.model "Category", CategorySchema

# ����� �����մϴ�.
module.exports = Category