//
//  FloatingBottomSheetAnimator.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

enum FloatingBottomSheetAnimator {

  static func animate(
    _ animations: @escaping () -> Void,
    _ completion: ((Bool) -> Void)? = nil
  ) {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
      animations: animations,
      completion: completion
    )
  }
}
