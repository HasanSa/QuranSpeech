//
//  ViewController.swift
//  QuranSpeech
//
//  Created by Hasan Sa on 29/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import LongPressRecordButton
import QuranSpeechEngine

class ViewController: UIViewController {
  
  @IBOutlet weak var waveView: DrawWaveform!
  @IBOutlet weak var recordButton: LongPressRecordButton! {
    didSet {
      recordButton.delegate = self
    }
  }
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  
  var viewModel: ViewModel!
  
  let duration : Double = 5.0
  var progress : Double = 0.0
  var startTime : CFTimeInterval?
  
  lazy var displayLink : CADisplayLink? = {
    var instance = CADisplayLink(target: self, selector: #selector(animateProgress(_:)))
    instance.isPaused = true
    instance.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    return instance
  }()
  
  var resultsData: [QSAyah] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDisplayLink()
    setupViewModel()
  }
}

// MARK: ViewModel
extension ViewController {
  fileprivate func setupViewModel() {
    viewModel = ViewModel { [unowned self] state in
      self.textLabel.text = state.speechLabelText
      self.resultsData = state.result
      self.waveView.arrayFloatValues = state.arrayFloatValues
    }
  }
}

// MARK: DisplayLink
extension ViewController {
  fileprivate func setupDisplayLink() {
    progress = 0.0
    startTime = CACurrentMediaTime();
    displayLink?.isPaused = true
  }
  
  @objc fileprivate func animateProgress(_ displayLink : CADisplayLink) {
    if (progress > duration) {
      setupDisplayLink()
      return
    }
    
    if let startTime = startTime {
      let elapsedTime = CACurrentMediaTime() - startTime
      self.progress += elapsedTime
      self.startTime = CACurrentMediaTime()
    }
  }
}

// MARK: - LongPressRecordButton Delegate
extension ViewController: LongPressRecordButtonDelegate {
  func longPressRecordButtonDidStartLongPress(_ button: LongPressRecordButton) {
    startTime = CACurrentMediaTime();
    displayLink?.isPaused = false
    textLabel.text = ""
    viewModel.startSpeechRecorgnition()
  }
  
  func longPressRecordButtonDidStopLongPress(_ button: LongPressRecordButton) {
    displayLink?.isPaused = true
    viewModel.stopSpeechRecorgnition()
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultsData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QSCell", for: indexPath)
    let ayah = resultsData[indexPath.row]
    cell.textLabel?.text = ayah.text
    cell.detailTextLabel?.text = ayah.description
    return cell
  }
}

