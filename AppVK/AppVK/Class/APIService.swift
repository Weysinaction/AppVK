// APIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation
import SwiftyJSON

/// APIService-
final class APIService {
    // MARK: public properties

    var friendsArray: [Friend] = []
    var photosArray: [String] = []
    var groupsArray: [Group] = []

    // MARK: private properties

    private let userID = UserInfo.userInfo.userID
    private let token = UserInfo.userInfo.token
    private let friendsService = FriendsService()
    private let groupsService = GroupsService()

    // MARK: public methods

    func getFriends() {
        let urlPath =
            "https://api.vk.com/method/friends.get?v=5.131&order=name&access_token=\(token)&fields=city,photo_100"
        AF.request(urlPath).responseData { response in

            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                guard let jsonArray = json["response"]["items"].array else { return }
                self.addFriends(array: jsonArray)

            } catch {
                print("ERROR")
            }
        }
    }

    func getPhotos(ownerID: Int) {
        let urlPath =
            "https://api.vk.com/method/photos.get?v=5.131&owner_id=\(ownerID)&album_id=profile&access_token=\(token)"
        AF.request(urlPath).responseData { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                guard let jsonArray = json["response"]["items"].array else { return }
                self.addPhotos(array: jsonArray)
            } catch {
                print("ERROR")
            }
        }
    }

    func getGroups() {
        let urlPath =
            "https://api.vk.com/method/groups.get?v=5.131&user_id=\(UserInfo.userInfo.userID)&extended=1&access_token=\(token)&fields=activity"
        AF.request(urlPath).responseData { _ in
            AF.request(urlPath).responseData { response in

                guard let data = response.value else { return }
                do {
                    let json = try JSON(data: data)
                    guard let jsonArray = json["response"]["items"].array else { return }
                    self.addGroups(array: jsonArray)

                } catch {
                    print("ERROR")
                }
            }
        }
    }

    func getGroupsSearch() {
        let urlPath = "https://api.vk.com/method/groups.search?v=5.131&q=swift&access_token=\(token)"
        AF.request(urlPath).responseData { _ in
        }
    }

    // MARK: private methods

    private func addFriends(array: [JSON]) {
        for value in array {
            let firstName = value["first_name"].string ?? ""
            let lastName = value["last_name"].string ?? ""
            let id = value["id"].int ?? 0
            let imageURL = value["photo_100"].string ?? ""
            let city = value["city"]["title"].string ?? ""

            friendsArray.append(Friend(name: firstName + " " + lastName, id: id, imageURL: imageURL, city: city))
        }
    }

    private func addPhotos(array: [JSON]) {
        for object in array {
            let sizes = object["sizes"].arrayValue.map {
                $0["url"].stringValue
            }
            photosArray.append(sizes.last ?? "")
        }
    }

    private func addGroups(array: [JSON]) {
        for value in array {
            let imageURL = value["photo_200"].string ?? ""
            let title = value["name"].string ?? ""
            let subTitle = value["activity"].string ?? ""

            groupsArray.append(Group(imageURL: imageURL, title: title, subTitle: subTitle))
        }
    }
}
