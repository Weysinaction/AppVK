//
//  UserInfo.swift
//  AppVK
//
//  Created by Владислав Лазарев on 23.08.2021.
//

import Foundation

/// UserInfo-
class UserInfo {

//MARK: static variables
static var userInfo: UserInfo = UserInfo()

//MARK: public properties
var id: Int = 0
var login: String = ""
var password: String = ""

//MARK: private methods
private init() {}
    
}
