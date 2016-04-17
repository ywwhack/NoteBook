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
  static func loginWithUsername(username: String, password: String, completion: RequestResult -> ()) {
    postURLString("http://localhost:3000/login", withUsername: username, andPassword: password, completion: completion)
  }
  
  static func signupWithUsername(username: String, password: String, completion: RequestResult -> ()) {
    postURLString("http://localhost:3000/signup", withUsername: username, andPassword: password, completion: completion)
  }
        
  private static func postURLString(urlString: String, withUsername username: String, andPassword password: String, completion: RequestResult -> ()) {
    let request = Alamofire
      .request(.POST, urlString, parameters: ["username": username, "password": password])
    processRequest(request, completion: completion)
  }
  
  // MARK: - Group Related Methods
  static func addFriend(friendname: String, completion: RequestResult -> ()) {
    let dataModel = DataModel.sharedDataModel()
    let request = Alamofire
      .request(.POST, "http://localhost:3000/add_friend", parameters: ["username": dataModel.username!, "friendname": friendname])
    processRequest(request, completion: completion)
  }
  
  static func createGroup(groupname: String, completion: RequestResult -> ()) {
    let dataModel = DataModel.sharedDataModel()
    let request = Alamofire
      .request(.POST, "http://localhost:3000/create_group", parameters: ["username": dataModel.username!, "groupname": groupname])
    processRequest(request, completion: completion)
  }
  
  private static func processRequest(request: Request, completion: RequestResult -> ()) {
    var requestResult = RequestResult.Failed("Request Error")
    request
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
