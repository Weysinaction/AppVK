// FriendResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Response-
struct Response: Codable {
    var response: FriendResponse
}

/// FriendResponse-
struct FriendResponse: Codable {
    var count: Int
    var items: [Friend]
}

/// Item-
struct Item: Codable {
    var firstName: String
    var lastName: String
    var id: Int
    var photo100: String
//    var canAccessClosed: Int
//    var isClosed: Int
//    var nickname: String
//    var trackCode: String
}
