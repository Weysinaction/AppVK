// APIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation
import PromiseKit
import RealmSwift
import SwiftyJSON

/// APIService-
final class APIService {
    // MARK: public properties

    var friendsRealmArray: [FriendRealm] = []
    var photosArray: [String] = []
    var itemsArray: [JSON] = []
    var profilesArray: [JSON] = []
    var groupsArray: [JSON] = []

    // MARK: private properties

    private let userID = UserInfo.userInfo.userID
    private let token = UserInfo.userInfo.token
    private let friendsService = FriendsService()
    private let groupsService = GroupsService()

    // MARK: public methods

    func getFriends() -> Promise<[FriendRealm]> {
        let urlPath =
            "https://api.vk.com/method/friends.get?v=5.131&order=name&access_token=\(token)&fields=city,photo_100"

        let promise = Promise<[FriendRealm]> { resolver in
            AF.request(urlPath).responseData { response in

                guard let data = response.value else { return }
                do {
                    let json = try JSON(data: data)
                    guard let jsonArray = json["response"]["items"].array else { return }
                    self.addFriends(array: jsonArray)
                    resolver.fulfill(self.friendsRealmArray)
                } catch {
                    resolver.reject(error)
                    print("ERROR")
                }
            }
        }
        return promise
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

    func getPosts(startFrom: String) {
        let urlPath =
            "https://api.vk.com/method/newsfeed.get?v=5.131&access_token=\(token)&count=10&filters=post"
        AF.request(urlPath).responseData { _ in
            AF.request(urlPath).responseData { response in

                guard let data = response.value else { return }
                do {
                    let json = try JSON(data: data)
                    print(json)

                    guard let itemsArray = json["response"]["items"].array else { return }
                    guard let profilesArray = json["response"]["profiles"].array else { return }
                    guard let groupsArray = json["response"]["groups"].array else { return }

                    self.addNews(
                        itemsArray: itemsArray,
                        profilesArray: profilesArray,
                        groupsArray: groupsArray
                    )
                } catch {
                    print("ERROR")
                }
            }
        }
    }

    // MARK: private methods

    private func addFriends(array: [JSON]) {
        friendsRealmArray = []

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

    private func addNews(itemsArray: [JSON], profilesArray: [JSON], groupsArray: [JSON]) {
        var items: [Item] = []
        var profiles: [Profile] = []
        var groups: [Group] = []

        let dispatchGroup = DispatchGroup()

        DispatchQueue.global().async(group: dispatchGroup) {
            for value in itemsArray {
                let countOfLikes = value["likes"]["count"].int ?? 0
                let countOfComments = value["comments"]["count"].int ?? 0
                let countOfReposts = value["reposts"]["count"].int ?? 0
                let countOfViews = value["views"]["count"].int ?? 0
                let newsText = value["text"].string ?? ""
                let sourceID = value["source_id"].int ?? 0
                let date = value["date"].int ?? 0
                let attachments = value["attachments"].array
                let sizes = attachments?.first?["photo"]["sizes"].array
                let xSize = sizes?.first(where: { $0["type"].stringValue == "x"
                })
                let url = xSize?["url"].stringValue ?? ""
                let width = xSize?["width"].int ?? 0
                let height = xSize?["height"].int ?? 0

                print("image width = \(width), height = \(height)")
                items.append(Item(
                    countOfLikes: countOfLikes,
                    countOfComments: countOfComments,
                    countOfReposts: countOfReposts,
                    countOfViews: countOfViews,
                    sourceID: sourceID,
                    newsText: newsText,
                    newsImageURL: url,
                    date: date,
                    width: width,
                    height: height
                ))
            }
        }
        DispatchQueue.global().async(group: dispatchGroup) {
            for value in profilesArray {
                let sourceID = value["id"].int ?? 0
                let firstName = value["first_name"].string ?? ""
                let lastName = value["last_name"].string ?? ""
                let photoURL = value["photo_100"].string ?? ""

                profiles.append(Profile(
                    sourceID: sourceID,
                    firstName: firstName,
                    lastName: lastName,
                    photoURL: photoURL
                ))
            }
        }
        DispatchQueue.global().async(group: dispatchGroup) {
            for value in groupsArray {
                let sourceID = value["id"].int ?? 0
                let name = value["name"].string ?? ""
                let photoURL = value["photo_200"].string ?? ""

                groups.append(Group(sourceID: sourceID, name: name, photoURL: photoURL))
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.configureNews(items: items, profiles: profiles, groups: groups)
        }
    }

    private func configureNews(items: [Item], profiles: [Profile], groups: [Group]) {
        var newsArray: [NewsRealm] = []
        for items in items {
            let news = NewsRealm()
            news.countOfLikes = items.countOfLikes
            news.countsOfComments = items.countOfComments
            news.countsOfReposts = items.countOfReposts
            news.countsOfViews = items.countOfViews
            news.newsText = items.newsText
            news.newsImageURL = items.newsImageURL
            news.width = items.width
            news.height = items.height

            let dateTime = Date(timeIntervalSince1970: TimeInterval(Int(items.date)))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium

            news.date = dateFormatter.string(from: dateTime)

            for group in groups where group.sourceID == abs(items.sourceID) {
                news.name = group.name
                news.userImageURL = group.photoURL
            }

            for profile in profiles where profile.sourceID == items.sourceID {
                news.name = profile.firstName + " " + profile.lastName
                news.userImageURL = profile.photoURL
            }

            newsArray.append(news)
        }
        // print(newsArray)
        saveNewsToRealm(newsArray: newsArray)
    }

    private func saveNewsToRealm(newsArray: [NewsRealm]) {
        do {
            let realm = try Realm()

            let oldNews = realm.objects(NewsRealm.self)

            try realm.write {
                realm.delete(oldNews)
                realm.add(newsArray)
            }
        } catch {
            print(error)
        }
    }
}
