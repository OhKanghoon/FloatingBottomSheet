//
//  UIViewController+FloatingBottomSheetPresenter.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension UIViewController: FloatingBottomSheetPresenter {

  /// A flag that returns true if the topmost view controller in the navigation stack
  /// was presented using the custom FloatingBottomSheet transition.
  ///
  /// - Warning: ⚠️ Calling `transitioningDelegate` in this function may cause a memory leak. ⚠️
  ///
  /// In most cases, this check will be used early in the view lifecycle and unfortunately,
  /// there's a potential issue that causes a memory leak if the `transitioningDelegate` is
  /// referenced here and called too early, resulting in a strong reference to this view controller.
  public var isFloatingBottomSheetPresented: Bool {
    (transitioningDelegate as? FloatingBottomSheetPresentationDelegate) != nil
  }

  /// Configures a view controller for presentation using the FloatingBottomSheet transition.
  ///
  /// - Parameters:
  ///   - viewControllerToPresent: The view controller to be presented.
  ///   - completion: The block to execute after the presentation finishes. You may specify nil for this parameter.
  ///
  /// The function sets the modal presentation style and related properties for the specified view controller
  /// to achieve a FloatingBottomSheet presentation. It also assigns the appropriate transitioning delegate
  /// for the presentation style.
  public func presentFloatingBottomSheet(
    _ viewControllerToPresent: FloatingBottomSheet,
    completion: (() -> Void)? = nil
  ) {
    viewControllerToPresent.modalPresentationStyle = .custom
    viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
    viewControllerToPresent.transitioningDelegate = FloatingBottomSheetPresentationDelegate.default

    present(viewControllerToPresent, animated: true, completion: completion)
  }
}
