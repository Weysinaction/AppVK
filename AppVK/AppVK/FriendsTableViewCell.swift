// FriendsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// FriendsTableViewCell-
final class FriendsTableViewCell: UITableViewCell {
    // MARK: IBOutlet

    @IBOutlet var friendImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    // MARK: FriendsTableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: true)
    }
}
