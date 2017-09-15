//
//  AudioRecorderManager.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 10/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import AVFoundation

let kTimeInterval = 0.01
let kSampleRate = 16000
let MAX_RECORED_INTERVARL: TimeInterval = 120

class AudioRecorderManager {
  static let `default` = AudioRecorderManager()
  fileprivate var audioRecorder: AVAudioRecorder?
  fileprivate var timer: Timer?
  
  fileprivate var soundFileURL: URL {
    return getDocumentsDirectory().appendingPathComponent("audioFileName.caf")
  }
  
  var resultsUpdateHandler: QSSpeechResultsUpdateHandler = { _, _ in }
  
  lazy var recordSettings: [String: Any] = {
    return [
      AVEncoderBitRateKey: 16,
      AVSampleRateKey: kSampleRate,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue    ]
  }()
  
  fileprivate let audioEngine = AVAudioEngine()
  
  init() {
    prepareAudioRecorder()
  }
  
  var isRecording: Bool {
    return timer != nil
  }
}

// MARK - PRIVATE
private extension AudioRecorderManager {
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }
  
  func prepareAudioRecorder() {
    
    // create the session
    let session = AVAudioSession.sharedInstance()
    
    do {
      // configure the session for recording and playback
      try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
      try session.setActive(true)
      // create the audio recording, and assign ourselves as the delegate
      audioRecorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
      audioRecorder?.isMeteringEnabled = true
      if audioRecorder!.prepareToRecord() {
        print("👍")
      }
    } catch let error {
      print("error: \(String(describing: error.localizedDescription))")
    }
  }
  
  func recordAudio() {
    audioRecorder?.record(forDuration: MAX_RECORED_INTERVARL)
    timer = Timer.scheduledTimer(timeInterval: kTimeInterval, target: self, selector: #selector(self.updateVoiceMeteres), userInfo: nil, repeats: true)
  }
  
  func stopAudio() {
    if let audioRecorder = audioRecorder,
      audioRecorder.isRecording {
      audioRecorder.stop()
    }
    
    if let timer = timer, timer.isValid {
      self.timer?.invalidate()
      self.timer = nil
    }
  }
  
  func processAudio() {
    stopAudio()
    do {
      let audioData = try Data(contentsOf: soundFileURL)
      self.resultsUpdateHandler(QSResult<Any>.success(audioData), nil)
    } catch (let error) {
      self.resultsUpdateHandler(QSResult<Any>.failure(error), nil)
    }
  }
  
  func requestAuthorization(completion: @escaping ((Bool) -> Void)) {
    let audioSession = AVAudioSession.sharedInstance()
    audioSession.requestRecordPermission() { allowed in
      DispatchQueue.main.async {
        completion(allowed)
      }
    }
  }
  
}

extension AudioRecorderManager {
  @objc internal func updateVoiceMeteres() {
    if let audioRecorder = audioRecorder, audioRecorder.isRecording {
      audioRecorder.updateMeters()
      let volume: Float = audioRecorder.averagePower(forChannel: 0)
      self.resultsUpdateHandler(nil, QSResult<[Float]>.success([-volume]))
    }
  }
}

extension AudioRecorderManager: QSSpeechProviderProtocol {
  func requestPermission(completion: @escaping ((Bool) -> Void)) {
    requestAuthorization(completion: completion)
  }
  
  func startRecording(completion: @escaping QSSpeechResultsUpdateHandler) {
    self.resultsUpdateHandler = completion
    recordAudio()
  }
  
  func stopRecording() {
    self.processAudio()
  }
}
