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
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
    }
  }
  
  var viewModel: ResultsTableViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = ResultsTableViewModel(callback: { [weak self] state in
        self?.tableView.reloadData()
    })
//    viewModel!.state.results = [
//      QSAyah(sura: 1, ayah: 1),
//      QSAyah(sura: 1, ayah: 2),
//      QSAyah(sura: 1, ayah: 3),
//      QSAyah(sura: 1, ayah: 4),
//      QSAyah(sura: 1, ayah: 5),
//      QSAyah(sura: 1, ayah: 6),
//      QSAyah(sura: 1, ayah: 7)
//    ]
    
    tableView.tableFooterView = UIView() // Removes empty cell separators
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.dataSource = viewModel
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
