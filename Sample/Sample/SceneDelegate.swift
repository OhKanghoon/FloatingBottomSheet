//
//  SceneDelegate.swift
//  Sample
//
//  Created by Kanghoon Oh on 2023/10/01.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = UINavigationController(rootViewController: SampleViewController())
    window?.makeKeyAndVisible()
  }
}
