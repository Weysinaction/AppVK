// FriendsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// FriendsTableViewController-
final class FriendsTableViewController: UITableViewController {
    // MARK: private properties

    private var friendsArray: [Friend] = []
    private var friendsCellID = "FriendsCell"
    private var segueID = "DetailSegue"
    private var sections: [Character: [Friend]] = [:]
    private var sortedSections: [(Character, [Friend])] = []
    private var sectionTitles: [Character] = []
    private var filteredTableData: [Friend] = []
    private var resultSearchController = UISearchController()
    private var interactiveTransition = InteractiveTransition()

    // MARK: FriendsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        setupData()
        setupSections(array: friendsArray)
        setupSearchController()
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

    private func setupSearchController() {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.sizeToFit()
        tableView.tableHeaderView = controller.searchBar
        resultSearchController = controller
        tableView.reloadData()
    }

    private func refreshDataForSearch() {
        if resultSearchController.isActive {
            setupSections(array: filteredTableData)
        } else {
            setupSections(array: friendsArray)
        }
    }

    private func setupSections(array: [Friend]) {
        sections.removeAll()
        sectionTitles.removeAll()

        for friend in array {
            guard let firstLetter = friend.name.first else { return }
            if sections[firstLetter] != nil {
                sections[firstLetter]?.append(friend)
            } else {
                sections[firstLetter] = [friend]
            }
        }

        sectionTitles = Array(sections.keys)
    }

    private func addAnimation() -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards

        return animation
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FriendsTableViewCell else { return }

        cell.profileImageView.layer.add(addAnimation(), forKey: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: self.segueID, sender: cell)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: UISearchResultsUpdating

extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        guard let text = searchController.searchBar.text else { return }

        if !text.isEmpty {
            let array = friendsArray.filter { $0.name.contains(text) }
            filteredTableData = array
        } else {
            filteredTableData = friendsArray
        }

        refreshDataForSearch()
        tableView.reloadData()
    }
}

// MARK: UINavigationControllerDelegate

extension FriendsTableViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return PopAnimator()
        } else {
            interactiveTransition.viewController = toVC
            return PushAnimator()
        }
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition.hasStarted ? interactiveTransition : nil
    }
}
