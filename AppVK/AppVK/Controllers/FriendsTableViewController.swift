// FriendsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import FirebaseAuth
import RealmSwift
import UIKit

/// FriendsTableViewController-
final class FriendsTableViewController: UITableViewController {
    // MARK: private properties

    private var friendsArray: [Friend] = []
    private var friendsRealmArray: [FriendRealm] = []
    private var friendsCellID = "FriendsCell"
    private var segueID = "DetailSegue"
    private var sections: [Character: [FriendRealm]] = [:]
    private var sortedSections: [(Character, [FriendRealm])] = []
    private var sectionTitles: [Character] = []
    private var filteredTableData: [FriendRealm] = []
    private var resultSearchController = UISearchController()
    private var interactiveTransition = InteractiveTransition()
    private var service = APIService()
    private var tokenFriend: NotificationToken?

    // MARK: FriendsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        setupData()
        setupSearchController()
        service.getPosts()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailSegue" else { return }
        guard let destination = segue.destination as? DetailAnimViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let friendsForSection = sections[sectionTitles[indexPath.section]] else { return }
        destination.name = friendsForSection[indexPath.row].name
        destination.id = friendsForSection[indexPath.row].id
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
            setupSections(array: friendsRealmArray)
        }
    }

    private func setupSections(array: [FriendRealm]) {
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
        service.getFriends()
        loadFromRealm()
        tableView.reloadData()
    }

    private func loadFromRealm() {
        do {
            let realm = try Realm()
            let friends = realm.objects(FriendRealm.self)
            pairTableAndRealm()
            friendsRealmArray = Array(friends)
            setupSections(array: friendsRealmArray)
        } catch {
            print(error)
        }
    }

    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        let friends = realm.objects(FriendRealm.self)
        tokenFriend = friends.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case let .initial(result):
                self?.friendsRealmArray = Array(result)
            case let .update(result, deletions: _, insertions: _, modifications: _):
                self?.friendsRealmArray = Array(result)
            case let .error(error):
                fatalError("\(error)")
            }
        }
    }

    private func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func downloadImage(url: URL, imageView: ProfileImageView) {
        getData(url: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.imageView.image = UIImage(data: data)
            }
        }
    }

    // MARK: IBAction

    @IBAction func exitButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true)
        } catch {
            print("Auth sign out failed:\(error)")
        }
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

        cell.nameLabel.text = "\(currentItem[indexPath.row].name)"
        cell.descriptionLabel.text = currentItem[indexPath.row].city

        guard let url = URL(string: currentItem[indexPath.row].imageURL),
              let imageView = cell.profileImageView else { return UITableViewCell() }

        downloadImage(url: url, imageView: imageView)

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
            let array = friendsRealmArray.filter { $0.name.contains(text) }
            filteredTableData = array
        } else {
            filteredTableData = friendsRealmArray
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
