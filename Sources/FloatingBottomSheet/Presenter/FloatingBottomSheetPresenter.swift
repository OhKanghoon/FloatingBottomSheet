//
//  FloatingBottomSheetPresenter.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import Foundation

import UIKit

protocol FloatingBottomSheetPresenter: AnyObject {

  func presentFloatingBottomSheet(
    _ viewControllerToPresent: FloatingBottomSheet,
    completion: (() -> Void)?
  )
}
