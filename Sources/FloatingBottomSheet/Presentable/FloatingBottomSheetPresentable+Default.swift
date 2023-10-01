//
//  FloatingBottomSheetPresentable+Default.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension FloatingBottomSheetPresentable where Self: UIViewController {

  public var topOffset: CGFloat {
    topLayoutOffset + 42.0
  }

  public var bottomSheetHeight: CGFloat {
    guard let scrollView = bottomSheetScrollable else { return 0 }
    scrollView.layoutIfNeeded()
    return scrollView.contentSize.height
  }

  public var allowsDragToDismiss: Bool { true }

  public var allowsTapToDismiss: Bool { true }

  public func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    true
  }

  public func willRespond(to panGestureRecognizer: UIPanGestureRecognizer) {}

  public func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    false
  }

  public func bottomSheetWillDismiss() {}

  public func bottomSheetDidDismiss() {}
}
