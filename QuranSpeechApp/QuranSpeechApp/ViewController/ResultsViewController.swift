//
//  ResutlsViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 06/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

private let reuseIdentifier = "Cell"
let kCellDefaultHeight: CGFloat = 100.0
let kCellMaxHeight: CGFloat = 500.0

class ResultsViewController: UIViewController {
  
  @IBOutlet weak var resultsButton: UIButton!
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
    }
  }
  
  var viewModel: ResultsTableViewModel?
  
  weak var delegate: ResizableDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = ResultsTableViewModel(callback: { [unowned self] state in
      self.resultsButton.setTitle("Results (\(self.viewModel!.state.results.count))", for: .normal)
        self.tableView.reloadData()
    })
    
    tableView.tableFooterView = UIView() // Removes empty cell separators
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.dataSource = viewModel
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func resultsButtonTapped() {
    self.delegate?.shouldUpdateContainerView()
  }
  
}

extension ResultsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var content = viewModel!.state.results[indexPath.row]
    content.switchExpandeState()
    viewModel!.state.results[indexPath.row] = content
    tableView.beginUpdates()
    tableView.reloadRows(at: [indexPath], with: .none)
    tableView.endUpdates()
  }
  
}
