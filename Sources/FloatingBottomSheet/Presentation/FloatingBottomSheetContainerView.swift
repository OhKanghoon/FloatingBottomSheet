//
//  FloatingBottomSheetContainerView.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

final class FloatingBottomSheetContainerView: UIView {

  init(presentedView: UIView, frame: CGRect) {
    super.init(frame: frame)
    addSubview(presentedView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
