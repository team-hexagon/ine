# Create With DBServerCreater:RintIanTta
# ModelName: Event
# 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 스키마를 정의합니다.
EventSchema = new Schema
    title:
        type: String
        trim: true
        required: true
    content:
        type: String
        required: true
    _category:
        type: ObjectId
        ref: "Category"
    _author:
        type: ObjectId
        ref: "User"
        required: true
    create_at:
        type: Number
        default: Date.now
    price:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > 0
            message: "0 이하 불가"
    address: 
        type: String
        trim: true
        required: true
    location:
        type: String
        trim: true
        required: true
    latitude:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > 0
            message: "0 이하 불가"
    longitude:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > 0
            message: "0 이하 불가"
    max_participators:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > 0
            message: "0 이하 불가"
    _participators:
        type: [{
            type: ObjectId
            ref: "User"
        }]
    due_day_start:
        type: Number
        required: true
        default: Date.now
    due_day_end:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > Date.now()
            message: "현재 시간 이후 가능"
    on_day_start:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > Date.now()
            message: "현재 시간 이후 가능"
    on_day_end:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > Date.now()
            message: "현재 시간 이후 가능"
    _foursquare:
        type: ObjectId
    _replies: [{
        type: ObjectId
        ref: "Reply"
    }]
    _reviews: [{
        type: ObjectId
        ref: "Review"
    }]

# 모델을 생성합니다.
Event = mongoose.model "Event", EventSchema

# 모듈을 생성합니다.
module.exports = Event