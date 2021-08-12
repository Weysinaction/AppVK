// GroupsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// GroupsTableViewController-
final class GroupsTableViewController: UITableViewController {
    private var cellID = "groupCell"
    private var groupsArray: [Group] = []
    private var allGroupsArray: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAllGroupsData()
        setupGroupsData()
    }

    private func configureCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? GroupsTableViewCell
        else { return UITableViewCell() }

        cell.imageName = groupsArray[indexPath.row].imageName
        cell.title = groupsArray[indexPath.row].title
        cell.subTitle = groupsArray[indexPath.row].subTitle

        return cell
    }

    private func setupAllGroupsData() {
        allGroupsArray
            .append(Group(imageName: "springfield", title: "Подслушано в Springfield", subTitle: "Городские сплетни"))
        allGroupsArray
            .append(Group(
                imageName: "police",
                title: "Springfield Police",
                subTitle: "Полицейский департамент"
            ))
        allGroupsArray
            .append(Group(imageName: "school", title: "Springfield School", subTitle: "Школа Спрингфилда"))
    }

    private func setupGroupsData() {
        guard let group = allGroupsArray.first else { return }
        groupsArray.append(group)
        groupsArray.append(group)

        guard let groupTwo = allGroupsArray.last else { return }
        groupsArray.append(groupTwo)
        groupsArray.append(groupTwo)
        groupsArray.append(group)
        groupsArray.append(group)
        groupsArray.append(groupTwo)
    }

    private func addGroup(name: String) {
        for group in allGroupsArray where group.title == name {
            groupsArray.append(group)
        }
        tableView.reloadData()
    }

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
}
