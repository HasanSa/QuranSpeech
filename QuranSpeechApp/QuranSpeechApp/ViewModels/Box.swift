//
//  Box.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 16/09/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation

class Box<T> {
  typealias Listener =  (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
