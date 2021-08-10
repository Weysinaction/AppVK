// FriendsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// FriendsTableViewController-
final class FriendsTableViewController: UITableViewController {
    // MARK: private properties

    private var friendsArray: [Friend] = []
    private var friendsCellID = "FriendsCell"
    private var sections: [Character: [Friend]] = [:]
    private var sortedSections: [(Character, [Friend])] = []
    private var sectionTitles: [Character] = []

    // MARK: FriendsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupSections()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailSegue" else { return }
        guard let destination = segue.destination as? DetailCollectionViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let friendsForSection = sections[sectionTitles[indexPath.section]] else { return }
        destination.name = friendsForSection[indexPath.row].name
        destination.imageName = friendsForSection[indexPath.row].imageName
    }

    // MARK: private methods

    private func setupSections() {
        for friend in friendsArray {
            guard let firstLetter = friend.name.first else { return }
            if sections[firstLetter] != nil {
                sections[firstLetter]?.append(friend)
            } else {
                sections[firstLetter] = [friend]
            }
        }

        // sortedSections = sections.sorted { $0.key < $1.key }
        sectionTitles = Array(sections.keys)
    }

    private func setupData() {
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Apu", description: "Springfield", imageName: "apu"))
        friendsArray.append(Friend(name: "Bart Simpson", description: "Springfield", imageName: "bart"))
        friendsArray.append(Friend(name: "Marge Simpson", description: "Springfield", imageName: "marge"))
        friendsArray.append(Friend(name: "Lisa Simpson", description: "Springfield", imageName: "lisa"))
        friendsArray.append(Friend(name: "Maggie Simpson", description: "Springfield", imageName: "maggie"))
        friendsArray.append(Friend(name: "Flanders", description: "Springfield", imageName: "flanders"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
        friendsArray.append(Friend(name: "Homer Simpson", description: "Springfield", imageName: "homer"))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[sectionTitles[section]]?.count ?? 0
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitles.map { String($0) }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(sectionTitles[section])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsCellID) as? FriendsTableViewCell
        else { return UITableViewCell() }

        guard let currentItem = sections[sectionTitles[indexPath.section]] else { return UITableViewCell() }

        cell.nameLabel.text = currentItem[indexPath.row].name
        cell.descriptionLabel.text = currentItem[indexPath.row].description

        guard let image = UIImage(named: currentItem[indexPath.row].imageName) else { return UITableViewCell() }

        cell.profileImageView.imageView.image = image

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
