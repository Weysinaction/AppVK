// APIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// APIService-
final class APIService {
    //MARK: private properties
    private let userID = UserInfo.userInfo.userID
    private let token = UserInfo.userInfo.token

    //MARK: private methods
    private func getFriends() {
        let urlPath = "https://api.vk.com/method/friends.get?v=5.131&access_token=\(token)&fields=[nickname]"
        AF.request(urlPath).responseJSON { response in
            print(response.value)
        }
    }

    private func getPhotos() {
        let urlPath = "https://api.vk.com/method/photos.get?v=5.131&album_id=wall&access_token=\(token)"
        AF.request(urlPath).responseJSON { response in
            print(response.value)
        }
    }

    private func getGroups() {
        let urlPath = "https://api.vk.com/method/groups.get?v=5.131&extended=1&access_token=\(token)"
        AF.request(urlPath).responseJSON { response in
            print(response.value)
        }
    }

    private func getGroupsSearch() {
        let urlPath = "https://api.vk.com/method/groups.search?v=5.131&q=swift&access_token=\(token)"
        AF.request(urlPath).responseJSON { response in
            print(response.value)
        }
    }
}
