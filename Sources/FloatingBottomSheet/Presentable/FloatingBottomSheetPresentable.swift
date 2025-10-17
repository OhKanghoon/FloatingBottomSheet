//
//  FloatingBottomSheetPresentable.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

/// It is the configuration object for a view controller
/// that will be presented using transition
///
/// ```
/// extension ViewController: FloatingBottomSheetPresentable {
///
///  var bottomSheetScrollable: UIScrollView? {
///    scrollView
///  }
///
///  var bottomSheetHeight: any FloatingBottomSheetSizing {
///    .fixed(300)
///  }
/// }
/// ```
public protocol FloatingBottomSheetPresentable: AnyObject {

  /// The scroll view embedded in the view controller.
  /// it allows for seamless transition between the embedded scroll view and bottom sheet container view.
  var bottomSheetScrollable: UIScrollView? { get }

  /// The insets between the screen and the container view for a bottom sheet.
  ///
  /// The default value for `bottomSheetInsets` is
  /// - top: view.safeAreaInsets.top + 42.0
  /// - leading: 16.0
  /// - trailing: 16.0
  /// - bottom: view.safeAreaInsets.bottom + 8.0
  var bottomSheetInsets: NSDirectionalEdgeInsets { get }

  /// The height configuration for the floating bottom sheet.
  ///
  /// This property determines how the bottom sheet's height is calculated.
  /// You can use predefined sizing strategies like `.fixed(_)` or `.viewSizeThatFits`.
  ///
  /// Example:
  /// ```swift
  /// var bottomSheetHeight: any FloatingBottomSheetSizing {
  ///   .fixed(300)
  /// }
  /// ```
  ///
  /// See ``FloatingBottomSheetSizing`` for available sizing options.
  var bottomSheetHeight: any FloatingBottomSheetSizing { get }

  /// The bottom sheet corner radius
  ///
  /// The default value for `bottomSheetCornerRadius` is 20.
  var bottomSheetCornerRadius: CGFloat { get }

  /// The bottom sheet dim color
  ///
  /// The default value for `bottomSheetDimColor` is black with alpha component 0.8
  var bottomSheetDimColor: UIColor { get }

  /// The bottom sheet handle color
  ///
  /// The default value for `bottomSheetHandleColor` is `UIColor(lightHex: "#EAEBEE", darkHex: "#34373D")`
  var bottomSheetHandleColor: UIColor { get }

  /// The `allowsDragToDismiss` property determines whether the user can swipe down to dismiss the bottom sheet.
  ///
  /// If `allowsDragToDismiss` is set to `true`, the user can dismiss the bottom sheet by swiping it down.
  /// If set to `false`, this behavior is disabled.
  ///
  /// The default value for `allowsDragToDismiss` is `true`.
  var allowsDragToDismiss: Bool { get }

  /// The `allowsTapToDismiss` property determines whether the user can tap the dimmed background view to dismiss the bottom sheet.
  ///
  /// When `allowsTapToDismiss` is set to `true`, tapping on the dimmed background view will dismiss the bottom sheet.
  /// If set to `false`, this interaction is disabled.
  ///
  /// The default value for `allowsTapToDismiss` is `true`.
  var allowsTapToDismiss: Bool { get }

  /// This method is used to query the delegate about whether the bottom sheet should respond to the bottom sheet gesture recognizer.
  ///
  /// Return `false` to disable the bottom sheet's movement while keeping other gestures on the presented view intact.
  ///
  /// The default value is `true`.
  ///
  /// - Parameters:
  ///   - panGestureRecognizer: The gesture recognizer used for bottom sheet interaction.
  /// - Returns: A Boolean value indicating whether the bottom sheet should respond to the bottom sheet gesture recognizer.
  func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool

  /// This method notifies the delegate when the bottom sheet gesture recognizer's state transitions to either `began` or `changed`.
  /// It provides an opportunity for the delegate to prepare for changes in the gesture recognizer's state, such as when the bottom sheet view is about to scroll.

  /// The default implementation is an empty method.

  /// - Parameter panGestureRecognizer: The gesture recognizer used for bottom sheet interaction.
  func willRespond(to panGestureRecognizer: UIPanGestureRecognizer)

  /// Asks the delegate whether the bottom sheet gesture recognizer should be given priority for the bottom sheet.
  ///
  /// For example, you can use this method to define a region where you want to restrict the starting location of the pan gesture.
  ///
  /// If you return `false`, the decision to succeed or fail the pan gesture relies solely on internal conditions, such as whether the scrollView is actively scrolling.
  ///
  /// The default return value is `false`.
  ///
  /// - Parameter panGestureRecognizer: The gesture recognizer used for bottom sheet interaction.
  /// - Returns: A Boolean value indicating whether the bottom sheet gesture recognizer should be prioritized.
  func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool

  /// Informs the delegate that the bottom sheet is about to be dismissed.
  ///
  /// This method is called just before the bottom sheet is dismissed, giving the delegate an opportunity to perform any necessary tasks.
  ///
  /// The default behavior is an empty implementation.
  func bottomSheetWillDismiss()

  /// Informs the delegate that the bottom sheet has been dismissed.
  ///
  /// This method is called after the bottom sheet has been dismissed, allowing the delegate to perform any post-dismissal actions.
  ///
  /// The default behavior is an empty implementation.
  func bottomSheetDidDismiss()
}
