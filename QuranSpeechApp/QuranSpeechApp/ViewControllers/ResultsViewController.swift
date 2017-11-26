//
//  ResultsViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
//import Material
//import Graph

class ResultsViewController: AppViewController {
  
//  internal var tableView: VerseTableView!
  
  @IBOutlet weak var resultsContainer: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Feed.
    prepareTableView()
    
//    if let viewModel = self.viewModel as? ResultsViewModel {
//      viewModel.results.bind { [weak self] (data) in
//        self.tableView.data = data
//      }
//    }
  }
  
  @IBAction func searchTapHandler() {
    if let viewModel = self.viewModel as? ResultsViewModel {
      viewModel.displaySearch()
    }
  }
}

extension ResultsViewController {
  internal func prepareTableView() {
    
  }
}
