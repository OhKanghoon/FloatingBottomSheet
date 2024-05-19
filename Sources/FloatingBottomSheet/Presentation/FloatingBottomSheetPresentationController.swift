//
//  FloatingBottomSheetPresentationController.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

public final class FloatingBottomSheetPresentationController: UIPresentationController {

  // MARK: Constants

  private enum Metric {

    enum PresentedView {
      static let cornerRadius: CGFloat = 20
    }
  }

  private enum Const {
    static let snapMovementSensitivity: CGFloat = 0.5
  }


  // MARK: UI

  private var presentable: FloatingBottomSheetPresentable? {
    presentedViewController as? FloatingBottomSheetPresentable
  }

  private lazy var dimmingView: UIView = {
    let dimmingView = UIView()
    dimmingView.alpha = 0
    dimmingView.addGestureRecognizer(tapGesture)
    return dimmingView
  }()

  private lazy var bottomSheetContainerView = FloatingBottomSheetContainerView(
    presentedView: presentedViewController.view,
    frame: containerView?.frame ?? .zero
  )

  private lazy var handleView: UIView = {
    let view = UIView()
    view.backgroundColor = presentable?.bottomSheetHandleColor
    view.layer.cornerRadius = BottomSheetHandleMetric.size.height * 0.5
    return view
  }()

  public override var presentedView: UIView {
    bottomSheetContainerView.bringSubviewToFront(handleView)
    return bottomSheetContainerView
  }

  public override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerViewFrame = containerView?.frame else { return .zero }
    let adjustedSize = CGSize(
      width: containerViewFrame.size.width - bottomSheetInsets.leading - bottomSheetInsets.trailing,
      height: containerViewFrame.size.height - bottomSheetInsets.bottom - topYPosition
    )

    return CGRect(
      x: bottomSheetInsets.leading,
      y: topYPosition,
      width: adjustedSize.width,
      height: adjustedSize.height
    )
  }

  // MARK: Gesture

  private lazy var tapGesture = UITapGestureRecognizer(
    target: self,
    action: #selector(didTapDimmingView)
  )

  private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnPresentedView(_ :)))
    gesture.minimumNumberOfTouches = 1
    gesture.maximumNumberOfTouches = 1
    gesture.delegate = self
    return gesture
  }()


  // MARK: Properties

  private var scrollObserver: NSKeyValueObservation?

  private var topYPosition: CGFloat = 0.0

  private var bottomSheetInsets: NSDirectionalEdgeInsets = .zero

  private var isPresentedViewAnimating = false

  private var scrollViewYOffset: CGFloat = 0.0


  // MARK: Initializing

  deinit {
    scrollObserver?.invalidate()
  }


  // MARK: View Life Cycle

  public override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    configureViewLayout()
    presentedView.frame = frameOfPresentedViewInContainerView
    presentedViewController.view.frame.size = frameOfPresentedViewInContainerView.size
  }

  public override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    adjustHandleViewFrame()
    adjustPresentedViewControllerTopInset()
    addRoundedCorners(to: bottomSheetContainerView)
  }


  // MARK: Presentation Transition

  public override func presentationTransitionWillBegin() {
    guard let containerView else { return }

    bottomSheetContainerView.addSubview(handleView)
    bottomSheetContainerView.addGestureRecognizer(panGestureRecognizer)

    containerView.addSubview(dimmingView)
    containerView.addSubview(bottomSheetContainerView)

    layoutDimmingView(in: containerView)
    performLayout(animated: false)
    adjustBackgroundColors()

    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 1.0
      return
    }

    coordinator.animate(alongsideTransition: { [weak self] _ in
      self?.dimmingView.alpha = 1.0
      self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
    })
  }

  public override func presentationTransitionDidEnd(_ completed: Bool) {
    guard !completed else { return }

    dimmingView.removeFromSuperview()
  }


  // MARK: Dismissal Transition

  public override func dismissalTransitionWillBegin() {
    presentable?.bottomSheetWillDismiss()

    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }

    coordinator.animate { [weak self] _ in
      self?.dimmingView.alpha = 0.0
      self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
    }
  }

  public override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed { return }

    presentable?.bottomSheetDidDismiss()
  }
}


// MARK: - Presented View Layout

extension FloatingBottomSheetPresentationController {

  var isPresentedViewAnchored: Bool {
    if !isPresentedViewAnimating,
       bottomSheetContainerView.frame.minY.rounded() <= topYPosition.rounded() {
      return true
    }

    return false
  }

