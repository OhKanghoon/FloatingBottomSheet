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
    safeAreaInsets.top
  }

  var containerViewHeight: CGFloat {
    bottomSheetHeight + BottomSheetHandleMetric.verticalMargin * 2 + BottomSheetHandleMetric.size.height
  }

  var topYPosition: CGFloat {
    max(topMargin(from: containerViewHeight), 0) + topOffset
  }

  var bottomYPosition: CGFloat {
    guard let containerView = bottomSheetPresentationController?.containerView
    else { return view.bounds.height }

    return containerView.bounds.size.height - bottomMargin - topOffset
  }

  func topMargin(from height: CGFloat) -> CGFloat {
    bottomYPosition - height
  }

  var bottomMargin: CGFloat {
    safeAreaInsets.bottom + 20
  }
}


// MARK: - Private

extension FloatingBottomSheetPresentable {

  private var safeAreaInsets: UIEdgeInsets {
    guard let rootViewController else { return .zero }
    return rootViewController.view.safeAreaInsets
  }

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
