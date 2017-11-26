//
//  SearchViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 23/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

class SearchViewController: AppViewController {
  
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var speakNowButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let viewModel = self.viewModel as? SearchViewModel {
      viewModel.term.bind{ [unowned self] text in
        self.textLabel.text = text
      }
    }
  }
  
  @IBAction func todayTapHandler() {
    if let viewModel = self.viewModel as? SearchViewModel {
      viewModel.displayToday()
    }
  }
  
  @IBAction func resultsTapHandler() {
    if let viewModel = self.viewModel as? SearchViewModel {
      viewModel.displayResults()
    }
  }
  
  @IBAction func speakNowTapHandler() {
    if let viewModel = self.viewModel as? SearchViewModel {
      viewModel.startRecording()
    }
  }
}
