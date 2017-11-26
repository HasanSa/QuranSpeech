//
//  TodayCoordinator.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 22/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

protocol TodayCoordinatorDelegate: class {
  func todayCoordinatorDispalySearch(coordinator: TodayCoordinator)
}

class TodayCoordinator: Coordinator {
  var window: UIWindow
  weak var delegate: TodayCoordinatorDelegate?
  var viewController: TodayViewController?
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func start() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    viewController = storyboard.instantiateViewController(withIdentifier: "Today") as? TodayViewController
    guard let viewController = viewController else { return }
    
    let viewModel = TodayViewModel()
    viewModel.coordinatorDelegate = self
    viewController.viewModel = viewModel
    self.updateRoot(with: viewController)
  }
}

extension TodayCoordinator: TodayViewModelCoordinatorDelegate {
  func didEnd() {
    delegate?.todayCoordinatorDispalySearch(coordinator: self)
  }
}
