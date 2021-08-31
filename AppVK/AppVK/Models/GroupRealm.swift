// GroupRealm.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

final class GroupRealm: Object, Decodable {
    // MARK: public properties

    @objc dynamic var imageURL: String
    @objc dynamic var title: String
    @objc dynamic var subTitle: String
}
