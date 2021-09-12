// ParseData.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import SwiftyJSON

/// ParseData-
class ParseData: Operation {
    var groupsArray: [GroupRealm] = []

    override func main() {
        print("operationParseStarted")
        guard let getDataOperation = dependencies.first as? GetGroupsResponse,
              let data = getDataOperation.data else { return }
        do {
            let json = try JSON(data: data)
            guard let jsonArray = json["response"]["items"].array else { return }
            addGroups(array: jsonArray)
        } catch {
            print("ERROR")
        }
    }

    private func addGroups(array: [JSON]) {
        for value in array {
            let group = GroupRealm()
            group.imageURL = value["photo_200"].string ?? ""
            group.title = value["name"].string ?? ""
            group.subTitle = value["activity"].string ?? ""

            groupsArray.append(group)
        }
    }
}
