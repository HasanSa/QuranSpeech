//
//  Coordinator.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 22/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

protocol Coordinator: class {
  var window: UIWindow { get set }
}

extension Coordinator {
  func start(parameter: Any? = nil) {
  
  }
  
  func updateRoot(with viewController: AppViewController) {
    if let snapShot = window.snapshotView(afterScreenUpdates: true) {
      window.rootViewController = viewController
      viewController.view.addSubview(snapShot)
      UIView.animate(withDuration: 0.5, animations: {
        snapShot.layer.opacity = 0
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
      }) { (finished) in
        snapShot.removeFromSuperview()
      }
    }
  }
}
