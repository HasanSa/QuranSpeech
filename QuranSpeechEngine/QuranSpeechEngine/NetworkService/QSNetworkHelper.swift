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
}

protocol QSRequest {
  /// The target's base `URL`.
  var baseURLPath: String { get }
  
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String { get }
  
  var targetURL: URL { get }
  
  var method: QSRequestMethod? { set get }
  
}

class SpeechRequest: QSRequest {
  var baseURLPath: String {
    return "https://quran.com/api/api/v3/"
  }
  
  var method: QSRequestMethod? = .search
  
  var path: String {
    guard let method = method else {
      return ""
    }
    switch method {
    case .search:
      return "search?q="
    }
  }
  
  var parameter: String?
  
  var targetURL: URL {
    var urlPath = baseURLPath + path
    urlPath += parameter ?? ""
    return URL(string: urlPath)!
  }
  
  init(parameter: String) {
    self.parameter = parameter
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
