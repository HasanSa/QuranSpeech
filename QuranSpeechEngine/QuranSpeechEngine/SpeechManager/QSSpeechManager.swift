//
//  QSSpeechManager.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 28/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation


protocol QSSpeechProviderProtocol {
  func requestPermission(completion: @escaping ((Bool) -> Void))
  func startRecording(completion: @escaping QSSpeechResultsUpdateHandler)
  func stopRecording()
  var isRecording: Bool { get }
  var resultsUpdateHandler: QSSpeechResultsUpdateHandler { set get }
}

enum SpeechProviderType {
  case audioRecorder
  case siri
}

extension SpeechProviderType {
  func speechProvider() -> QSSpeechProviderProtocol {
    switch self {
    case .audioRecorder:
      return AudioRecorderManager.default
    case .siri:
      return SiriSpeechManager.default
    }
  }
}

typealias QSSpeechResultsUpdateHandler = ((QSResult<Any>?, QSResult<[Float]>?) -> ())

class QSSpeechManager {
  let speechProvider: QSSpeechProviderProtocol?
  
  init(type: SpeechProviderType) {
    self.speechProvider = type.speechProvider()
  }
}

// MARK - API
extension QSSpeechManager {
  
  var isRecording: Bool {
    return speechProvider!.isRecording
  }
  
  func requestPermission(completion: @escaping ((Bool) -> Void)) {
    speechProvider?.requestPermission(completion: completion)
  }
  
  func startRecording(completion: @escaping QSSpeechResultsUpdateHandler) {
    speechProvider?.startRecording(completion: completion)
  }
  
  func stopRecording() {
   speechProvider?.stopRecording()
  }
}

