//
//  SiriSpeechManager.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 10/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import Speech

class SiriSpeechManager {
  static let `default` = SiriSpeechManager()
  fileprivate let audioEngine = AVAudioEngine()
  fileprivate let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ar"))
  fileprivate let request = SFSpeechAudioBufferRecognitionRequest()
  fileprivate var recognitionTask: SFSpeechRecognitionTask?
  var resultsUpdateHandler: QSSpeechResultsUpdateHandler = { _, _ in }
}

// MARK: PRIVATE
extension SiriSpeechManager {
  func requestAuthorization(completion: @escaping ((Bool) -> Void)) {
    SFSpeechRecognizer.requestAuthorization { status in
      OperationQueue.main.addOperation {
        completion(status == .authorized)
      }
    }
  }
  
  func setupAudioEngine() {
   let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)
    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
      self.request.append(buffer)
      let bufferAudioChannelData = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
      self.resultsUpdateHandler(nil, QSResult<[Float]>.success(bufferAudioChannelData))
    }
  }
  
  func prepareAudioEngine() {
    audioEngine.prepare()
    
    do {
      try audioEngine.start()
    } catch {
      return print(error)
    }
  }
  
  func analyzeAudio() {
    recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
      
      if let result = result {
        self.resultsUpdateHandler(QSResult<Any>.success(result.bestTranscription.formattedString), nil)
      } else if let error = error {
        self.resultsUpdateHandler(QSResult<Any>.failure(error), nil)
      }
    })
  }
  
  func stopAudioEngine() {
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0)
    recognitionTask?.cancel()
  }
}

extension SiriSpeechManager: QSSpeechProviderProtocol {
  var isRecording: Bool {
    return audioEngine.isRunning
  }
  
  func requestPermission(completion: @escaping ((Bool) -> Void)) {
     requestAuthorization(completion: completion)
  }
  
  func startRecording(completion: @escaping QSSpeechResultsUpdateHandler) {
    self.resultsUpdateHandler = completion
    // Setup audio engine and speech recognizer
    setupAudioEngine()
    
    // Prepare and start recording
    prepareAudioEngine()
    
    // Analyze the speech
    analyzeAudio()
  }
  
  func stopRecording() {
    // stop recording
    stopAudioEngine()
  }
}
