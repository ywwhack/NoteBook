//
//  RemoteResource.swift
//  notebook
//
//  Created by iYww on 16/4/16.
//  Copyright © 2016年 zank. All rights reserved.
//

import Foundation
import Alamofire

enum RequestResult {
  case Success
  case Failed(String)
}

struct RemoteResource {
  // MARK: - Login and Signup
  static func loginWithUsername(username: String, password: String, completion: (RequestResult) -> ()) {
    postURLString("http://localhost:3000/login", withUsername: username, andPassword: password, completion: completion)
  }
  
  static func signupWithUsername(username: String, password: String, completion: (RequestResult) -> ()) {
    postURLString("http://localhost:3000/signup", withUsername: username, andPassword: password, completion: completion)
  }
        
  private static func postURLString(urlString: String, withUsername username: String, andPassword password: String, completion: (RequestResult) -> ()) {
    var userInfoResult: RequestResult = .Failed("Recive result is not a json")
    Alamofire
      .request(.POST, urlString, parameters: ["username": username, "password": password])
      .responseJSON { response in
        if let result = response.result.value as? [String: AnyObject] {
          if result["code"] as! Int == 1 {
            userInfoResult = .Success
          }else {
            userInfoResult = .Failed(result["reason"] as! String)
          }
        }
        completion(userInfoResult)
      }
  }
  
  // MARK: - Search User
  static func addFriend(friendname: String, completion: (RequestResult) -> ()) {
    let dataModel = DataModel.sharedDataModel()
    var requestResult = RequestResult.Failed("Request Error")
    Alamofire
      .request(.POST, "http://localhost:3000/add_friend", parameters: ["username": dataModel.username!, "friendname": friendname])
      .responseJSON { response in
        guard let result = response.result.value as? [String: AnyObject] else {
          completion(requestResult)
          return
        }
        if let code = result["code"] as? Int where code == 1 {
          requestResult = .Success
        }else {
          if let reason = result["reason"] as? String {
            requestResult = .Failed(reason)
          }
        }
        completion(requestResult)
      }
  }
  
}
