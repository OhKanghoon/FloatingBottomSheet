//
//  UIViewController+FloatingBottomSheetPresenter.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension UIViewController: FloatingBottomSheetPresenter {

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
