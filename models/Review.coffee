# Create With DBServerCreater:RintIanTta
# ModelName: Review
# 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 스키마를 정의합니다.
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

# 모델을 생성합니다.
Review = mongoose.model "Review", ReviewSchema

# 모듈을 생성합니다.
module.exports = Review