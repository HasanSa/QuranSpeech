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
  
  lazy var speechManager: QSSpeechManager = {
    return QSSpeechManager(type: .siri)
  }()
  
  public var isRecording: Bool {
    return speechManager.isRecording
  }
  
  public var resultsHandler: QSQuranEngineResultsHandler?
  
//  public var speechRecognitionAuthorized: Bool {
//    return speechManager.status
//  }
}

// MARK:- Private
extension QSQuranEngine {
  
  func generateRandomResource() -> QSResource<QSAyah>? {
    
    let resource = HerokuRequest()
    resource.method = .random
    let request = URLRequest(url: resource.targetURL)
    let resourceRequest = QSResource<QSAyah>(request: request) { json in
      
      guard let verse = json as? JSONDictionary else {
        return nil
      }
      return QSAyah(heroku: verse)
    }
    
    return resourceRequest
  }
  
  func generateResource(parameter: String? = nil) -> QSResource<[QSAyah]>? {
    
    let resource = AlfanosRequest(parameter: parameter)
    let request = URLRequest(url: resource.targetURL)
    let resourceRequest = QSResource<[QSAyah]>(request: request) { json in
      
      guard let dict = json as? JSONDictionary else {
        return nil
      }
      
      guard let data = dict["search"] as? JSONDictionary else {
        return nil
      }

      guard let verses = data["ayas"] as? JSONDictionary else {
        return nil
      }
      
      return verses.keys.flatMap{ key in
        if let ayahJSON = verses[key] as? JSONDictionary {
          return QSAyah(alfanos: ayahJSON)
        }
        return nil
      }
      
//      return verses.flatMap{ QSAyah(json: $0) }
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
      guard !speechText.isEmpty else {
        return
      }
      
      guard let completion = completion else {
        return
      }
      
      guard let resourceRequest = generateResource(parameter: speechText) else {
        return
      }
      QSQueue.main.async {
        self.resultsHandler?(QSResult<[QSAyah]>.success([]))
      }
      
      QSQueue.background.async {
        QSNetworkService.excute(resource: resourceRequest) { ayahs in
          QSQueue.main.async {
            completion(QSResult<[QSAyah]>.success(ayahs ?? []))
          }
        }
      }
    }
  }
  
  func random(completion: QSQuranEngineResultsHandler?) {
    
    guard let completion = completion else {
      return
    }
    
    guard let resourceRequest = generateRandomResource() else {
      return
    }
    
    QSQueue.background.async {
      QSNetworkService.excute(resource: resourceRequest) { verse in
        QSQueue.main.async {
          let verses = (verse != nil) ? [verse!] : []
          completion(QSResult<[QSAyah]>.success(verses))
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
          if let data = data as? Data {
            guard let resourceRequest = self?.generateSpeechText(data: data) else {
              return
            }
            QSQueue.background.async {
              QSNetworkService.excute(resource: resourceRequest) { result in
                QSQueue.main.async {
                  completion(QSResult<String>.success(result ?? ""), nil)
                  // self?.search(for: result, completion: self?.resultsHandler)
                }
              }
            }
          }
          if let result = data as? String {
            QSQueue.main.async {
              completion(QSResult<String>.success(result), nil)
              self?.search(for: result, completion: self?.resultsHandler)
              
            }
          }
        case .failure(_): break
        }
      }
      if let metersResponse = metersResponse {
        completion(nil, QSResult<Float>.success(metersResponse.value!.first ?? 0.0))
      }
    }
  }
  
  public func stopRecording() {
    speechManager.stopRecording()
  }
  
  
  public func fetchVerses(for text: String?, completion: QSQuranEngineResultsHandler?) {
    self.search(for: text, completion: completion)
  }
  
  public func randomVerse(completion: QSQuranEngineResultsHandler?) {
    self.random(completion: completion)
  }
  
}
