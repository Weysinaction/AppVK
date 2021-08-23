// PushAnimator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// PushAnimator-
final class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: PushAnimator

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame

        let transform = CGAffineTransform(translationX: destination.view.frame.width, y: destination.view.frame.height)
        let rotation = CGAffineTransform(rotationAngle: -90)

        destination.view.transform = transform.concatenating(rotation)
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModePaced
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75) {
                destination.view.transform = .identity
            }
        } completion: { result in
            if result, !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                transitionContext.completeTransition(true)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}
