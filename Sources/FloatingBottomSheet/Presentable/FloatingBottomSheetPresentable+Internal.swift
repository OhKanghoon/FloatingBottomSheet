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

  var containerViewHeight: CGFloat {
    bottomSheetHeight + BottomSheetHandleMetric.verticalMargin * 2 + BottomSheetHandleMetric.size.height
  }

  var topYPosition: CGFloat {
    max(topMargin(from: containerViewHeight), 0) + bottomSheetInsets.top
  }

  var bottomYPosition: CGFloat {
    guard let containerView = bottomSheetPresentationController?.containerView
    else { return view.bounds.height }

    return containerView.bounds.size.height - bottomSheetInsets.bottom - bottomSheetInsets.top
  }

  private func topMargin(from height: CGFloat) -> CGFloat {
    bottomYPosition - height
  }
}
