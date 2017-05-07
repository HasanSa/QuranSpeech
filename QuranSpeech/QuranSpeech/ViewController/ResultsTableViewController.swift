//
//  ResultsTableViewController.swift
//  QuranSpeech
//
//  Created by Hasan Sa on 06/05/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

private let reuseIdentifier = "Cell"

class ResultsTableViewController: UITableViewController {
  
  let kCellHeight: CGFloat = 120.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    ViewModel.default.register(callback: { [weak self] state in
      self?.tableView.reloadData()
    })
    
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = kCellHeight
    self.tableView.dataSource = ViewModel.default
    self.tableView.delegate = self
  }
  
  func loadData(for text: String?) {
    _ = ViewModel.default.excuteSearch(with: text)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return kCellHeight
  }
}
