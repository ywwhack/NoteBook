//
//  URLManager.swift
//  notebook
//
//  Created by iYww on 16/4/26.
//  Copyright © 2016年 zank. All rights reserved.
//

import Foundation

protocol URLs {
  var login: String {get}
  var signup: String {get}
  var searchUser: String {get}
  var addGroupMember: String {get}
  var createGroup: String {get}
  var getAllGroups: String {get}
  var getGroupDetail: String {get}
  var addNoteToGroup: String {get}
}

enum URLType {
  case Development
  case Distribution
}

struct DevelopmentURLs: URLs {
  let login = "http://localhost:3000/login"
  let signup = "http://localhost:3000/signup"
  let searchUser = "http://localhost:3000/search_user"
  let addGroupMember = "http://localhost:3000/add_group_member"
  let createGroup = "http://localhost:3000/create_group"
  let getAllGroups = "http://localhost:3000/get_all_groups"
  let getGroupDetail = "http://localhost:3000/get_group_detail"
  let addNoteToGroup = "http://localhost:3000/add_note_to_group"
}

struct URLManager {
  static let urlType = URLType.Development
  
  private static var urls: URLs {
    switch urlType {
    case .Development: return DevelopmentURLs()
    case .Distribution: return DevelopmentURLs() // TODO: - Replace the with real host url
    }
  }
  
  static let login = urls.login
  static let signup = urls.signup
  static let searchUser = urls.searchUser
  static let addGroupMember = urls.addGroupMember
  static let createGroup = urls.createGroup
  static let getAllGroups = urls.getAllGroups
  static let getGroupDetail = urls.getGroupDetail
  static let addNoteToGroup = urls.addNoteToGroup
}