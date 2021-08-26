// Friend.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Friend-
struct Friend: Codable {
    let name: String
    let id: Int
    let imageURL: String
    let city: String
}

/// City-
struct City: Codable {
    var id: Int
    var title: String
}
