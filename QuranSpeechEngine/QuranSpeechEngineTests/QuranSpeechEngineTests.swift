//
//  QSQuranEngine.swift
//  QuranSpeechEngine
//
//  Created by Hasan Sa on 29/04/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import XCTest
@testable import QuranSpeechEngine

class QSQuranTest: XCTestCase {
  
  func test_SuraName() {
    let alFatiha = QSQuran.nameForSura(1)
     XCTAssertTrue(alFatiha == "الفاتحة")
  }
}

class QSAyahNumbeTest: XCTestCase {
  
  func test_QSAyahNumber_JSON_initialize() {
    let searchAyahResponse = ["results":
      [["id":295,
        "verse_number":2,
        "chapter_id":3,
        "verse_key":"3:2",
        "text_madani":"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ"]
      ]
    ]
    let expextedAyah = QSAyah(sura: 3, ayah: 2)
    let jsonAyah = QSAyah(json: searchAyahResponse["results"]![0])
    XCTAssertTrue(expextedAyah == jsonAyah)
  }
  
}
