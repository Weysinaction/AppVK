// GroupsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import UIKit

/// GroupsTableViewController-
final class GroupsTableViewController: UITableViewController {
    // MARK: public properties

    var groupsArray: [GroupRealm] = []

    // MARK: private properties

    private var cellID = "groupCell"
    private var allGroupsArray: [Group] = []
    private var service = APIService()
    private var token: NotificationToken?

    // MARK: GroupsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGroupsData()
    }

    // MARK: private methods

    private func configureCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? GroupsTableViewCell
        else { return UITableViewCell() }

        cell.imageURL = groupsArray[indexPath.row].imageURL
        cell.title = groupsArray[indexPath.row].title
        cell.subTitle = groupsArray[indexPath.row].subTitle

        return cell
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

    private func setupGroupsData() {
        let opq = OperationQueue()
        let getDataOperation = GetGroupsResponse()
        opq.addOperation(getDataOperation)

        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        opq.addOperation(parseData)

        let saveGroupData = SaveGroupDataOperation()
        saveGroupData.addDependency(parseData)
        OperationQueue.main.addOperation(saveGroupData)

        loadFromRealm()
    }

    private func loadFromRealm() {
        do {
            let realm = try Realm()
            let groups = realm.objects(GroupRealm.self)
            pairTableAndRealm()
            groupsArray = Array(groups)
        } catch {
            print(error)
        }
    }

    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        let groups = realm.objects(GroupRealm.self)
        token = groups.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case let .initial(result):
                self?.groupsArray = Array(result)
            case let .update(result, deletions: _, insertions: _, modifications: _):
                self?.groupsArray = Array(result)
            case let .error(error):
                fatalError("\(error)")
            }
        }
    }

    private func addGroup(name: String) {
        for group in groupsArray where group.title == name {
            groupsArray.append(group)
        }
        tableView.reloadData()
    }

    // MARK: IBAction

    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Название группы", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Название"
        }

        let action = UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
            guard let groupName = alert?.textFields?.first?.text else { return }
            self?.addGroup(name: groupName)
        }

        alert.addAction(action)
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = configureCell(indexPath: indexPath, tableView: tableView) else { return UITableViewCell() }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            groupsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupsTableViewCell else { return }
        cell.addAnimation()
    }
}
