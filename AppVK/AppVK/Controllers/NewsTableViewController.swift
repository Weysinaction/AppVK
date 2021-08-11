// NewsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// NewsTableViewController-
final class NewsTableViewController: UITableViewController {
    //MARK: private properties
    private var cellID = "newsCell"
    private var newsArray: [News] = []

    //MARK: NewsTableViewController
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? NewsTableViewCell
        else { return UITableViewCell() }

        cell.name = newsArray[indexPath.row].name
        cell.subtitle = newsArray[indexPath.row].subtitle
        cell.profileImageName = newsArray[indexPath.row].profileImageName
        cell.newsText = newsArray[indexPath.row].newsText
        cell.newsImageName = newsArray[indexPath.row].newsImageName

        return cell
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(indexPath: indexPath, tableView: tableView)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        550
    }
}
