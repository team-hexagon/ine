# Create With DBServerCreater:RintIanTta
# ModelName: Reply
# ����� �����մϴ�.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# ��Ű���� �����մϴ�.
ReplySchema = new Schema
    _author:
        type: ObjectId
        ref: "User"
    content:
        type: String
        trim: true
        required: true
    _comments: [{
        type: ObjectId
        ref: "Reply"
    }]
    create_at:
        type: Number
        default: Date.now

# ���� �����մϴ�.
Reply = mongoose.model "Reply", ReplySchema

# ����� �����մϴ�.
module.exports = Reply