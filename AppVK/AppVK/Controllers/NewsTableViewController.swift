// NewsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import UIKit

/// NewsTableViewController-
final class NewsTableViewController: UITableViewController {
    // MARK: private properties

    private var cellID = "newsCell"
    private var newsArray: [NewsRealm] = []
    private var service = APIService()
    private var token: NotificationToken?
    private var isLoading = false

    // MARK: NewsTableViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        setupData()
        setupRefreshController()
    }

    // MARK: private methods

    private func setupData() {
        service.getPosts(startFrom: "\(Date().timeIntervalSince1970 + 1)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadFromRealm()
        }
    }

    private func loadFromRealm() {
        do {
            let realm = try Realm()
            let news = realm.objects(NewsRealm.self)
            pairTableAndRealm()
            newsArray.append(contentsOf: Array(news))
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        let news = realm.objects(NewsRealm.self)
        token = news.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case let .initial(result):
                self?.newsArray.append(contentsOf: Array(result))
                self?.tableView.reloadData()
            case let .update(result, deletions: _, insertions: _, modifications: _):
                self?.newsArray.append(contentsOf: Array(result))
                self?.tableView.reloadData()
            case let .error(error):
                fatalError("\(error)")
            }
        }
    }

    private func setupRefreshController() {
        refreshControl = UIRefreshControl()

        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    private func configureCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        return createCell(indexPath: indexPath)
    }

    private func createCell(indexPath: IndexPath) -> UITableViewCell {
        var cellID = ""

        switch indexPath.row {
        case 0: cellID = "headerCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? HeaderTableViewCell
            else { return UITableViewCell() }
            cell.name = newsArray[indexPath.section].name
            cell.profileImageName = newsArray[indexPath.section].userImageURL
            cell.subtitle = newsArray[indexPath.section].date
            return cell
        case 1: cellID = "textNewsCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? TextNewsTableViewCell
            else { return UITableViewCell() }
            cell.newsText = newsArray[indexPath.section].newsText
            return cell
        case 2: cellID = "imageNewsCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? ImageTableViewCell
            else { return UITableViewCell() }
            if !newsArray[indexPath.section].newsImageURL.isEmpty {
                cell.newsImageName = newsArray[indexPath.section].newsImageURL
            }
            return cell
        case 3: cellID = "likesCell"
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellID,
                for: indexPath
            ) as? LikesTableViewCell
            else { return UITableViewCell() }
            cell.likesControl.countOfLikes = newsArray[indexPath.section].countOfLikes
            cell.repostsButton.setTitle(
                String(newsArray[indexPath.section].countsOfReposts),
                for: .normal
            )
            cell.commentsButton.setTitle(
                String(newsArray[indexPath.section].countsOfComments),
                for: .normal
            )
            cell.viewsButton.setTitle(
                String(newsArray[indexPath.section].countsOfViews),
                for: .normal
            )

            return cell
        default:
            return UITableViewCell()
        }
    }

    @objc private func pullToRefresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        newsArray.count
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
            let tableWidth = tableView.bounds.width
            let news = newsArray[indexPath.section]
            let aspectRatio = CGFloat(news.height / news.width)
            if news.width != 0, news.height != 0 {
                let cellHeight = tableWidth * aspectRatio
                return cellHeight
            } else {
                return 0
            }
        case 3:
            return 50
        default:
            return 70
        }
    }
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }

        if maxSection > newsArray.count - 3 {
            // isLoading = true
            service.getPosts(startFrom: "\(Date().timeIntervalSince1970)")
            loadFromRealm()
        }
    }
}
