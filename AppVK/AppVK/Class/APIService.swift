// APIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation
import RealmSwift
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

    func getFriends(completion: @escaping () -> ()) {
        let urlPath =
            "https://api.vk.com/method/friends.get?v=5.131&order=name&access_token=\(token)&fields=city,photo_100"
        AF.request(urlPath).responseData { response in

            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                guard let jsonArray = json["response"]["items"].array else { return }
                self.addFriends(array: jsonArray)
                completion()
            } catch {
                completion()
                print("ERROR")
            }
        }
    }

    func getPhotos(ownerID: Int, completion: @escaping () -> ()) {
        let urlPath =
            "https://api.vk.com/method/photos.get?v=5.131&owner_id=\(ownerID)&album_id=profile&access_token=\(token)"
        AF.request(urlPath).responseData { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                guard let jsonArray = json["response"]["items"].array else { return }
                self.addPhotos(array: jsonArray)
                completion()
            } catch {
                completion()
                print("ERROR")
            }
        }
    }

    func getGroups(completion: @escaping () -> ()) {
        let urlPath =
            "https://api.vk.com/method/groups.get?v=5.131&user_id=\(UserInfo.userInfo.userID)&extended=1&access_token=\(token)&fields=activity"
        AF.request(urlPath).responseData { _ in
            AF.request(urlPath).responseData { response in

                guard let data = response.value else { return }
                do {
                    let json = try JSON(data: data)
                    guard let jsonArray = json["response"]["items"].array else { return }
                    self.addGroups(array: jsonArray)
                    completion()
                } catch {
                    print("ERROR")
                    completion()
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
        var friendsRealmArray: [FriendRealm] = []

        for value in array {
            let friend = FriendRealm()

            let firstName = value["first_name"].string ?? ""
            let lastName = value["last_name"].string ?? ""

            friend.name = firstName + " " + lastName
            friend.id = value["id"].int ?? 0
            friend.imageURL = value["photo_100"].string ?? ""
            friend.city = value["city"]["title"].string ?? ""

            friendsRealmArray.append(friend)
        }

        saveFriendsToRealm(friendsArray: friendsRealmArray)
    }

    private func saveFriendsToRealm(friendsArray: [FriendRealm]) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.add(friendsArray, update: .modified)
            }
        } catch {
            print(error)
        }
    }

    private func addPhotos(array: [JSON]) {
        var photosArray: [PhotoRealm] = []
        for object in array {
            let photo = PhotoRealm()
            let sizes = object["sizes"].arrayValue.map {
                $0["url"].stringValue
            }
            photo.photoURL = sizes.last ?? ""
            photosArray.append(photo)
        }
        savePhotoToRealm(photoArray: photosArray)
    }

    private func savePhotoToRealm(photoArray: [PhotoRealm]) {
        do {
            let realm = try Realm()
            let oldPhotos = realm.objects(PhotoRealm.self)
            try realm.write {
                realm.delete(oldPhotos)
                realm.add(photoArray)
            }
        } catch {
            print(error)
        }
    }

    private func addGroups(array: [JSON]) {
        var groupsArray: [GroupRealm] = []
        for value in array {
            let group = GroupRealm()
            group.imageURL = value["photo_200"].string ?? ""
            group.title = value["name"].string ?? ""
            group.subTitle = value["activity"].string ?? ""

            groupsArray.append(group)
        }
        saveGroupsToRealm(groupsArray: groupsArray)
    }

    private func saveGroupsToRealm(groupsArray: [GroupRealm]) {
        do {
            let realm = try Realm()

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
