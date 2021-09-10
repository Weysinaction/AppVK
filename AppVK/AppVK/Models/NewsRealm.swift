// NewsRealm.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// NewsRealm-
final class NewsRealm: Object, Decodable {
    // MARK: public properties

    @objc dynamic var userImageURL: String
    @objc dynamic var name: String
    @objc dynamic var newsText: String
    @objc dynamic var countOfLikes: Int
    @objc dynamic var countsOfComments: Int
    @objc dynamic var countsOfReposts: Int
    // @objc dynamic var newsImageURL: String
}

/// Item-
struct Item {
    var countOfLikes: Int
    var countOfComments: Int
    var countOfReposts: Int
    var sourceID: Int
    var newsText: String
}

/// Profile-
struct Profile {
    var sourceID: Int
    var firstName: String
    var lastName: String
    var photoURL: String
}

/// Group-
struct Group {
    var sourceID: Int
    var name: String
    var photoURL: String
}
