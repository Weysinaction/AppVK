// DetailCollectionViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// DetailCollectionViewController-
final class DetailCollectionViewController: UICollectionViewController {
    // MARK: private properties

    private let detailCellID = "DetailCell"
    private let service = APIService()
    private var photosArray: [String] = []

    // MARK: public properties

    var name = ""
    var imageName = ""
    var id = 0

    // MARK: DetailCollectionViewController

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: detailCellID, for: indexPath) as? DetailCollectionViewCell
        else { return UICollectionViewCell() }

        cell.nameLabel.text = name

        guard let image = UIImage(named: imageName) else { return UICollectionViewCell() }
        cell.profileImageView.image = image

        return cell
    }

    // MARK: UICollectionViewDelegate
}

// MARK: UICollectionViewDelegateFlowLayout

extension DetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 152, height: 152)
    }
}
