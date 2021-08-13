// DetailAnimViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// DetailAnimViewController
final class DetailAnimViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private var photoImageView: UIImageView!

    // MARK: private properties

    private var photoArray: [UIImage] = []
    private var leftSwipeRecognizer = UISwipeGestureRecognizer()
    private var rightSwipeRecognizer = UISwipeGestureRecognizer()
    private var currentImageIndex = 0

    private enum Direction {
        case left
        case right
    }

    // MARK: DetailAnimViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupPhotoImageView()
        addRecognizer()
    }

    // MARK: private methods

    private func setupData() {
        guard let image = UIImage(named: "bart1") else { return }
        photoArray.append(image)
        guard let image = UIImage(named: "liza1") else { return }
        photoArray.append(image)
        guard let image = UIImage(named: "homer2") else { return }
        photoArray.append(image)
        guard let image = UIImage(named: "person") else { return }
        photoArray.append(image)
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

        UIView.animateKeyframes(withDuration: 1, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.photoImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                self.photoImageView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 1) {
                self.photoImageView.transform = .identity
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.transition(with: self.photoImageView, duration: 1, options: .transitionCrossDissolve) {
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
