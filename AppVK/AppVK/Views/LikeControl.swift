// LikeControl.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// LikeControl-
class LikeControl: UIControl {
    // MARK: private properties

    private let buttonLike = UIButton()
    private let countLabel = UILabel()
    private var stackView = UIStackView()
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
        setupLabel()
        setupStackView()
    }

    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [countLabel, buttonLike])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    private func setupButton() {
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        buttonLike.tintColor = .lightGray
        buttonLike.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupLabel() {
        countLabel.text = "0"
        countLabel.textColor = .lightGray
    }

    @objc private func buttonTapped() {
        if buttonLike.isSelected {
            countOfLikes -= 1
            countLabel.text = String(countOfLikes)
            countLabel.textColor = .lightGray
            buttonLike.tintColor = .lightGray
            buttonLike.isSelected = false
        } else {
            countOfLikes += 1
            countLabel.text = String(countOfLikes)
            countLabel.textColor = .red
            buttonLike.tintColor = .red
            buttonLike.isSelected = true
        }
    }
}
