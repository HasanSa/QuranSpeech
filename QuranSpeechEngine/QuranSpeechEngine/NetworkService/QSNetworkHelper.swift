//
//  QSNetworkConfig.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 29/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation

enum QSRequestMethod {
  case search
  case analysis
}

protocol QSRequest {
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String { get }
  
  var request: NSMutableURLRequest? { get }
  
}

struct SpeechRequest: QSRequest {
  var request: NSMutableURLRequest?
  
  var method: QSRequestMethod? = .search
  
  var path: String {
    return "https://api.alquran.cloud/search/"
  }
  
  var parameter: String?
  
  var targetURL: URL {
    var urlPath = path
    urlPath += parameter ?? ""
    urlPath += "/all/quran-simple-clean"
    return URL(string: urlPath)!
  }
  
  init(parameter: String) {
    self.parameter = parameter
  }
}

struct VoiceRecognitionRequest: QSRequest {
  var request: NSMutableURLRequest? {
    if let url = URL(string: path) {
      do {
        let configRequest: [String : Any] = ["encoding": "LINEAR16",
                                             "sampleRateHertz": (kSampleRate),
                                             "languageCode": "ar",
                                             "maxAlternatives": 30]
        
        let audioRequest: [String : Any]  = ["content": audioData.base64EncodedString()]
        
        let requestDictionary = ["config":configRequest,
                                 "audio":audioRequest]
        
        let requestData: Data = try JSONSerialization.data(withJSONObject: requestDictionary, options: [])
        let request = NSMutableURLRequest(url: url)
        if let identifier = Bundle.main.bundleIdentifier {
          request.addValue(identifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        }
        let contentType: String = "application/json"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        request.httpMethod = "POST"
        return request
      } catch (_) {}
    }
    return nil
  }
  
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String {
    return "https://speech.googleapis.com/v1/speech:recognize?key=\(API_KEY)"
  }
  
  var audioData: Data
  let API_KEY = "AIzaSyAE6Li7HGfc7eF93_sGb1uPsVPkEJC4XQI"
  
  init(audioData: Data) {
    self.audioData = audioData
  }
}

// MARK: - Helpers
extension String {
  var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8Encoded: Data {
    return cast(self.data(using: .utf8))
  }
}

func cast<S, T>(_ object: S, function: StaticString = #function) -> T {
  guard let value = object as? T else {
    fatalError("\(function): Couldn't cast object of type '\(type(of: (object)))' to '\(T.self)' where object value is '\(object)'")
  }
  return value
}
