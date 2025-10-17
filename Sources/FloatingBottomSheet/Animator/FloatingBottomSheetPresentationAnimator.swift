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
    guard let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }

    let containerView = transitionContext.containerView
    let bottomSheetContainerView: UIView = containerView.bottomSheetContainerView
      ?? toViewController.view

    // Calculate layout using shared calculation logic
    let yOffset: CGFloat
    if let floatingBottomSheet = toViewController as? FloatingBottomSheet {
      let layout = FloatingBottomSheetLayout.calculate(
        floatingBottomSheet: floatingBottomSheet,
        in: containerView
      )
      yOffset = layout.topYPosition
    } else {
      yOffset = 0.0
    }

    bottomSheetContainerView.frame = transitionContext.finalFrame(for: toViewController)
    bottomSheetContainerView.frame.origin.y = containerView.frame.height

    feedbackGenerator?.selectionChanged()

    FloatingBottomSheetAnimator.animate({
      bottomSheetContainerView.frame.origin.y = yOffset
    }) { [weak self] isCompleted in
      transitionContext.completeTransition(isCompleted)
      self?.feedbackGenerator = nil
    }
  }

  private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from) else {
      return
    }

    let bottomSheetContainerView: UIView = transitionContext.containerView.bottomSheetContainerView
      ?? fromViewController.view

    FloatingBottomSheetAnimator.animate({
      bottomSheetContainerView.frame.origin.y = transitionContext.containerView.frame.height
    }) { isCompleted in
      fromViewController.view.removeFromSuperview()
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

