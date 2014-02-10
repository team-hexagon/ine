# Create With DBServerCreater:RintIanTta
# ModelName: Reply
# 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 스키마를 정의합니다.
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

# 모델을 생성합니다.
Reply = mongoose.model "Reply", ReplySchema

# 모듈을 생성합니다.
module.exports = Reply