//
//  QSQuranEngine.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 28/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation

public typealias QSQuranEngineSpeechUpdateHandler = ((QSResult<String>?, QSResult<Float>?) -> ())
public typealias QSQuranEngineResultsHandler = ((QSResult<[QSAyah]>?) -> ())

final public class QSQuranEngine {
  
  public static let `default` = QSQuranEngine()
  
  public var isRecording: Bool {
    return QSSpeechManager.default.isRecording
  }
  
  public var resultsHandler: QSQuranEngineResultsHandler?
  
//  public var speechRecognitionAuthorized: Bool {
//    return speechManager.status
//  }
  
  lazy var speechManager: QSSpeechManager =  {
    let speechMgr = QSSpeechManager.default
    return speechMgr
  }()
}

// MARK:- Private
extension QSQuranEngine {
  
  func generateSpeechResource(speech: String) -> QSResource<[QSAyah]>? {
    
    let speechRequest = SpeechRequest(parameter: speech.urlEscaped)
    let request = URLRequest(url: speechRequest.targetURL)
    let resourceRequest = QSResource<[QSAyah]>(request: request) { json in
      
      guard let dict = json as? JSONDictionary else {
        return nil
      }
      
      guard let data = dict["data"] as? JSONDictionary else {
        return nil
      }
      
      guard let matches = data["matches"] as? [JSONDictionary] else {
        return nil
      }
      
      return matches.flatMap{ ayaJSON in
        return QSAyah(json: ayaJSON)
      }
    }
    
    return resourceRequest
  }
  
  func generateSpeechText(data: Data) -> QSResource<String>? {
    
    let voiceRequest = VoiceRecognitionRequest(audioData: data)
    guard let request = voiceRequest.request as URLRequest? else {
      return nil
    }
    let resourceRequest = QSResource<String>(request: request){ json in
      
      guard let dict = json as? JSONDictionary else {
        return nil
      }
      
      if let results = dict["results"] as? [JSONDictionary],
        let data = results.first,
        let alternatives = data["alternatives"] as? [JSONDictionary],
        let alternative = alternatives.first,
        let transcript = alternative["transcript"] as? String {
        return transcript
      }
    
      return nil
    }
    
    return resourceRequest
  }
  
  func search(for text: String?, completion: QSQuranEngineResultsHandler?) {
    if let speechText = text {
      guard !speechText.characters.isEmpty else {
        return
      }
      
      guard let completion = completion else {
        return
      }
      
      guard let resourceRequest = generateSpeechResource(speech: speechText) else {
        return
      }
      QSQueue.background.async { _ in
        QSNetworkService.excute(resource: resourceRequest) { ayahs in
          QSQueue.main.async {
            completion(QSResult<[QSAyah]>.success(ayahs ?? []))
          }
        }
      }
    }
  }
}

// MARK:- Interface
public extension QSQuranEngine {
  
  public func requestSpeechAuthorization(completion: ((Bool) -> Void)?) {
    speechManager.requestPermission { (authorized) in
      completion?(authorized)
    }
  }
  
  public func startRecording(completion: QSQuranEngineSpeechUpdateHandler?) {
    
    guard let completion = completion else {
      return
    }
    
    speechManager.startRecording { [weak self] (speechResponse, metersResponse) in
      if let speechResponse = speechResponse {
        switch speechResponse {
        case .success(let data):
          guard let resourceRequest = self?.generateSpeechText(data: data as! Data) else {
            return
          }
          QSQueue.background.async {
            QSNetworkService.excute(resource: resourceRequest) { result in
              QSQueue.main.async {
                completion(QSResult<String>.success(result ?? ""), nil)
                self?.search(for: result, completion: self?.resultsHandler)
              }
            }
          }
        case .failure(_): break
        }
      }
      if let metersResponse = metersResponse {
        completion(nil, metersResponse)
      }
    }
    
//    guard speechRecognitionAuthorized else {
//      print("make sure you called requestAuthorization first, make sure that you added \n 'Privacy - Speech Recognition Usage Description' and 'Privacy - Microphone Usage Description' keys at info.plist")
//      return
//    }
  }
  
  public func stopRecording() {
    speechManager.stopRecording()
  }
  
}
