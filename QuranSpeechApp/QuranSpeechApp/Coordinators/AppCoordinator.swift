//
//  AppCoordinator.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 22/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit


class AppCoordinator: Coordinator {
  
  var window: UIWindow
  var coordinator: Coordinator?
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func start() {
    presentTodatySeen()
  }
}

extension AppCoordinator: TodayCoordinatorDelegate {
  
  func presentTodatySeen() {
    self.coordinator = TodayCoordinator(window: window)
    if let coordinator = self.coordinator as? TodayCoordinator {
      coordinator.delegate = self
      coordinator.start()
    }
  }
  
  func todayCoordinatorDispalySearch(coordinator: TodayCoordinator) {
    self.coordinator = nil
    presentSearchSeen()
  }
}

extension AppCoordinator: SearchCoordinatorDelegate {
  
  func presentSearchSeen() {
    self.coordinator = SearchCoordinator(window: window)
    if let coordinator = self.coordinator as? SearchCoordinator {
      coordinator.delegate = self
      coordinator.start()
    }
  }
  
  func searchCoordinatorDiscoverResults(for text: String, coordinator: SearchCoordinator) {
    self.coordinator = nil
    presentResultsSeen(with: text)
  }
  
  func searchCoordinatorDidFinish(coordinator: SearchCoordinator) {
    self.coordinator = nil
    presentTodatySeen()
  }
}

extension AppCoordinator: ResultsCoordinatorDelegate {
  
  func presentResultsSeen(with text: String) {
    self.coordinator = ResultsCoordinator(window: window)
    if let coordinator = self.coordinator as? ResultsCoordinator {
      coordinator.delegate = self
      coordinator.start(parameter: text)
    }
  }
  
  func resultsCoordinatorDidFinish(coordinator: ResultsCoordinator) {
    self.coordinator = nil
    presentSearchSeen()
  }
}

