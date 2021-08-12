// GroupsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// GroupsTableViewCell-
final class GroupsTableViewCell: UITableViewCell {
    // MARK: IBOutlets

    @IBOutlet private var groupImageView: UIImageView!
    @IBOutlet private var groupTitleLabel: UILabel!
    @IBOutlet private var groupSubTitleLabel: UILabel!

    // MARK: private properties

    private var cellID = "groupCell"

    // MARK: public properties

    var imageName: String = ""
    var title: String = ""
    var subTitle: String = ""

    // MARK: GroupsTableViewCell

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }

    // MARK: private methods

    private func setupViews() {
        groupTitleLabel.text = title
        groupSubTitleLabel.text = subTitle
        guard let image = UIImage(named: imageName) else { return }
        groupImageView.image = image

        setupImageView()
    }

    private func setupImageView() {
        groupImageView.layer.cornerRadius = groupImageView.frame.width / 2
        groupImageView.clipsToBounds = true
        groupImageView.layer.borderWidth = 2
        groupImageView.layer.borderColor = UIColor.orange.cgColor
    }
}
