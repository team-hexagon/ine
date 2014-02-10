# Create With DBServerCreater:RintIanTta
# ModelName: User
# 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 스키마를 정의합니다.
UserSchema = new Schema
    login:
        type: String
        trim: true
        lowercase: true
        required: true
        unique: true
    password:
        type: String
        required: true
    _create_events: [{
        type: ObjectId
        ref: "Event"
    }]
    _replies: [{
        type: ObjectId
        ref: "Reply"
    }]
    _reviews: [{
        type: ObjectId
        ref: "Review"
    }]
    create_at:
        type: Number
        default: Date.now

# 모델을 생성합니다.
User = mongoose.model "User", UserSchema

# 모듈을 생성합니다.
module.exports = User