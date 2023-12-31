//
//  FloatingBottomSheetPresentable+Internal.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension FloatingBottomSheetPresentable where Self: UIViewController {

  var bottomSheetPresentationController: FloatingBottomSheetPresentationController? {
    presentationController as? FloatingBottomSheetPresentationController
  }

  var topLayoutOffset: CGFloat {
    guard let rootVC = rootViewController else { return 0 }
    return rootVC.view.safeAreaInsets.top
  }

  var topYPosition: CGFloat {
    max(topMargin(from: bottomSheetHeight), 0) + topOffset
  }

  var bottomYPosition: CGFloat {
    guard let containerView = bottomSheetPresentationController?.containerView
    else { return view.bounds.height }

    return containerView.bounds.size.height - bottomMargin - topOffset
  }

  func topMargin(from height: CGFloat) -> CGFloat {
    bottomYPosition - height
  }

  var bottomMargin: CGFloat { 34 }
}


// MARK: - Private

extension FloatingBottomSheetPresentable {

  private var keyWindow: UIWindow? {
    if #available(iOS 15.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first
    } else {
      return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
  }

  private var rootViewController: UIViewController? {
    keyWindow?.rootViewController
  }
}
