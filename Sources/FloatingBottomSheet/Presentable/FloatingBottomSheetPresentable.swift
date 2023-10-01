//
//  FloatingBottomSheetPresentable.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

public protocol FloatingBottomSheetPresentable: AnyObject {

  var bottomSheetScrollable: UIScrollView? { get }

  var topOffset: CGFloat { get }
  var bottomSheetHeight: CGFloat { get }

  var allowsDragToDismiss: Bool { get }
  var allowsTapToDismiss: Bool { get }

  func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool
  func willRespond(to panGestureRecognizer: UIPanGestureRecognizer)
  func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool

  func bottomSheetWillDismiss()
  func bottomSheetDidDismiss()
}
