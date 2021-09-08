// HeaderTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// HeaderTableViewCell-
class HeaderTableViewCell: UITableViewCell {
    // MARK: IBOutlet

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    // MARK: public properties

    var name = ""
    var subtitle = ""
    var profileImageName = ""

    // MARK: HeaderTableViewCell

    override func layoutSubviews() {
        super.layoutSubviews()
        setupProfileImageView()
    }

    // MARK: private methods

    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
}
