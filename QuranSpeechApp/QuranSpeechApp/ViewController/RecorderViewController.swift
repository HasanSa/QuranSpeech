//
//  RecorderViewController.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 06/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView
import QuranSpeechEngine

protocol RecorderViewControllerDelegate: class {
  func shouldUpdateContainerView()
}

class RecorderViewController: UIViewController {
  
  weak var delegate: RecorderViewControllerDelegate?
  
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var waveView: SwiftSiriWaveformView!
  
  fileprivate var viewModel: SpeechRecognizerViewModel?
  fileprivate var change:CGFloat = 0.001
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.waveView.density = 1.0
    
    
    viewModel = SpeechRecognizerViewModel(callback: { [weak self] state in
      guard let this = self else {
        return
      }
      
      this.textLabel.text = state.speechLabelText
      
      guard this.viewModel!.isRecoding else {
        this.waveView.amplitude = 0
        return
      }
      
      if this.waveView.amplitude <= this.waveView.idleAmplitude || this.waveView.amplitude > 1.0 {
        this.change *= -1.0
      }
      
      this.waveView.amplitude += (CGFloat(state.metersValue) * this.change)
    })
  }
  
}

//MARK:
fileprivate extension RecorderViewController {
  fileprivate func startRecoringSession() {
    viewModel?.startSpeechRecorgnition()
    
    UIView.animate(withDuration: 0.5) {
      self.textLabel.text = ""
      self.waveView.alpha = 1
    }
    
  }
  
  fileprivate func stopRecoringSession() {
    viewModel?.stopSpeechRecorgnition()
    
    UIView.animate(withDuration: 0.5) {
      self.waveView.alpha = 0
    }
  }
  
  func toggleRecorderStatus() {
    QSQueue.main.async {
      if self.viewModel!.isRecoding {
        self.stopRecoringSession()
      } else {
        self.startRecoringSession()
      }
    }
  }
  
}

// MARK: IBActions
fileprivate extension RecorderViewController {
  
  @IBAction func startRecordingSession() {
    self.toggleRecorderStatus()
    self.delegate?.shouldUpdateContainerView()
  }
  
}
