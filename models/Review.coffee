# Create With DBServerCreater:RintIanTta
# ModelName: Review
# ����� �����մϴ�.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# ��Ű���� �����մϴ�.
ReviewSchema = new Schema
    _author:
        type: ObjectId
        ref: "User"
    title:
        type: String
        trim: true
        required: true    
    content:
        type: String
        trim: true
        required: true
    _comments: [{
        type: ObjectId
        ref: "Review"
    }]
    create_at:
        type: Number
        default: Date.now

# ���� �����մϴ�.
Review = mongoose.model "Review", ReviewSchema

# ����� �����մϴ�.
module.exports = Review