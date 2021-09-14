// PhotoService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

/// PhotoService-
class PhotoService {
    // MARK: private properties

    private static let pathName: String = {
        let pathName = "images"

        guard let cachesDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else { return pathName }

        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

        return pathName
    }()

    // MARK: private methods

    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else { return nil }
        let hashName = url.split(separator: "/").last ?? "default"

        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }

    // MARK: public methods

    public func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
