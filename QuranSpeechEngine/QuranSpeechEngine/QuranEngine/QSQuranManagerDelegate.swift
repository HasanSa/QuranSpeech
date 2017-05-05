//
//  QSQuranEngineDelegate.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 29/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation

public protocol QSQuranEngineDelegate: class {
  
  func manager(speechRecognitionResponse response: QSResult<String>)
  func manager(bufferRecognitionResponse response: QSResult<[Float]>)
  func manager(fetcherResponse response: QSResult<[QSAyah]>)
}
