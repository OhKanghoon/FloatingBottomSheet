//
//  FloatingBottomSheetLayout.swift
//  FloatingBottomSheet
//
//  Created by Ray on 10/17/25.
//

import UIKit

/// Encapsulates all layout calculations for a floating bottom sheet.
///
/// This struct provides a pure functional approach to calculating the position and frame
/// of a floating bottom sheet, keeping calculation logic separate from configuration and presentation.
struct FloatingBottomSheetLayout {

  /// The top Y position of the bottom sheet in the container view.
  let topYPosition: CGFloat

  /// The complete frame of the bottom sheet in the container view.
  let frame: CGRect

  /// A zero layout used as a fallback.
  static let zero = FloatingBottomSheetLayout(topYPosition: 0, frame: .zero)

  /// Calculates the layout for a floating bottom sheet.
  ///
  /// This is a pure function that takes the presentable and container information
  /// and returns the calculated layout without any side effects.
  ///
  /// - Parameters:
  ///   - floatingBottomSheet: The floating bottom sheet.
  ///   - containerView: The container view in which the bottom sheet will be presented.
  /// - Returns: A `FloatingBottomSheetLayout` containing the calculated position and frame.
  static func calculate(
    floatingBottomSheet: FloatingBottomSheet,
    in containerView: UIView
  ) -> FloatingBottomSheetLayout {
    let insets = floatingBottomSheet.bottomSheetInsets

    // Calculate total height including handle area
    let totalHeight = floatingBottomSheet.bottomSheetHeight.height(
      in: .init(
        floatingBottomSheet: floatingBottomSheet,
        containerView: containerView
      )
    )

    // Calculate available height for content
    let availableHeight = containerView.bounds.height - insets.top - insets.bottom

    // Calculate top position: available space minus sheet height, plus top inset
    let calculatedTopY = availableHeight - totalHeight + insets.top
    let topY = max(calculatedTopY, insets.top)

    // Calculate frame
    let frame = CGRect(
      x: insets.leading,
      y: topY,
      width: containerView.bounds.width - insets.leading - insets.trailing,
      height: containerView.bounds.height - insets.bottom - topY
    )

    return FloatingBottomSheetLayout(topYPosition: topY, frame: frame)
  }
}
