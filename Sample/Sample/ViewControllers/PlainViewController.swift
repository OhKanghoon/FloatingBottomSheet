//
//  PlainViewController.swift
//  Sample
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

import FloatingBottomSheet

final class PlainViewController: UIViewController, FloatingBottomSheetPresentable {

  private let scrollView = UIScrollView()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10.0
    stackView.distribution = .fill
    return stackView
  }()

  var bottomSheetHeight: CGFloat = 200

  var bottomSheetSize: any FloatingBottomSheetSize {
    .fixed(bottomSheetHeight)
  }

  var bottomSheetScrollable: UIScrollView? {
    scrollView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    addSubviews()
    configureConstraint()
  }

  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)

    let increaseButton = makeButton(title: "+ Increase Height", color: .systemBlue) { [weak self] in
      self?.bottomSheetHeight += 100
      self?.bottomSheetPerformLayout(animated: true)
    }
    let decreaseButton = makeButton(title: "- Decrease Height", color: .systemRed) { [weak self] in
      self?.bottomSheetHeight -= 100
      self?.bottomSheetPerformLayout(animated: true)
    }
    stackView.addArrangedSubview(increaseButton)
    stackView.addArrangedSubview(decreaseButton)

    (0...5).forEach { _ in
      stackView.addArrangedSubview(makeLabel())
    }
  }

  private func makeButton(title: String, color: UIColor, handler: @escaping () -> Void) -> UIButton {
    let button = UIButton(configuration: .filled())
    button.configuration?.baseBackgroundColor = color
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.setTitleColor(.white, for: .normal)
    button.setTitle(title, for: .normal)
    button.addAction(UIAction(handler: { _ in handler() }), for: .touchUpInside)
    return button
  }

  private func makeLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.text = """
      Lorem ipsum dolor sit amet consectetur adipisicing elit. Laborum minima voluptas officia eaque eveniet cupiditate dolores exercitationem soluta consequuntur rem blanditiis, odit delectus assumenda, beatae aliquam quidem voluptate nemo veniam.
      """
    label.backgroundColor = .systemGray6
    return label
  }

  private func configureConstraint() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])

    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
      stackView.trailingAnchor .constraint(equalTo: scrollView.trailingAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
      stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
    ])
  }
}
