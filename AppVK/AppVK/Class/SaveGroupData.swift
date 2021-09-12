// SaveGroupData.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift
import UIKit

/// SaveGroupDataOperation-
class SaveGroupDataOperation: Operation {
    // MARK: SaveGroupDataOperation

    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        let groupsArray = parseData.groupsArray
        do {
            let realm = try Realm()

            print("operationSaveStarted")
            let oldGroups = realm.objects(GroupRealm.self)
            try realm.write {
                realm.delete(oldGroups)
                realm.add(groupsArray)
            }
        } catch {
            print(error)
        }
    }
}
