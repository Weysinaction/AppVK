// ProfileImageView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// ProfileImageView-
class ProfileImageView: UIView {
    // MARK: private properties

    private let shadowView = UIView()

    // MARK: public properties

    let imageView = UIImageView()

    // MARK: ProfileImageView

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    // MARK: private methods

    private func setupView() {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = false
        setupShadowView()
        setupImageView()
    }

    private func setupImageView() {
        imageView.layer.cornerRadius = (bounds.width) / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }

    private func setupShadowView() {
        shadowView.layer.cornerRadius = (bounds.width) / 2
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowRadius = 5
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shadowView)
        shadowView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor, constant: -0).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0).isActive = true
    }
}
