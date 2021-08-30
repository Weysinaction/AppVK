// FriendsService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// FriendsService-
class FriendsService {
    func saveFriendData(_ friends: [FriendRealm]) {
        do {
            let realm = try Realm()

            realm.beginWrite()

            realm.add(friends)

            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
