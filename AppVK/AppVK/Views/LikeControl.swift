// LikeControl.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// LikeControl-
class LikeControl: UIControl {
    // MARK: public properties

    var countOfLikes = 0

    // MARK: private properties

    private let buttonLike = UIButton()

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

    private func likeAnimation(title: String) {}

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
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                self.buttonLike.tintColor = .lightGray
                self.buttonLike.setTitle(String(self.countOfLikes), for: .normal)
                self.buttonLike.isSelected = false
            }
        } else {
            countOfLikes += 1
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear) {
                self.buttonLike.tintColor = .red
                self.buttonLike.setTitle(String(self.countOfLikes), for: .selected)
                self.buttonLike.isSelected = true
            }
        }
    }
}
