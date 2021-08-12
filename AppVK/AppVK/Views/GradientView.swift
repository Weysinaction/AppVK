// GradientView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// GradientView-
class GradientView: UIView {
    // MARK: static properties

    override static var layerClass: AnyClass {
        CAGradientLayer.self
    }

    // MARK: private properties

    private var gradientLayer: CAGradientLayer {
        guard let layer = self.layer as? CAGradientLayer else { return CAGradientLayer() }
        return layer
    }

    private var endPoint = CGPoint(x: 0, y: 1) {
        didSet {
            updateEndPoint()
        }
    }

    // MARK: IBInspectable

    @IBInspectable private var startColor: UIColor = .blue {
        didSet {
            updateColors()
        }
    }

    @IBInspectable private var endColor: UIColor = .systemPink {
        didSet {
            updateColors()
        }
    }

    @IBInspectable private var startLocation: CGFloat = 0 {
        didSet {
            updateLocations()
        }
    }

    @IBInspectable private var endLocation: CGFloat = 1 {
        didSet {
            updateLocations()
        }
    }

    @IBInspectable private var startPoint: CGPoint = .zero {
        didSet {
            updateStartPoint()
        }
    }

    // MARK: private methods

    private func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }

    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }

    private func updateStartPoint() {
        gradientLayer.startPoint = startPoint
    }

    private func updateEndPoint() {
        gradientLayer.endPoint = endPoint
    }
}
