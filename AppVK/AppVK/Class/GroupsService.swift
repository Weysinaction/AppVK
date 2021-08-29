// GroupsService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// GroupsService-
class GroupsService {
    func saveFriendData(_ groups: [GroupRealm]) {
        do {
            let realm = try Realm()

            realm.beginWrite()

            realm.add(groups)

            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
