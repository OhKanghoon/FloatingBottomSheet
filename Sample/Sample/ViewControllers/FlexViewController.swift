//
//  FlexViewController.swift
//  Sample
//
//  Created by Ray on 10/17/25.
//

import UIKit

import FlexLayout
import FloatingBottomSheet
import PinLayout

final class FlexContentView: UIView {

  private let rootFlexContainer = UIView()

  private let label: UILabel = {
    let label = UILabel()
    label.text = "This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view.This is a FlexLayout-based content view."
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private let ctaButton: UIButton = {
    let button = UIButton()
    button.configuration = .filled()
    button.setTitle("Click Me", for: .normal)
    return button
  }()

  init() {
    super.init(frame: .zero)
    defineLayout()
    backgroundColor = .systemBackground
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func defineLayout() {
    addSubview(rootFlexContainer)

    rootFlexContainer.flex.direction(.column).padding(16).define { flex in
      flex.addItem(label).marginBottom(12)
      flex.addItem(ctaButton).height(44)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    rootFlexContainer.pin.all(pin.safeArea)
    rootFlexContainer.flex.layout()
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    rootFlexContainer.flex.sizeThatFits(
      size: .init(
        width: size.width,
        height: .nan
      )
    )
  }
}

final class FlexViewController: UIViewController {

  lazy var contentView = FlexContentView()

  override func loadView() {
    view = contentView
  }
}

extension FlexViewController: FloatingBottomSheetPresentable {
  var bottomSheetScrollable: UIScrollView? {
    nil
  }

  var bottomSheetSize: any FloatingBottomSheetSize {
    .viewSizeThatFits
  }
}
