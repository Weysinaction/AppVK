// UserInfo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// UserInfo-
final class UserInfo {
    // MARK: static variables

    static var userInfo = UserInfo()

    // MARK: public properties

    var id = 0
    var login: String = ""
    var password: String = ""

    // MARK: private methods

    private init() {}
}
