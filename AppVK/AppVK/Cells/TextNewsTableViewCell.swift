// TextNewsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// TextNewsTableViewCell-
class TextNewsTableViewCell: UITableViewCell {
    // MARK: IBOutlet

    @IBOutlet private var postTextView: UITextView!

    // MARK: public properties

    var newsText = ""

    // MARK: TextNewsTableViewCell

    override func layoutSubviews() {
        setupLabel()
    }

    // MARK: private methods

    private func setupLabel() {
        postTextView.text = newsText
    }
}
