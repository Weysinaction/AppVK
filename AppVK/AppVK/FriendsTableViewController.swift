// FriendsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// FriendsTableViewController-
final class FriendsTableViewController: UITableViewController {
    // MARK: private properties

    private var friendsArray: [Friend] = []
    private var friendsCellID = "FriendsCell"

    // MARK: FriendsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailSegue" else { return }
        guard let destination = segue.destination as? DetailCollectionViewController,
              let currentItem = tableView.indexPathForSelectedRow?.row else { return }
        destination.name = friendsArray[currentItem].name
        destination.imageName = friendsArray[currentItem].imageName
    }

    // MARK: private methods

    private func setupData() {
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsCellID) as? FriendsTableViewCell
        else { return UITableViewCell() }

        let currentItem = indexPath.row

        cell.nameLabel.text = friendsArray[currentItem].name
        cell.descriptionLabel.text = friendsArray[currentItem].description

        guard let image = UIImage(named: friendsArray[currentItem].imageName) else { return UITableViewCell() }

        cell.friendImageView.image = image
        cell.friendImageView.layer.cornerRadius = cell.friendImageView.frame.width / 2

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
