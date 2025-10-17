//
//  FloatingBottomSheetPresentable+UIViewController.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension FloatingBottomSheetPresentable where Self: UIViewController {

  var bottomSheetPresentationController: FloatingBottomSheetPresentationController? {
    presentationController as? FloatingBottomSheetPresentationController
  }

  /// Triggers layout changes for the bottom sheet presentation controller.
  ///
  /// This method can be called to initiate layout changes for the bottom sheet presentation controller.
  /// The `animated` parameter determines whether the layout updates should be performed with animation.
  ///
  /// - Parameter animated: A Boolean value indicating whether the layout changes should be performed with animation.
  public func bottomSheetPerformLayout(animated: Bool) {
    bottomSheetPresentationController?.performLayout(animated: animated)
  }
}
