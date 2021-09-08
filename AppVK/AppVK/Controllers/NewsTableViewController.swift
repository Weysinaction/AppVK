// NewsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// NewsTableViewController-
final class NewsTableViewController: UITableViewController {
    // MARK: private properties

    private var cellID = "newsCell"
    private var newsArray: [News] = []

    // MARK: NewsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    // MARK: private methods

    private func setupData() {
        newsArray.append(News(
            name: "Homer Simpson",
            subtitle: "08.08.2021",
            profileImageName: "homer",
            newsText: "Еще раз я тебя здесь увижу, кому-то точно не поздоровиться!",
            newsImageName: "simpsons"
        ))
        newsArray.append(News(
            name: "Homer Simpson",
            subtitle: "08.08.2021",
            profileImageName: "homer",
            newsText: "Еще раз я тебя здесь увижу, кому-то точно не поздоровиться!",
            newsImageName: "simpsons"
        ))
        newsArray.append(News(
            name: "Homer Simpson",
            subtitle: "08.08.2021",
            profileImageName: "homer",
            newsText: "Еще раз я тебя здесь увижу, кому-то точно не поздоровиться!",
            newsImageName: "simpsons"
        ))
        newsArray.append(News(
            name: "Homer Simpson",
            subtitle: "08.08.2021",
            profileImageName: "homer",
            newsText: "Еще раз я тебя здесь увижу, кому-то точно не поздоровиться!",
            newsImageName: "simpsons"
        ))
        newsArray.append(News(
            name: "Homer Simpson",
            subtitle: "08.08.2021",
            profileImageName: "homer",
            newsText: "Еще раз я тебя здесь увижу, кому-то точно не поздоровиться!",
            newsImageName: "simpsons"
        ))
    }

    private func configureCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        var cellID = ""

        switch indexPath.row {
        case 0: cellID = "headerCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? HeaderTableViewCell
            else { return UITableViewCell() }
            return cell
        case 1: cellID = "textNewsCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? TextNewsTableViewCell
            else { return UITableViewCell() }
            return cell
        case 2: cellID = "imageNewsCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? ImageTableViewCell
            else { return UITableViewCell() }
            return cell
        case 3: cellID = "likesCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? LikesTableViewCell
            else { return UITableViewCell() }
            return cell
        default:
            return UITableViewCell()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(indexPath: indexPath, tableView: tableView)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
        case 1:
            return 60
        case 2:
            return 380
        case 3:
            return 50
        default:
            return 70
        }
    }
}
