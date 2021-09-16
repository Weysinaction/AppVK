// ImageTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ImageTableViewCell-
class ImageTableViewCell: UITableViewCell {
    // MARK: IBOutlet

    @IBOutlet private var postImageView: UIImageView!

    // MARK: public properties

    var newsImageName = ""

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let url = URL(string: newsImageName) else { return }
        downloadImage(url: url, imageView: postImageView)
    }

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
}
