//
//  ResultsCoordinator.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

protocol ResultsCoordinatorDelegate: class {
  func resultsCoordinatorDidFinish(coordinator: ResultsCoordinator)
}

class ResultsCoordinator: Coordinator {
  var window: UIWindow
  weak var delegate: ResultsCoordinatorDelegate?
  var viewController: ResultsViewController?
  
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func start(parameter: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    viewController = storyboard.instantiateViewController(withIdentifier: "Results") as? ResultsViewController
    guard let viewController = self.viewController else { return }
    
    let viewModel = ResultsViewModel(text: parameter)
    viewModel.coordinatorDelegate = self
    viewController.viewModel = viewModel
    self.updateRoot(with: viewController)
  }
}

extension ResultsCoordinator: ResultsViewModelCoordinatorDelegate {
  func didEnd() {
    delegate?.resultsCoordinatorDidFinish(coordinator: self)
  }
}
