// UserFirebase.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// UserFirebase-
class UserFirebase {
    var id: String = ""

    func toAnyObject() -> [String: Any] {
        return ["id": id]
    }
}
