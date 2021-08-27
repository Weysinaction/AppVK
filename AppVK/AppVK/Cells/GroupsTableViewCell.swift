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

    var imageURL: String = ""
    var title: String = ""
    var subTitle: String = ""

    // MARK: GroupsTableViewCell

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }

    // MARK: public methods

    func addAnimation() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 1.5
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards

        groupImageView.layer.add(animation, forKey: nil)
    }

    // MARK: private methods

    private func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func downloadImage(url: URL, imageView: UIImageView) {
        getData(url: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }

    private func setupViews() {
        groupTitleLabel.text = title
        groupSubTitleLabel.text = subTitle

        guard let url = URL(string: imageURL) else { return }
        downloadImage(url: url, imageView: groupImageView)
        setupImageView()
    }

    private func setupImageView() {
        groupImageView.layer.cornerRadius = groupImageView.frame.width / 2
        groupImageView.clipsToBounds = true
        groupImageView.layer.borderWidth = 2
        groupImageView.layer.borderColor = UIColor.orange.cgColor
    }
}
