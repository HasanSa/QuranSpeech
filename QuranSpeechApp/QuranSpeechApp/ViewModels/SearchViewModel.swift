//
//  SearchViewModel.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

protocol SearchViewModelCoordinatorDelegate: class {
  func discoverResults(for text: String)
  func didEnd()
}

class SearchViewModel: AppViewModel {
  weak var coordinatorDelegate: SearchViewModelCoordinatorDelegate?
  var term: Box<String> = Box("")
  var meters: Box<Float> = Box(0.0)
  
  lazy var manager = QSQuranEngine.default
  
  override init() {
    super.init()
    self.manager.requestSpeechAuthorization { _ in }
  }
  
  func displayToday() {
    coordinatorDelegate?.didEnd()
  }
  
  func displayResults() {
    coordinatorDelegate?.discoverResults(for: term.value)
  }
  
  func startRecording() {
    guard !manager.isRecording else {
      manager.stopRecording()
      return
    }
    manager.startRecording { [weak self] (speechResponse, metersResponse) in
      if let speechResponse = speechResponse {
        switch speechResponse {
        case .success(let text):
          self?.term.value = text
        case .failure(_): break
        }
      }
      if let metersResponse = metersResponse {
        switch metersResponse {
        case .success(let value):
          self?.meters.value = value
        case .failure(_): break
        }
      }
    }
  }
}
