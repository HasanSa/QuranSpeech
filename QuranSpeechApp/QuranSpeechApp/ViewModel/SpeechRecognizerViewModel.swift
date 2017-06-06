//
//  ViewModel.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 30/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import QuranSpeechEngine

struct SpeechRecognizerViewModelState {
  var speechLabelText: String?
  var metersValue: Float = 0.0
}

class SpeechRecognizerViewModel: NSObject {
  
  var isRecoding: Bool {
    return QSQuranEngine.default.isRecording
  }
  
  typealias ViewModelCallback = ((SpeechRecognizerViewModelState) -> Void)
  
  let quranEngine = QSQuranEngine.default
    
  
  var state: SpeechRecognizerViewModelState = SpeechRecognizerViewModelState(speechLabelText: nil, metersValue: 0.0) {
    didSet {
      callback(state)
    }
  }
  
  fileprivate var callback: ViewModelCallback = { state in }
  
  func startSpeechRecorgnition() {
    
    self.state.speechLabelText?.removeAll()
    quranEngine.startRecording { (speechResponse, metersResponse) in
      if let speechResponse = speechResponse {
        switch speechResponse {
        case .success(let text):
          self.state.speechLabelText = text
        case .failure(_): break
        }
      }
      if let metersResponse = metersResponse {
        switch metersResponse {
        case .success(let value):
          self.state.metersValue = value
        case .failure(_): break
        }
      }
    }
  }
  
  func stopSpeechRecorgnition() {
    quranEngine.stopRecording()
  }
  
  init(callback: @escaping ViewModelCallback) {
    super.init()
    self.callback = callback
  }
}
