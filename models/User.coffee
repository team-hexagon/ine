# Create With DBServerCreater:RintIanTta
# ModelName: User
# ����� �����մϴ�.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# ��Ű���� �����մϴ�.
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

# ���� �����մϴ�.
User = mongoose.model "User", UserSchema

# ����� �����մϴ�.
module.exports = User