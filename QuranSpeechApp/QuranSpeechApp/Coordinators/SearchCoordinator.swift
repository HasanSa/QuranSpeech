//
//  SearchCoordinator.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 22/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

protocol SearchCoordinatorDelegate: class {
  func searchCoordinatorDiscoverResults(for text: String, coordinator: SearchCoordinator)
  func searchCoordinatorDidFinish(coordinator: SearchCoordinator)
}

class SearchCoordinator: Coordinator {
  var window: UIWindow
  weak var delegate: SearchCoordinatorDelegate?
  var viewController: SearchViewController?
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func start() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    viewController = storyboard.instantiateViewController(withIdentifier: "Search") as? SearchViewController
    guard let viewController = self.viewController else { return }
    
    let viewModel = SearchViewModel()
    viewModel.coordinatorDelegate = self
    viewController.viewModel = viewModel
    self.updateRoot(with: viewController)
  }
}

extension SearchCoordinator: SearchViewModelCoordinatorDelegate {
  
  func discoverResults(for text: String) {
    delegate?.searchCoordinatorDiscoverResults(for: "الرَّحْمٰنِ الرَّحِيْمِ", coordinator: self)
  }
  
  func didEnd() {
    delegate?.searchCoordinatorDidFinish(coordinator: self)
  }
}
