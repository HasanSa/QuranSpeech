//
//  QSNetworkService.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 28/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation

typealias JSONDictionary = [AnyHashable:Any]

struct QSResource<T> {
  var request: URLRequest
  let parse: (Data) -> T?
}

extension QSResource {
  init(request: URLRequest, parseJSON: @escaping (Any) -> T?) {
    self.request = request
    self.parse = { data in
      let json = try? JSONSerialization.jsonObject(with: data, options: [])
      return json.flatMap(parseJSON)
    }
  }
}

struct QSNetworkService {
  static func excute<T>(resource: QSResource<T>, callback: @escaping (T?) -> ()) {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // make the request
    let task = session.dataTask(with: resource.request) { (data, response, error) in
      let result = data.flatMap(resource.parse)
      callback(result)
      }
      task.resume()
  }
}
