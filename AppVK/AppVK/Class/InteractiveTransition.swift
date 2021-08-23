// InteractiveTransition.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// InteractiveTransition-
final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    // MARK: public properties

    var hasStarted = false
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }

    // MARK: private properties

    private var shouldFinish = false

    // MARK: private methods

    @objc func handlePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        switch gesture.state {
        case .began:
            hasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = gesture.translation(in: gesture.view)
            let relativeTranslation = translation.x / (gesture.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))

            shouldFinish = progress > 0.33

            update(progress)

        case .ended:
            hasStarted = false
            shouldFinish ? finish() : cancel()

        case .cancelled:
            hasStarted = false
            cancel()
        default:
            return
        }
    }
}
