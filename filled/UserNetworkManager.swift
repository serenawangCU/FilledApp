//


import Foundation
import Alamofire
import SwiftyJSON
class UserNetworkManager {
    
    private static let signupURL = "http://34.73.46.160/api/users/"
    private static let loginURL = "http://34.73.46.160/api/user/login/"
    private static let messageURL = "http://34.73.46.160/api/chat/"
    private static let updateURL = "http://34.73.46.160/api/user_profile/"
    private static let randomURL = "http://34.73.46.160/api/users/random/"
    private static let likeURL = "http://34.73.46.160/api/user_like/"
    private static let unlikeURL = "http://34.73.46.160/api/user_unlike/"
     private static let updatemessageURL = "http://34.73.46.160/api/chat/add/"
     private static let createchatURL = "http://34.73.46.160/api/chats/"
    static func login(email: String, password: String, completion: @escaping (User) -> Void) {
        let parameter: Parameters = [
            "email" : email ,
            "password": password
        ]
        
         Alamofire.request(loginURL, method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    
                    let jsonDecoder = JSONDecoder()
                    if let user = try? jsonDecoder.decode(UserResponse.self, from: data ) {
                        
                        completion(user.data)
                    } else {
                        print("login Invalid Response Data")
                    }
                }
              
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func signup(email: String, password: String, completion: @escaping (User) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "picture": picturestring
        ]
        Alamofire.request(signupURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    
                }
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(UserResponse.self, from: data) {
                    completion(user.data)
                } else {
                    print("sign up Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

    static func getMessage(id1: Int, id2: Int,completion: @escaping (messages) -> Void) {
        let parameters: [String: Any] = [
            "user_id1": id1,
            "user_id2": id2
            
        ]
        Alamofire.request(messageURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                   
                }
                let jsonDecoder = JSONDecoder()
                if let messages = try? jsonDecoder.decode(messages.self, from: data) {
                    print(messages)
                    completion(messages)
                } else {
                    print("get message Invalid Response Data")
                }
            case .failure(let error):
                print("getmessage\(error.localizedDescription)")
            }
        }
    }
    static func createchat(id1: Int, id2: Int,completion: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "user_id1": id1,
            "user_id2": id2
           
        ]
        Alamofire.request( createchatURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
               
            case .success(let data):
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    
                }
               
                
            case .failure(let error):
                print("create chat \(error.localizedDescription)")
            }
        }
    }
    static func updateMessage(id1: Int, id2: Int, sender: Int,addingmessage: message, completion: @escaping () -> Void) {
        let parameter:[String: Any] = ["user_id1" :id1, "user_id2" : id2, "text" : addingmessage.chat, "sender_id": sender]
        Alamofire.request(updatemessageURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                   
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func updateUser(userid: Int, age : Int, Picture: String, height: String, Username: String, gender: String, completion: @escaping () -> Void) {
        let parameter:[String: Any] = ["id" :userid,
                                       "username": Username,
                                       "age":age,
            "height":height,
            "gender": gender,
            "Picture": Picture
            
        ]
        Alamofire.request(updateURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                print("success")
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func like(homeuserid: Int, guestuserid: Int,completion: @escaping () -> Void) {
        let parameter:[String: Any] = [ "s_id": homeuserid, "r_id": guestuserid]
        Alamofire.request(likeURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func dislike(homeuserid: Int, guestuserid: Int,completion: @escaping () -> Void) {
        let parameter:[String: Any] = [ "s_id": homeuserid, "r_id" : guestuserid]
        Alamofire.request(unlikeURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                   
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    static func getRandom(completion: @escaping ([briefUser]) -> Void) {
       
        Alamofire.request(randomURL, method: .get, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                   
                }
                let jsonDecoder = JSONDecoder()
                if let users = try? jsonDecoder.decode(multipleUser.self, from: data) {

                    print("success get random")
                    
                    completion(users.data)
                } else {
                    print("get random Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    

}
