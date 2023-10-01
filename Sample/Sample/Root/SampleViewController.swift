//
//  SampleViewController.swift
//  Sample
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

import FloatingBottomSheet

final class SampleViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = "FloatingBottomSheet"

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    tableView.tableFooterView = UIView()
    tableView.separatorInset = .zero
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60.0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    SampleRow.allCases.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)

    guard let rowType = SampleRow(rawValue: indexPath.row) else {
      return cell
    }
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.text = rowType.viewModel.title
    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let rowType = SampleRow(rawValue: indexPath.row) else {
      return
    }
    dismiss(animated: true, completion: nil)
    presentFloatingBottomSheet(rowType.viewModel.rowViewController, completion: nil)
  }
}
