// NewsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// NewsTableViewCell-
final class NewsTableViewCell: UITableViewCell {
    //MARK: IBOutlet
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var postTextView: UITextView!
    @IBOutlet private var postImageView: UIImageView!

    // MARK: public properties
    var name = ""
    var subtitle = ""
    var profileImageName = ""
    var newsText = ""
    var newsImageName = ""

    //MARK: NewsTableViewCell
    override func layoutSubviews() {
        setupProfileImageView()
        setupViews()
    }

    //MARK: private methods
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
