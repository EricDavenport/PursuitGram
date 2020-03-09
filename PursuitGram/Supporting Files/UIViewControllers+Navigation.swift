//
//  UIViewControllers+Navigation.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

extension UIViewController {
  private static func resetWindow(with rootviewController: UIViewController) {
    guard let scene = UIApplication.shared.connectedScenes.first,
      let sceneDelegate = scene.delegate as? SceneDelegate,
      let window = sceneDelegate.window else {
        fatalError("Could not reset window rootViewController")
    }
    window.rootViewController = rootviewController
  }
  
  public static func showViewController(storyboardName: String, viewControllerId: String) {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
    resetWindow(with: newVC)
  }
  
}
