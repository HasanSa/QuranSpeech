//
//  ViewModel.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 30/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import QuranSpeechEngine

struct State {
  var result: [QSAyah] = []
  var speechLabelText: String?
  var arrayFloatValues: [Float] = []
}

class ViewModel {
  
  lazy var quranEngine: QSQuranEngine = {
    let qEngine = QSQuranEngine.default
    qEngine.delegate = self
    return qEngine
  }()
  
  var state: State = State(result: [], speechLabelText: nil, arrayFloatValues: []) {
    didSet {
      callback(state)
    }
  }
  var callback: ((State) -> Void)
  
  init(callback: @escaping (State) -> Void) {
    self.callback = callback
    self.callback(state)
  }
  
  func startSpeechRecorgnition() {
    
    guard quranEngine.speechRecognitionAuthorized else {
      quranEngine.requestSpeechAuthorization { _ in }
      return
    }
    
    self.state.speechLabelText?.removeAll()
    quranEngine.startRecording()
  }
  
  func stopSpeechRecorgnition() {
    quranEngine.stopRecording()
  }
  
}

// MARK: - QSQuranEngineDelegate
extension ViewModel: QSQuranEngineDelegate {
  func manager(speechRecognitionResponse response: QSResult<String>) {
    switch response {
    case .success(let text):
      self.state.speechLabelText = text
    case .failure(_): break
    }
    self.callback(state)
  }
  
  func manager(bufferRecognitionResponse response: QSResult<[Float]>) {
    switch response {
    case .success(let result):
      self.state.arrayFloatValues = result
    case .failure(_): break
    }
    self.callback(state)
  }
  
  func manager(fetcherResponse response: QSResult<[QSAyah]>) {
    switch response {
    case .success(let result):
      self.state.result = result
    case .failure(_): break
    }
    self.callback(state)
  }
}
