//
//  RemoteResource.swift
//  notebook
//
//  Created by iYww on 16/4/16.
//  Copyright © 2016年 zank. All rights reserved.
//

import Foundation
import Alamofire

enum PostUserInfoResult {
  case Success
  case Failed(String)
}

enum SearchUserResult {
  case Found(String)
  case NotFound
}

struct RemoteResource {
  // MARK: - Login and Signup
  static func loginWithUsername(username: String, password: String, completion: (PostUserInfoResult) -> ()) {
    postURLString("http://localhost:3000/login", withUsername: username, andPassword: password, completion: completion)
  }
  
  static func signupWithUsername(username: String, password: String, completion: (PostUserInfoResult) -> ()) {
    postURLString("http://localhost:3000/signup", withUsername: username, andPassword: password, completion: completion)
  }
        
  private static func postURLString(urlString: String, withUsername username: String, andPassword password: String, completion: (PostUserInfoResult) -> ()) {
    var userInfoResult: PostUserInfoResult = .Failed("Recive result is not a json")
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
  static func searchWithUsername(username: String, completion: SearchUserResult -> ()) {
    Alamofire
      .request(.GET, "http://localhost:3000/search_user", parameters: ["username": username])
      .responseJSON { response in
        
      }
  }
  
}
