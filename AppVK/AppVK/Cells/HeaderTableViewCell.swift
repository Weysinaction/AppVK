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
        setupLabels()
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

    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        guard let url = URL(string: profileImageName) else { return }
        downloadImage(url: url, imageView: profileImageView)
    }

    private func setupLabels() {
        nameLabel.text = name
        subtitleLabel.text = subtitle
    }
}
