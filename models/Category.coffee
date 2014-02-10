# Create With DBServerCreater:RintIanTta
# ModelName: Category
# 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

# 스키마를 정의합니다.
CategorySchema = new Schema
    name:
        type: String
        trim: true
        required: true
    children: [{
        type: ObjectId
        ref: "Category"
    }]
# 모델을 생성합니다.
Category = mongoose.model "Category", CategorySchema

# 모듈을 생성합니다.
module.exports = Category