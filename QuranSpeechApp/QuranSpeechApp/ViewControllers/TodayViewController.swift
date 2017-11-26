//
//  TodayViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

class TodayViewController: AppViewController {
  
  @IBOutlet weak var randomVerseTextLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let viewModel = self.viewModel as? TodayViewModel {
      viewModel.randomVerse.bind { [unowned self] text in
        self.randomVerseTextLabel.text = text
      }
    }
    
  }
  
  @IBAction func searchTapHandler() {
    if let viewModel = self.viewModel as? TodayViewModel {
      viewModel.displaySearch()
    }
  }
}
