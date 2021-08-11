// LikeControl.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// LikeControl-
class LikeControl: UIControl {
    // MARK: private properties

    private let buttonLike = UIButton()
    private var countOfLikes = 0

    // MARK: LikeControl

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: private methods

    private func setupViews() {
        setupButton()
    }

    private func setupButton() {
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        buttonLike.tintColor = .lightGray
        buttonLike.setTitleColor(.lightGray, for: .normal)
        buttonLike.setTitleColor(.red, for: .selected)
        buttonLike.setTitle(String(countOfLikes), for: .normal)
        buttonLike.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(buttonLike)
        buttonLike.translatesAutoresizingMaskIntoConstraints = false
        buttonLike.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonLike.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        buttonLike.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        buttonLike.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    @objc private func buttonTapped() {
        if buttonLike.isSelected {
            countOfLikes -= 1
            buttonLike.tintColor = .lightGray
            buttonLike.setTitle(String(countOfLikes), for: .normal)
            buttonLike.isSelected = false
        } else {
            countOfLikes += 1
            buttonLike.tintColor = .red
            buttonLike.setTitle(String(countOfLikes), for: .selected)
            buttonLike.isSelected = true
        }
    }
}