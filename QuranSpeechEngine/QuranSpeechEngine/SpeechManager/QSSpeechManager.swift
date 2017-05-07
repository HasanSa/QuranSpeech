//
//  QSSpeechManager.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 28/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import Speech

protocol QSSpeechManagerDelegate: class {
  func manager(speechRecognitionResponse response: QSResult<String>)
  func manager(bufferRecognitionResponse response: QSResult<[Float]>)
}

class QSSpeechManager {
  
  static let `default` = QSSpeechManager()
  fileprivate let audioEngine = AVAudioEngine()
  fileprivate let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ar"))
  fileprivate let request = SFSpeechAudioBufferRecognitionRequest()
  fileprivate var recognitionTask: SFSpeechRecognitionTask?
  fileprivate var isRecording = false
  var status: Bool {
    return SFSpeechRecognizer.authorizationStatus() == .authorized
  }
  weak var delegate: QSSpeechManagerDelegate?
}

// MARK - PRIVATE
extension QSSpeechManager {
  
  func requestAuthorization(completion: @escaping ((Bool) -> Void)) {
    SFSpeechRecognizer.requestAuthorization { status in
      OperationQueue.main.addOperation {
        completion(status == .authorized)
      }
    }
  }
  
  func setupAudioEngine() {
    guard let node = audioEngine.inputNode else { return }
    let recordingFormat = node.outputFormat(forBus: 0)
    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
      self.request.append(buffer)
      let bufferAudioChannelData = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
      self.delegate?.manager(bufferRecognitionResponse: QSResult<[Float]>.success(bufferAudioChannelData))
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
        self.delegate?.manager(speechRecognitionResponse:
          QSResult<String>.success(result.bestTranscription.formattedString))
        
      } else if let error = error {
        self.delegate?.manager(speechRecognitionResponse:
          QSResult<String>.failure(error))
      }
    })
  }
  
  func stopAudioEngine() {
    audioEngine.stop()
    if let node = audioEngine.inputNode {
      node.removeTap(onBus: 0)
    }
    recognitionTask?.cancel()
  }
  
}


// MARK - API
extension QSSpeechManager {
  
  func requestPermission(completion: @escaping ((Bool) -> Void)) {
    requestAuthorization(completion: completion)
  }
  
  func startRecording() {
    guard !isRecording else {
      return
    }
    isRecording = true
    // Setup audio engine and speech recognizer
    setupAudioEngine()
    
    // Prepare and start recording
    prepareAudioEngine()
    
    // Analyze the speech
    analyzeAudio()
  }
  
  func stopRecording() {
    guard isRecording else {
      return
    }
    isRecording = false
    // stop recording
    stopAudioEngine()

  }
}

