//
//  FloatingBottomSheetPresentationAnimator.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

public final class FloatingBottomSheetPresentationAnimator: NSObject {

  public enum TransitionDirection {
    case present
    case dismiss
  }


  // MARK: Properties

  private let transitionDirection: TransitionDirection

  private var feedbackGenerator: UISelectionFeedbackGenerator?


  // MARK: Initializing

  public init(transitionDirection: TransitionDirection) {
    self.transitionDirection = transitionDirection
    super.init()

    if case .present = transitionDirection {
      self.feedbackGenerator = UISelectionFeedbackGenerator()
      feedbackGenerator?.prepare()
    }
  }
}


// MARK: - UIViewControllerAnimatedTransitioning

extension FloatingBottomSheetPresentationAnimator: UIViewControllerAnimatedTransitioning {

  public func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    0.5
  }

  public func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    switch transitionDirection {
    case .present:
      presentTransition(transitionContext: transitionContext)
    case .dismiss:
      dismissTransition(transitionContext: transitionContext)
    }
  }
}


// MARK: - Private

extension FloatingBottomSheetPresentationAnimator {

  private func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to),
          let fromViewController = transitionContext.viewController(forKey: .from)
    else {
      return
    }

    let presentable = toViewController as? FloatingBottomSheet

    fromViewController.beginAppearanceTransition(false, animated: true)

    let yOffset = presentable?.topYPosition ?? 0.0

    let bottomSheetContainerView: UIView = transitionContext.containerView.bottomSheetContainerView
      ?? toViewController.view

    bottomSheetContainerView.frame = transitionContext.finalFrame(for: toViewController)
    bottomSheetContainerView.frame.origin.y = transitionContext.containerView.frame.height

    feedbackGenerator?.selectionChanged()

    FloatingBottomSheetAnimator.animate({
      bottomSheetContainerView.frame.origin.y = yOffset
    }) { [weak self] isCompleted in
      fromViewController.endAppearanceTransition()
      transitionContext.completeTransition(isCompleted)
      self?.feedbackGenerator = nil
    }
  }

  private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to),
          let fromViewController = transitionContext.viewController(forKey: .from)
    else {
      return
    }

    toViewController.beginAppearanceTransition(true, animated: true)

    let bottomSheetContainerView: UIView = transitionContext.containerView.bottomSheetContainerView
      ?? fromViewController.view

    FloatingBottomSheetAnimator.animate({
      bottomSheetContainerView.frame.origin.y = transitionContext.containerView.frame.height
    }) { isCompleted in
      fromViewController.view.removeFromSuperview()
      toViewController.endAppearanceTransition()
      transitionContext.completeTransition(isCompleted)
    }
  }
}

extension UIView {

  fileprivate var bottomSheetContainerView: FloatingBottomSheetContainerView? {
    subviews.first(where: { view -> Bool in
      view is FloatingBottomSheetContainerView
    }) as? FloatingBottomSheetContainerView
  }
}

