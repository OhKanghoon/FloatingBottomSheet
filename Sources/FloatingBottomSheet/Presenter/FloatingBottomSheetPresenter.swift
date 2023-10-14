//
//  FloatingBottomSheetPresenter.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

/// Protocol for presenting a floating bottom sheet.
protocol FloatingBottomSheetPresenter: AnyObject {

  /// A boolean property indicating whether a floating bottom sheet is currently presented.
  var isFloatingBottomSheetPresented: Bool { get }

  /// Presents a floating bottom sheet.
  ///
  /// - Parameters:
  ///   - viewControllerToPresent: The FloatingBottomSheet view controller to present.
  ///   - completion: A closure to be executed after the presentation is complete.
  func presentFloatingBottomSheet(
    _ viewControllerToPresent: FloatingBottomSheet,
    completion: (() -> Void)?
  )
}
