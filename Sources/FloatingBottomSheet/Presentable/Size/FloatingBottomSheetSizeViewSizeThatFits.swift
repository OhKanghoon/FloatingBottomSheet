//
//  FloatingBottomSheetSizeViewSizeThatFits.swift
//  FloatingBottomSheet
//
//  Created by Ray on 10/17/25.
//

import UIKit

/// A size implementation that calculates the height based on the view's `sizeThatFits(_:)` method.
///
/// This is useful when you want the bottom sheet height to automatically adjust based on
/// the intrinsic content size of your view. The view must properly implement `sizeThatFits(_:)`
/// for this to work correctly.
///
/// Example:
/// ```swift
/// var bottomSheetSize: any FloatingBottomSheetSize {
///   .viewSizeThatFits
/// }
/// ```
public struct FloatingBottomSheetSizeViewSizeThatFits: FloatingBottomSheetSize {

  /// Calculates the height by calling `sizeThatFits(_:)` on the bottom sheet's view.
  ///
  /// The method provides the available width and height to `sizeThatFits(_:)`, taking into
  /// account the container view bounds and bottom sheet insets.
  ///
  /// - Parameter context: The context containing information about the bottom sheet and container view.
  /// - Returns: The height that fits the content plus the handle area height.
  public func height(in context: Context) -> CGFloat {
    let heightThatFits = context.floatingBottomSheet.view.sizeThatFits(
      CGSize(
        width: context.containerView.bounds.width
          - context.floatingBottomSheet.bottomSheetInsets.leading
          - context.floatingBottomSheet.bottomSheetInsets.trailing,
        height: context.containerView.bounds.height
          - context.floatingBottomSheet.bottomSheetInsets.top
          - context.floatingBottomSheet.bottomSheetInsets.bottom
      )
    ).height

    return heightWithHandle(heightThatFits)
  }
}

extension FloatingBottomSheetSize where Self == FloatingBottomSheetSizeViewSizeThatFits {

  /// Creates a size that automatically fits the view's content.
  ///
  /// The bottom sheet height is calculated by calling `sizeThatFits(_:)` on the
  /// presented view controller's view. This is ideal for content with intrinsic sizing,
  /// such as views using Auto Layout or FlexLayout.
  ///
  /// - Returns: A `FloatingBottomSheetSizeViewSizeThatFits` instance.
  public static var viewSizeThatFits: Self { .init() }
}