  func performLayout(animated: Bool) {
    if animated {
      FloatingBottomSheetAnimator.animate({ [weak self] in
        guard let self else { return }
        isPresentedViewAnimating = true
        configureViewLayout()
        observe(scrollView: presentable?.bottomSheetScrollable)
        configureScrollViewInsets()
        containerView?.setNeedsLayout()
        containerView?.layoutIfNeeded()
      }) { [weak self] isCompleted in
        self?.isPresentedViewAnimating = !isCompleted
      }
    } else {
      configureViewLayout()
      observe(scrollView: presentable?.bottomSheetScrollable)
      configureScrollViewInsets()
      containerView?.setNeedsLayout()
      containerView?.layoutIfNeeded()
    }
  }

  private func adjustHandleViewFrame() {
    handleView.frame.origin.y = BottomSheetHandleMetric.verticalMargin
    handleView.frame.size = BottomSheetHandleMetric.size
    handleView.center.x = CGRectGetMidX(bottomSheetContainerView.bounds)
  }

  private func adjustPresentedViewControllerTopInset() {
    presentedViewController.additionalSafeAreaInsets.top = handleView.frame.maxY + BottomSheetHandleMetric
      .verticalMargin
  }

  private func adjustBackgroundColors() {
    dimmingView.backgroundColor = presentable?.bottomSheetDimColor

    handleView.backgroundColor = presentable?.bottomSheetHandleColor

    bottomSheetContainerView.backgroundColor = presentedViewController.view.backgroundColor
      ?? presentable?.bottomSheetScrollable?.backgroundColor
  }

  private func layoutDimmingView(in containerView: UIView) {
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
      dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])
  }

  private func configureViewLayout() {
    guard let viewControllable = presentedViewController as? FloatingBottomSheet
    else { return }

    topYPosition = viewControllable.topYPosition
    bottomSheetInsets = viewControllable.bottomSheetInsets
  }

  private func configureScrollViewInsets() {
    guard let scrollView = presentable?.bottomSheetScrollable,
          !scrollView.isScrolling
    else { return }

    scrollView.showsVerticalScrollIndicator = false
    scrollView.contentInsetAdjustmentBehavior = .never
  }

  private func addRoundedCorners(to view: UIView) {
    view.layer.cornerRadius = Metric.PresentedView.cornerRadius
    view.layer.masksToBounds = true
  }
}


// MARK: - Gesture

extension FloatingBottomSheetPresentationController {

  @objc
  private func didTapDimmingView() {
    guard presentable?.allowsTapToDismiss == true else { return }
    presentedViewController.dismiss(animated: true)
  }

  @objc
  private func didPanOnPresentedView(_ recognizer: UIPanGestureRecognizer) {
    guard shouldRespond(to: recognizer),
          let containerView
    else {
      recognizer.setTranslation(.zero, in: recognizer.view)
      return
    }

    switch recognizer.state {
    case .began, .changed:
      respond(to: recognizer)

    default:
      let velocity = recognizer.velocity(in: bottomSheetContainerView)

      if isVelocityWithinSensitivityRange(velocity.y) {
        if bottomSheetContainerView.frame.minY < topYPosition || presentable?.allowsDragToDismiss == false {
          snap(toYPosition: topYPosition)
        } else {
          presentedViewController.dismiss(animated: true)
        }

      } else {
        let position = nearest(
          to: bottomSheetContainerView.frame.minY,
          inValues: [containerView.bounds.height, topYPosition]
        )

        if position == topYPosition || presentable?.allowsDragToDismiss == false {
          snap(toYPosition: topYPosition)
        } else {
          presentedViewController.dismiss(animated: true)
        }
      }
    }
  }

