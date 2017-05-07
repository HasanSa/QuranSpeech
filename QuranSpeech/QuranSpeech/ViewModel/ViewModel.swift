//
//  ViewModel.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 30/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import Foundation
import UIKit
import QuranSpeechEngine

struct State {
  var result: [QSAyah] = []
  var speechLabelText: String?
  var arrayFloatValues: [Float] = []
}

class ViewModel: NSObject {
  
  static let `default` = ViewModel()
  
  typealias ViewModelCallback = ((State) -> Void)
  
  lazy var quranEngine: QSQuranEngine = {
    let qEngine = QSQuranEngine.default
    qEngine.delegate = self
    return qEngine
  }()
  
  var state: State = State(result: [], speechLabelText: nil, arrayFloatValues: []) {
    didSet {
      callbacks.forEach { $0(state) }
    }
  }
  
  fileprivate var callbacks: [ViewModelCallback] = []
  
  func register(callback: @escaping ViewModelCallback) {
    self.callbacks.append(callback)
  }
  
  func startSpeechRecorgnition() {
    
    guard quranEngine.speechRecognitionAuthorized else {
      quranEngine.requestSpeechAuthorization { _ in }
      return
    }
    
    self.state.speechLabelText?.removeAll()
    quranEngine.startRecording()
  }
  
  func stopSpeechRecorgnition() {
    quranEngine.stopRecording()
  }
  
  
  func excuteSearch(with text: String?) {
    quranEngine.search(for: text)
  }
  
}

extension ViewModel: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.result.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AyahTableViewCell
    cell.config(state.result[indexPath.row])
    return cell
  }
}

// MARK: - QSQuranEngineDelegate
extension ViewModel: QSQuranEngineDelegate {
  func manager(speechRecognitionResponse response: QSResult<String>) {
    switch response {
    case .success(let text):
      self.state.speechLabelText = text
    case .failure(_): break
    }
  }
  
  func manager(bufferRecognitionResponse response: QSResult<[Float]>) {
    switch response {
    case .success(let result):
      self.state.arrayFloatValues = result
    case .failure(_): break
    }
  }
  
  func manager(fetcherResponse response: QSResult<[QSAyah]>) {
    switch response {
    case .success(let result):
      self.state.result = result
    case .failure(_): break
    }
  }
}
