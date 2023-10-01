//
//  SampleModels.swift
//  Sample
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import Foundation

import FloatingBottomSheet

protocol SampleViewModel {
  var title: String { get }
  var rowViewController: FloatingBottomSheet { get }
}

enum SampleRow: Int, CaseIterable {
  case plain

  var viewModel: SampleViewModel {
    switch self {
    case .plain: return PlainViewModel()
    }
  }
}

extension SampleRow {

  struct PlainViewModel: SampleViewModel {
    let title = "Plain"
    let rowViewController: FloatingBottomSheet = PlainViewController()
  }
}

