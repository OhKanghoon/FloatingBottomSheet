//
//  FloatingBottomSheetPresentationDelegate.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

public final class FloatingBottomSheetPresentationDelegate: NSObject {

  public static var `default` = FloatingBottomSheetPresentationDelegate()
}


// MARK: - UIViewControllerTransitioningDelegate

extension FloatingBottomSheetPresentationDelegate: UIViewControllerTransitioningDelegate {

  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    FloatingBottomSheetPresentationAnimator(transitionDirection: .present)
  }

  public func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    FloatingBottomSheetPresentationAnimator(transitionDirection: .dismiss)
  }

  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    let controller = FloatingBottomSheetPresentationController(
      presentedViewController: presented,
      presenting: presenting
    )
    controller.delegate = self
    return controller
  }
}


// MARK: - UIAdaptivePresentationControllerDelegate

extension FloatingBottomSheetPresentationDelegate: UIAdaptivePresentationControllerDelegate {

  public func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
    .none
  }
}
