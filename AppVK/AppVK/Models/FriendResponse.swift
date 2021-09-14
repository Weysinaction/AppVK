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
