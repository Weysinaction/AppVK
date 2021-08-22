// PopAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// PopAnimator-
final class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: PopAnimator

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.insertSubview(destination.view, at: 0)
        destination.view.frame = source.view.frame

        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModePaced
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.5) {
                let transform = CGAffineTransform(
                    translationX: source.view.frame.width,
                    y: source.view.frame.height
                )
                let rotation = CGAffineTransform(rotationAngle: -90)

                source.view.transform = transform.concatenating(rotation)
            }
        } completion: { result in
            if result, !transitionContext.transitionWasCancelled {
                source.removeFromParent()
                transitionContext.completeTransition(true)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}
