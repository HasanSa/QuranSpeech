//
//  QSQuranEngine.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 28/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation

final public class QSQuranEngine {
  
  public static let `default` = QSQuranEngine()
  
  public weak var delegate: QSQuranEngineDelegate?
  
  public var speechRecognitionAuthorized: Bool {
    return speechManager.status
  }
  
  lazy var speechManager: QSSpeechManager =  {
    let speechMgr = QSSpeechManager.default
    speechMgr.delegate = self
    return speechMgr
  }()
}

// MARK:- Private
extension QSQuranEngine {
  
  func excute(_ resourceRequest: QSResource<[QSAyah]>) {
    QSNetworkService.excute(resource: resourceRequest) { ayahs in
      let response = QSResult<[QSAyah]>.success(ayahs ?? [])
      QSQueue.main.async {
        self.delegate?.manager(fetcherResponse: response)
      }
    }
  }
  
  func generatedSpeechResource(speech: String) -> QSResource<[QSAyah]>? {
    
    let speechRequest = SpeechRequest(parameter: speech.urlEscaped)
    
    let resourceRequest = QSResource<[QSAyah]>(url: speechRequest.targetURL) { json in
      
      guard let dict = json as? JSONDictionary else {
        return nil
      }
      
      guard let ayahs = dict["results"] as? [JSONDictionary] else {
        return nil
      }
      
      return ayahs.flatMap{ ayaJSON in
        return QSAyah(json: ayaJSON)
      }
    }
    
    return resourceRequest
  }
}

// MARK:- Interface
public extension QSQuranEngine {
  
  public func requestSpeechAuthorization(completion: ((Bool) -> Void)?) {
    speechManager.requestPermission { (authorized) in
      completion?(authorized)
    }
  }
  
  public func startRecording() {
    
    guard speechRecognitionAuthorized else {
      print("make sure you called requestAuthorization first, make sure that you added \n 'Privacy - Speech Recognition Usage Description' and 'Privacy - Microphone Usage Description' keys at info.plist")
      return
    }
    speechManager.startRecording()
  }
  
  public func stopRecording() {
    speechManager.stopRecording()
  }
  
  public func search(for text: String?) {
    if let speechText = text {
      guard !speechText.characters.isEmpty else {
        return
      }
      
      guard let generatedResource = generatedSpeechResource(speech: speechText) else {
        return
      }
      QSQueue.background.async { [weak self] in
        self?.excute(generatedResource)
      }
    }
  }
  
}

// MARK:- QSSpeechManagerDelegate
extension QSQuranEngine: QSSpeechManagerDelegate {
  
  func manager(speechRecognitionResponse response: QSResult<String>) {
    QSQueue.main.async {
      self.delegate?.manager(speechRecognitionResponse: response)
    }
  }
  
  func manager(bufferRecognitionResponse response: QSResult<[Float]>) {
    QSQueue.main.async {
      self.delegate?.manager(bufferRecognitionResponse: response)
    }
  }
  
}
