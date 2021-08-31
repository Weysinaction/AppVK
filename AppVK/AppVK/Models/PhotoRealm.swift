// PhotoRealm.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// PhotoRealm-
class PhotoRealm: Object, Decodable {
    @objc dynamic var photoURL: String
}
