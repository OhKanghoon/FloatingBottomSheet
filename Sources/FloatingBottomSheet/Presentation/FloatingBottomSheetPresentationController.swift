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

    enum Handle {
      static let size = CGSize(width: 40, height: 4)
      static let verticalMargin: CGFloat = 10
    }

    enum PresentedView {
      static let horizontalMargin: CGFloat = 16
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
    dimmingView.backgroundColor = UIColor(hex: "#00000080")
    dimmingView.alpha = 0
    dimmingView.addGestureRecognizer(tapGesture)
    return dimmingView
  }()

  private lazy var bottomSheetContainerView = FloatingBottomSheetContainerView(
    presentedView: presentedViewController.view,
    frame: containerView?.frame ?? .zero
  )

  private let handleView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(lightHex: "#EAEBEE", darkHex: "#34373D")
    view.layer.cornerRadius = Metric.Handle.size.height * 0.5
    return view
  }()

  public override var presentedView: UIView {
    bottomSheetContainerView
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

  private var bottomMargin: CGFloat = 0.0

  private var isPresentedViewAnimating = false

  private var scrollViewYOffset: CGFloat = 0.0

//  public override var frameOfPresentedViewInContainerView: CGRect {
//    guard var frame = containerView?.frame else { return .zero }
//    frame.size.width = frame.width - (Metric.PresentedView.horizontalMargin * 2)
//    frame.size.height = frame.height - bottomMargin - topYPosition
//    frame.origin.x = Metric.PresentedView.horizontalMargin
//    frame.origin.y = max(frame.origin.y, topYPosition)
//    return frame
//  }


  // MARK: Initializing

  deinit {
    scrollObserver?.invalidate()
  }


  // MARK: View Life Cycle

  public override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    configureViewLayout()
  }

  public override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    adjustPresentedViewFrame()
    addRoundedCorners(to: presentedView)
  }


  // MARK: Presentation Transition

  public override func presentationTransitionWillBegin() {
    guard let containerView else { return }

    layoutDimmingView(in: containerView)
    layoutPresentedView(in: containerView)
    configureScrollViewInsets()

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
       presentedView.frame.minY.rounded() <= topYPosition.rounded() {
      return true
    }

    return false
  }

  func performLayout(animated: Bool) {
    if animated {
      FloatingBottomSheetAnimator.animate({ [weak self] in
        guard let self = self else { return }
        self.isPresentedViewAnimating = true
        self.configureViewLayout()
        self.adjustPresentedViewFrame()
        self.observe(scrollView: self.presentable?.bottomSheetScrollable)
        self.configureScrollViewInsets()
      }) { [weak self] isCompleted in
        self?.isPresentedViewAnimating = !isCompleted
      }
    } else {
      configureViewLayout()
      adjustPresentedViewFrame()
      observe(scrollView: presentable?.bottomSheetScrollable)
      configureScrollViewInsets()
    }
  }

  private func layoutPresentedView(in containerView: UIView) {
    containerView.addSubview(presentedView)
    containerView.addGestureRecognizer(panGestureRecognizer)

    layoutHandleView(to: presentedView)
    addRoundedCorners(to: presentedView)

    performLayout(animated: false)
    adjustContainerBackgroundColor()
  }

  private func adjustPresentedViewFrame() {
    guard let frame = containerView?.frame else { return }

    let adjustedSize = CGSize(
      width: frame.size.width - (Metric.PresentedView.horizontalMargin * 2),
      height: frame.size.height - bottomMargin - topYPosition
    )

    bottomSheetContainerView.frame.size = adjustedSize
    bottomSheetContainerView.frame.origin.y = topYPosition
    bottomSheetContainerView.frame.origin.x = Metric.PresentedView.horizontalMargin

    presentedViewController.view.frame = CGRect(origin: .zero, size: adjustedSize)
  }

  private func adjustContainerBackgroundColor() {
    bottomSheetContainerView.backgroundColor = presentedViewController.view.backgroundColor
      ?? presentable?.bottomSheetScrollable?.backgroundColor
  }

  private func layoutDimmingView(in containerView: UIView) {
    containerView.addSubview(dimmingView)
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
      dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])
  }

  private func layoutHandleView(to view: UIView) {
    view.addSubview(handleView)
    handleView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.Handle.verticalMargin),
      handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      handleView.widthAnchor.constraint(equalToConstant: Metric.Handle.size.width),
      handleView.heightAnchor.constraint(equalToConstant: Metric.Handle.size.height),
    ])
  }

  private func configureViewLayout() {
    guard let viewControllable = presentedViewController as? FloatingBottomSheet
    else { return }

    topYPosition = viewControllable.topYPosition
    bottomMargin = viewControllable.bottomMargin
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
      let velocity = recognizer.velocity(in: presentedView)

      if isVelocityWithinSensitivityRange(velocity.y) {
        if presentedView.frame.minY < topYPosition || presentable?.allowsDragToDismiss == false {
          snap(toYPosition: topYPosition)
        } else {
          presentedViewController.dismiss(animated: true)
        }

      } else {
        let position = nearest(
          to: presentedView.frame.minY,
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

    var yDisplacement = panGestureRecognizer.translation(in: presentedView).y

    if presentedView.frame.origin.y < topYPosition {
      yDisplacement /= 2.0
    }
    adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)

    panGestureRecognizer.setTranslation(.zero, in: presentedView)
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

    let location = panGestureRecognizer.location(in: presentedView)
    return scrollView.frame.contains(location) || scrollView.isScrolling
  }

  func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    panGestureRecognizer.state == .began &&
      presentable?.shouldPrioritize(panGestureRecognizer: panGestureRecognizer) == true
  }

  func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
    (abs(velocity) - (1000 * (1 - Const.snapMovementSensitivity))) > 0
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
    presentedView.frame.origin.y = max(yPosition, topYPosition)

    guard presentedView.frame.origin.y > topYPosition else {
      dimmingView.alpha = 1.0
      return
    }

    let yDisplacementFromShortForm = presentedView.frame.origin.y - topYPosition

    dimmingView.alpha = 1.0 - (yDisplacementFromShortForm / presentedView.frame.height)
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

    presentedView.bounds.size = CGSize(width: presentedSize.width, height: presentedSize.height + yOffset)

    if oldYValue > yOffset {
      presentedView.frame.origin.y = topYPosition - yOffset
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
