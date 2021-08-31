// FriendRealm.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

final class FriendRealm: Object, Decodable {
    // MARK: public properties

    @objc dynamic var name = ""
    @objc dynamic var id = 0
    @objc dynamic var imageURL = ""
    @objc dynamic var city = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
