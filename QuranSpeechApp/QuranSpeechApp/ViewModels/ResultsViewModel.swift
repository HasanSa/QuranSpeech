//
//  ResultsViewModel.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

protocol ResultsViewModelCoordinatorDelegate: class {
  func didEnd()
}

class ResultsViewModel: AppViewModel {
  weak var coordinatorDelegate: ResultsViewModelCoordinatorDelegate?
  private var text: String = ""
  var results: Box<[QSAyah]> = Box([])
  
  init(text: String) {
    super.init()
    self.text = text
    
    QSQuranEngine.default.fetchVerses(for: text) { [weak self] resultsResponse in
      guard let resultsResponse = resultsResponse else {
        return
      }
      switch resultsResponse {
      case .success(let results):
        print(results.count)
        self?.results.value = results
      case .failure(_): break
      }
    }
  }
  
  func displaySearch() {
    coordinatorDelegate?.didEnd()
  }
}
