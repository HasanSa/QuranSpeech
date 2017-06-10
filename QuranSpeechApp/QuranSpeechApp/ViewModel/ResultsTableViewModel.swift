//
//  ResultsTableViewModel.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 05/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import UIKit
import QuranSpeechEngine

struct ResultsTableViewModelState {
  var results: [QSAyah] = []
}

class ResultsTableViewModel: NSObject {
  
  typealias ViewModelCallback = ((ResultsTableViewModelState) -> Void)
  
  var state: ResultsTableViewModelState = ResultsTableViewModelState(results: []) {
    didSet {
      callback(state)
    }
  }
  
  fileprivate var callback: ViewModelCallback = { state in }
  
  init(callback: @escaping ViewModelCallback) {
    super.init()
    self.callback = callback
    
    QSQuranEngine.default.resultsHandler = {[weak self] resultsResponse in
      guard let resultsResponse = resultsResponse else {
        return
      }
      switch resultsResponse {
      case .success(let results):
        self?.state.results = results
      case .failure(_): break
      }
    }
  }
}

extension ResultsTableViewModel: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.results.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView .dequeueReusableCell(withIdentifier: String(describing: ExpandingTableViewCell.self), for: indexPath) as! ExpandingTableViewCell
    cell.set(content: state.results[indexPath.row])
    return cell
  }
}
