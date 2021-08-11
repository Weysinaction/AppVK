// NewsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// NewsTableViewCell-
class NewsTableViewCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postImageView: UIImageView!

    // MARK: private properties

    var name = ""
    var subtitle = ""
    var profileImageName = ""
    var newsText = ""
    var newsImageName = ""

    override func layoutSubviews() {
        setupProfileImageView()
        setupViews()
    }

    private func setupViews() {
        nameLabel.text = name
        subtitleLabel.text = subtitle
        postTextView.text = newsText
        guard let profileImage = UIImage(named: profileImageName) else { return }
        profileImageView.image = profileImage
        guard let newsImage = UIImage(named: newsImageName) else { return }
        postImageView.image = newsImage
    }

    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
}
