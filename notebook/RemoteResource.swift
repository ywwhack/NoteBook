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
  case Success([String: AnyObject])
  case Failed(String)
}

// FIXME: when user is not login, some request with username will crash app

struct RemoteResource {
  // MARK: - User related methods
  static func loginWithUsername(username: String, password: String, completion: RequestResult -> ()) {
    requestWithMethod(.GET, urlString: URLManager.login, withUsername: username, andPassword: password, completion: completion)
  }
  
  static func signupWithUsername(username: String, password: String, completion: RequestResult -> ()) {
    requestWithMethod(.POST, urlString: URLManager.signup, withUsername: username, andPassword: password, completion: completion)
  }
  
  static func searchUserWithUsername(username: String, completion: RequestResult -> ()) {
    let request = Alamofire
      .request(.GET, URLManager.searchUser, parameters: ["username": username])
    processRequest(request, completion: completion)
  }
        
  private static func requestWithMethod(method: Alamofire.Method, urlString: String, withUsername username: String, andPassword password: String, completion: RequestResult -> ()) {
    let request = Alamofire
      .request(method, urlString, parameters: ["username": username, "password": password])
    processRequest(request, completion: completion)
  }
  
  // MARK: - Group Related Methods
  static func addMember(membername: String, ToGroup groupId: String, completion: RequestResult -> ()) {
    let request = Alamofire
      .request(.POST, URLManager.addGroupMember, parameters: ["membername": membername, "groupId": groupId])
    processRequest(request, completion: completion)
  }
  
  static func createGroup(groupname: String, completion: RequestResult -> ()) {
    let dataModel = DataModel.sharedDataModel()
    let request = Alamofire.request(.POST, URLManager.createGroup, parameters: ["username": dataModel.username!, "groupname": groupname])
    processRequest(request, completion: completion)
  }
  
  static func getAllGroups(completion completion: RequestResult -> ()) {
    let dataModel = DataModel.sharedDataModel()
    print(dataModel.username)
    let request = Alamofire.request(.GET, URLManager.getAllGroups, parameters: ["username": dataModel.username!])
    processRequest(request, completion: completion)
  }
  
  static func getGroupDetailWithId(groupId: String, completion: RequestResult -> ()) {
    let request = Alamofire.request(.GET, URLManager.getGroupDetail, parameters: ["groupId": groupId])
    processRequest(request, completion: completion)
  }
  
  static func addNote(note: Note, toGroup groupId: String, completion: RequestResult -> ()) {
    let dataModel = DataModel.sharedDataModel()
    Alamofire.upload(.POST, URLManager.addNoteToGroup, multipartFormData: { multipartFormData in
      // body
      multipartFormData.appendBodyPart(data: encodeString(dataModel.username!), name: "username")
      multipartFormData.appendBodyPart(data: encodeString(note.content), name: "noteContent")
      multipartFormData.appendBodyPart(data: encodeString(groupId), name: "groupId")
      
      // image files
      let imageNames = note.images as! [String]
      let imageURLs = imageNames.map { dataModel.applicationDocumentsDirectory.URLByAppendingPathComponent($0) }
      imageURLs.forEach { url in
        let fileNameWithExt = url.lastPathComponent!
        let filename = fileNameWithExt.componentsSeparatedByString(".")[0]
        multipartFormData.appendBodyPart(fileURL: url, name: filename)
      }
      }) { encodingResult in
        switch encodingResult {
        case .Success(let request, _, _):
            processRequest(request, completion: completion)
        case .Failure:
          completion(RequestResult.Failed("Encoding Error"))
        }
    }
  }
  
  static private func encodeString(content: String) -> NSData {
    return content.dataUsingEncoding(NSUTF8StringEncoding)!
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
          requestResult = .Success(result)
        }else {
          if let reason = result["reason"] as? String {
            requestResult = .Failed(reason)
          }
        }
        completion(requestResult)
    }
  }
  
}