  func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    guard presentable?.shouldRespond(to: panGestureRecognizer) == true ||
      !(panGestureRecognizer.state == .began || panGestureRecognizer.state == .cancelled)
    else {
      panGestureRecognizer.isEnabled = false
      panGestureRecognizer.isEnabled = true
      return false
    }
    return !shouldFail(panGestureRecognizer: panGestureRecognizer)
  }

  func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
    presentable?.willRespond(to: panGestureRecognizer)

    var yDisplacement = panGestureRecognizer.translation(in: bottomSheetContainerView).y

    if bottomSheetContainerView.frame.origin.y < topYPosition {
      yDisplacement /= 2.0
    }
    adjust(toYPosition: bottomSheetContainerView.frame.origin.y + yDisplacement)

    panGestureRecognizer.setTranslation(.zero, in: bottomSheetContainerView)
  }

  func shouldFail(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    guard !shouldPrioritize(panGestureRecognizer: panGestureRecognizer)
    else {
      presentable?.bottomSheetScrollable?.panGestureRecognizer.isEnabled = false
      presentable?.bottomSheetScrollable?.panGestureRecognizer.isEnabled = true
      return false
    }

    guard isPresentedViewAnchored,
          let scrollView = presentable?.bottomSheetScrollable,
          scrollView.contentOffset.y > 0
    else {
      return false
    }

    let location = panGestureRecognizer.location(in: bottomSheetContainerView)
    return scrollView.frame.contains(location) || scrollView.isScrolling
  }

  func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    panGestureRecognizer.state == .began &&
      presentable?.shouldPrioritize(panGestureRecognizer: panGestureRecognizer) == true
  }

  func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
    (velocity - (1000 * (1 - Const.snapMovementSensitivity))) > 0
  }

  func snap(toYPosition yPosition: CGFloat) {
    FloatingBottomSheetAnimator.animate({ [weak self] in
      self?.adjust(toYPosition: yPosition)
      self?.isPresentedViewAnimating = true
    }) { [weak self] isCompleted in
      self?.isPresentedViewAnimating = !isCompleted
    }
  }

  func adjust(toYPosition yPosition: CGFloat) {
    bottomSheetContainerView.frame.origin.y = max(yPosition, topYPosition)

    guard bottomSheetContainerView.frame.origin.y > topYPosition else {
      dimmingView.alpha = 1.0
      return
    }

    let yDisplacementFromShortForm = bottomSheetContainerView.frame.origin.y - topYPosition

    dimmingView.alpha = 1.0 - (yDisplacementFromShortForm / bottomSheetContainerView.frame.height)
  }

  func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
    guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
    else { return number }
    return nearestVal
  }
}


// MARK: - UIGestureRecognizerDelegate

extension FloatingBottomSheetPresentationController: UIGestureRecognizerDelegate {

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    false
  }

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    otherGestureRecognizer.view == presentable?.bottomSheetScrollable
  }
}


// MARK: - UIScrollView Observer

extension FloatingBottomSheetPresentationController {

  private func observe(scrollView: UIScrollView?) {
    scrollObserver?.invalidate()
    scrollObserver = scrollView?.observe(\.contentOffset, options: .old) { [weak self] scrollView, change in
      guard self?.containerView != nil else { return }

      self?.didPanOnScrollView(scrollView, change: change)
    }
  }

  private func didPanOnScrollView(
    _ scrollView: UIScrollView,
    change: NSKeyValueObservedChange<CGPoint>
  ) {
    guard !presentedViewController.isBeingDismissed,
          !presentedViewController.isBeingPresented
    else { return }

    if !isPresentedViewAnchored, scrollView.contentOffset.y > 0 {
      haltScrolling(scrollView)
      return
    }

    if scrollView.isScrolling || isPresentedViewAnimating {
      if isPresentedViewAnchored {
        trackScrolling(scrollView)
      } else {
        haltScrolling(scrollView)
      }
      return
    }

    if presentedViewController.view.isKind(of: UIScrollView.self),
       !isPresentedViewAnimating, scrollView.contentOffset.y <= 0 {
      handleScrollViewTopBounce(scrollView: scrollView, change: change)
      return
    }

    trackScrolling(scrollView)
  }

  private func haltScrolling(_ scrollView: UIScrollView) {
    scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: false)
    scrollView.showsVerticalScrollIndicator = false
  }

  private func trackScrolling(_ scrollView: UIScrollView) {
    scrollViewYOffset = max(scrollView.contentOffset.y, 0)
    scrollView.showsVerticalScrollIndicator = true
  }

  private func handleScrollViewTopBounce(scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
    guard let oldYValue = change.oldValue?.y, scrollView.isDecelerating else { return }

    let yOffset = scrollView.contentOffset.y
    let presentedSize = containerView?.frame.size ?? .zero

    bottomSheetContainerView.bounds.size = CGSize(width: presentedSize.width, height: presentedSize.height + yOffset)

    if oldYValue > yOffset {
      bottomSheetContainerView.frame.origin.y = topYPosition - yOffset
    } else {
      scrollViewYOffset = 0
      snap(toYPosition: topYPosition)
    }

    scrollView.showsVerticalScrollIndicator = false
  }
}

extension UIScrollView {

  fileprivate var isScrolling: Bool {
    isDragging && !isDecelerating || isTracking
  }
}
