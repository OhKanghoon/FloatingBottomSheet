//
//  UIColor+Init.swift
//
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

extension UIColor {

  convenience init(
    r: Int,
    g: Int,
    b: Int,
    a: Int? = nil
  ) {
    self.init(
      red: CGFloat(r) / 255,
      green: CGFloat(g) / 255,
      blue: CGFloat(b) / 255,
      alpha: CGFloat(a ?? 255) / 255
    )
  }

  convenience init(hex: String) {
    let hexSanitized = hex
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0

    let length = hexSanitized.count

    if Scanner(string: hexSanitized).scanHexInt64(&rgb) == true {
      if length == 6 {
        r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        b = CGFloat(rgb & 0x0000FF) / 255.0

      } else if length == 8 {
        r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
        g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
        b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
        a = CGFloat(rgb & 0x000000FF) / 255.0
      }
    }

    self.init(red: r, green: g, blue: b, alpha: a)
  }

  convenience init(light: UIColor, dark: UIColor) {
    if #available(iOS 13.0, *) {
      self.init(dynamicProvider: {
        switch $0.userInterfaceStyle {
        case .light, .unspecified:
          return light
        case .dark:
          return dark
        @unknown default:
          assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
          return light
        }
      })
    } else {
      self.init(cgColor: light.cgColor)
    }
  }

  convenience init(lightHex: String, darkHex: String) {
    if #available(iOS 13.0, *) {
      self.init(dynamicProvider: {
        switch $0.userInterfaceStyle {
        case .light, .unspecified:
          return UIColor(hex: lightHex)
        case .dark:
          return UIColor(hex: darkHex)
        @unknown default:
          assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
          return UIColor(hex: lightHex)
        }
      })
    } else {
      self.init(hex: lightHex)
    }
  }
}
