// GroupsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// GroupsTableViewController-
final class GroupsTableViewController: UITableViewController {
    private var cellID = "groupCell"
    private var groupsArray: [Group] = []
    private var allGroupsArray: [Group] = []
    private var service = APIService()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGroupsData()
    }

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
        service.getGroups()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.groupsArray = self.service.groupsArray
            self.tableView.reloadData()
        }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupsTableViewCell else { return }
        cell.addAnimation()
    }
}
