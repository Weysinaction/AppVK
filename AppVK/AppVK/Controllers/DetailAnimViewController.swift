// DetailAnimViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// DetailAnimViewController
final class DetailAnimViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private var photoImageView: UIImageView!

    // MARK: private properties

    private var photoUrlArray: [String] = []
    private var photoArray: [UIImage] = []
    private var leftSwipeRecognizer = UISwipeGestureRecognizer()
    private var rightSwipeRecognizer = UISwipeGestureRecognizer()
    private var currentImageIndex = 0
    private var service = APIService()

    private enum Direction {
        case left
        case right
    }

    // MARK: public properties

    var name = ""
    var id = 0

    // MARK: DetailAnimViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        addRecognizer()
    }

    // MARK: private methods

    private func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func downloadImage(url: URL) {
        getData(url: url) { data, _, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else { return }
            self.photoArray.append(image)
            DispatchQueue.main.async {
                self.setupPhotoImageView()
            }
        }
    }

    private func setupData() {
        service.getPhotos(ownerID: id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.photoUrlArray = self.service.photosArray
            self.downloadImages()
        }
    }

    private func downloadImages() {
        for url in photoUrlArray {
            guard let photoURL = URL(string: url) else { return }
            downloadImage(url: photoURL)
        }
    }

    private func addRecognizer() {
        leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction(sender:)))
        leftSwipeRecognizer.direction = .left

        rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction(sender:)))
        rightSwipeRecognizer.direction = .right

        photoImageView.addGestureRecognizer(leftSwipeRecognizer)
        photoImageView.addGestureRecognizer(rightSwipeRecognizer)
    }

    private func addAnimate(currentImageIndex: Int, direction: Direction) {
        var translationX: CGFloat = 0.0

        switch direction {
        case .left:
            translationX = -400
        case .right:
            translationX = +400
        }

        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.photoImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                self.photoImageView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 0.5) {
                self.photoImageView.transform = .identity
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: self.photoImageView, duration: 0.5, options: .transitionCrossDissolve) {
                self.photoImageView.alpha = 1
                self.photoImageView.image = self.photoArray[currentImageIndex]
            }
        }
    }

    private func changePhoto(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            if currentImageIndex > 0 {
                currentImageIndex -= 1
                addAnimate(currentImageIndex: currentImageIndex, direction: .right)
            }
        case .left:
            if currentImageIndex < photoArray.count - 1 {
                currentImageIndex += 1
                addAnimate(currentImageIndex: currentImageIndex, direction: .left)
            }
        default:
            return
        }
    }

    private func setupPhotoImageView() {
        photoImageView.image = photoArray[0]
    }

    @objc private func swipeLeftAction(sender: UISwipeGestureRecognizer) {
        changePhoto(sender: sender)
    }

    @objc private func swipeRightAction(sender: UISwipeGestureRecognizer) {
        changePhoto(sender: sender)
    }
}
