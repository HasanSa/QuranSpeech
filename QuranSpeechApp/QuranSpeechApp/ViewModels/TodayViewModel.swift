//
//  TodayViewModel.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

protocol TodayViewModelCoordinatorDelegate: class {
  func didEnd()
}

class TodayViewModel: AppViewModel {
  weak var coordinatorDelegate: TodayViewModelCoordinatorDelegate?
  var randomVerse: Box<String> = Box("")
  
  override init() {
    super.init()
    
    QSQuranEngine.default.randomVerse { [weak self] results in
      if let resultsResponse = results {
        switch resultsResponse {
        case .success(let results):
          if let random = results.first,
            let verse = random.text {
            self?.randomVerse.value = verse
          }
        case .failure(_): break
        }
      }
    }
  }
  
  func displaySearch() {
    self.coordinatorDelegate?.didEnd()
  }
  
}
