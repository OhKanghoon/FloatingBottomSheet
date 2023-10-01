//
//  FloatingBottomSheetPresentable+UIViewController.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension FloatingBottomSheetPresentable where Self: UIViewController {

  public func bottomSheetPerformLayout(animated: Bool) {
    bottomSheetPresentationController?.performLayout(animated: animated)
  }
}
