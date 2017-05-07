//
//  SpeechRecognizerViewController.swift
//  QuranSpeech
//
//  Created by Hasan Sa on 06/05/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

protocol SpeechRecognizerViewControllerDelegate {
  func didUpdate(speechText: String?)
}

class SpeechRecognizerViewController: UIViewController {

  @IBOutlet weak var textLabel: UILabel!
  
  @IBOutlet weak var closeButton: UIButton! {
    didSet {
      closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
    }
  }
  
  var delegate: SpeechRecognizerViewControllerDelegate?
  
  override func viewDidLoad() {
    
    ViewModel.default.register(callback: { [weak self] state in
      self?.textLabel.text = state.speechLabelText
      self?.delegate?.didUpdate(speechText: state.speechLabelText)
    })
    
    startRecoringSession()
    QSQueue.main.after(10.0) { [weak self] in
      guard let this = self  else {
        return
      }
      this.closeAction(this)
    }
  }
  
  @IBAction func closeAction(_ sender: AnyObject) {
    self.stopRecoringSession()
    self.dismiss(animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  private func startRecoringSession() {
    textLabel.text = ""
    ViewModel.default.startSpeechRecorgnition()
  }
  
  private func stopRecoringSession() {
    ViewModel.default.stopSpeechRecorgnition()
  }
  
}
