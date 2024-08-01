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

  var topYPosition: CGFloat {
    max(topMargin(from: containerViewHeight), 0) + bottomSheetInsets.top
  }

  private var containerViewHeight: CGFloat {
    bottomSheetHeight
      + FloatingBottomSheetHandleMetric.verticalMargin * 2
      + FloatingBottomSheetHandleMetric.size.height
  }

  private var bottomYPosition: CGFloat {
    guard let containerView = bottomSheetPresentationController?.containerView
    else { return view.bounds.height }

    return containerView.bounds.size.height - bottomSheetInsets.bottom - bottomSheetInsets.top
  }

  private func topMargin(from height: CGFloat) -> CGFloat {
    bottomYPosition - height
  }
}
