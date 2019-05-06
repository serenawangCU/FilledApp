//

//

import Foundation
struct User: Codable {
    
    var Picture: String?
     var age: Int
    var email: String
    var gender: String
     var height: String
     var helike :[briefUser]
    var id: Int
       var likedhim: [briefUser]
    var password: String
     var username: String
    
}
struct UserResponse: Codable {
    var data: User
}

struct GetPicture: Codable {
    var url: String
}

struct message: Codable {
    var chat: String
    var id: Int
    
}
struct messages: Codable {
    
    var data: [message]
}

struct PostPicture: Codable {
    var url: String
}
struct multipleUser: Codable{
    var data: [briefUser]
}
struct briefUser: Codable {
    
    var Picture: String?
    var age: Int
    var email: String
    var height: String
    var id: Int
    var username: String
    
}
