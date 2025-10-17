//
//  FloatingBottomSheetSizeFixed.swift
//  FloatingBottomSheet
//
//  Created by Ray on 10/17/25.
//

import UIKit

/// A size implementation that provides a fixed height for the floating bottom sheet.
///
/// Use this when you want to set a specific height for your bottom sheet that doesn't change
/// based on the content or container size.
///
/// Example:
/// ```swift
/// var bottomSheetSize: any FloatingBottomSheetSize {
///   .fixed(300)
/// }
/// ```
public struct FloatingBottomSheetSizeFixed: FloatingBottomSheetSize {

  /// The fixed height for the content area of the bottom sheet, excluding the handle area.
  let height: CGFloat

  /// Returns the total height including the handle area.
  /// - Parameter context: The context containing information about the bottom sheet and container view.
  /// - Returns: The fixed height plus the handle area height.
  public func height(in context: Context) -> CGFloat {
    heightWithHandle(height)
  }
}

extension FloatingBottomSheetSize where Self == FloatingBottomSheetSizeFixed {

  /// Creates a fixed height for the floating bottom sheet.
  ///
  /// The actual height of the bottom sheet container will be the specified height plus
  /// the handle area (handle height + vertical margins).
  ///
  /// - Parameter height: The desired height for the content area of the bottom sheet.
  /// - Returns: A `FloatingBottomSheetSizeFixed` instance with the specified height.
  public static func fixed(_ height: CGFloat) -> Self {
    .init(height: height)
  }
}
