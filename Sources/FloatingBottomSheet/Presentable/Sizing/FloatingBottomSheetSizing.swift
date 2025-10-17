//
//  FloatingBottomSheetSizing.swift
//  FloatingBottomSheet
//
//  Created by Ray on 10/17/25.
//

import UIKit

/// A protocol that defines the sizing behavior of a floating bottom sheet.
///
/// Conform to this protocol to create custom sizing behaviors for your bottom sheets.
/// The protocol provides a context-aware approach where you can calculate the height
/// based on the container view dimensions and the bottom sheet configuration.
///
/// Example:
/// ```swift
/// struct CustomSizing: FloatingBottomSheetSizing {
///   func height(in context: Context) -> CGFloat {
///     // Your custom height calculation
///     return heightWithHandle(200)
///   }
/// }
/// ```
public protocol FloatingBottomSheetSizing {

  /// The context for calculating the height of the floating bottom sheet.
  typealias Context = FloatingBottomSheetSizingContext

  /// Returns the height of the floating bottom sheet in the given context.
  ///
  /// Implement this method to provide custom height calculation logic.
  /// Use the provided context to access information about the container view
  /// and the bottom sheet configuration.
  ///
  /// - Parameter context: The context for calculating the height.
  /// - Returns: The total height of the floating bottom sheet, including the handle area.
  func height(in context: Self.Context) -> CGFloat
}

extension FloatingBottomSheetSizing {

  /// Calculates the total height including the handle area.
  /// - Parameter contentHeight: The height of the content area
  /// - Returns: Total height including handle area
  func heightWithHandle(_ contentHeight: CGFloat) -> CGFloat {
    contentHeight
      + FloatingBottomSheetHandleMetric.verticalMargin * 2
      + FloatingBottomSheetHandleMetric.size.height
  }
}

/// The context for calculating the height of the floating bottom sheet.
///
/// This structure provides access to the necessary information for calculating
/// the bottom sheet height, including the bottom sheet view controller and the
/// container view dimensions.
public struct FloatingBottomSheetSizingContext {

  /// The presented floating bottom sheet view controller.
  ///
  /// Use this to access properties like `bottomSheetInsets` or the view itself
  /// when calculating the appropriate height.
  public let floatingBottomSheet: FloatingBottomSheet

  /// The container view in which the floating bottom sheet is presented.
  ///
  /// Use this to access the available space dimensions when calculating
  /// the bottom sheet height.
  public let containerView: UIView

  /// Creates a context for calculating the floating bottom sheet size.
  ///
  /// - Parameters:
  ///   - floatingBottomSheet: The bottom sheet view controller being presented.
  ///   - containerView: The container view in which the bottom sheet is presented.
  init(
    floatingBottomSheet: FloatingBottomSheet,
    containerView: UIView
  ) {
    self.floatingBottomSheet = floatingBottomSheet
    self.containerView = containerView
  }
}
