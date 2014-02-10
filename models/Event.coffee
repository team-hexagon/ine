# Create With DBServerCreater:RintIanTta
# ModelName: Event
# ����� �����մϴ�.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# ��Ű���� �����մϴ�.
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
            message: "0 ���� �Ұ�"
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
            message: "0 ���� �Ұ�"
    longitude:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > 0
            message: "0 ���� �Ұ�"
    max_participators:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > 0
            message: "0 ���� �Ұ�"
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
            message: "���� �ð� ���� ����"
    on_day_start:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > Date.now()
            message: "���� �ð� ���� ����"
    on_day_end:
        type: Number
        required: true
        validate: 
            validator: (value) -> value > Date.now()
            message: "���� �ð� ���� ����"
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

# ���� �����մϴ�.
Event = mongoose.model "Event", EventSchema

# ����� �����մϴ�.
module.exports = Event