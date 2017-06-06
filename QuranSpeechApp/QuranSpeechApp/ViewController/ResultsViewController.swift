//
//  ResutlsViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 06/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
let kCellHeight: CGFloat = 120.0

class ResultsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
    }
  }
  
  var viewModel: ResultsTableViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = ResultsTableViewModel(callback: { [weak self] state in
      if !state.results.isEmpty {
        self?.tableView.reloadData()
      }
    })
    
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = kCellHeight
    self.tableView.dataSource = viewModel
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension ResultsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return kCellHeight
  }
  
}
