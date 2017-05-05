//
//  QuranUtilities.swift
//  Quran
//
//  Created by Mohamed Afifi on 4/29/16.
//
//  Quran for iOS is a Quran reading application for iOS.
//  Copyright (C) 2017  Quran.com
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import Foundation

extension QSJuz {
  
  static func getJuzs() -> [QSJuz] {
    let juzs = QSQuran.QSQuranJuzsRange.map { QSJuz(juzNumber: $0) }
    return juzs
  }
  
  static func juzFromPage(_ page: Int) -> QSJuz {
    for (index, juzStartPage) in QSQuran.JuzPageStart.enumerated() where page < juzStartPage {
      let previousIndex = index - 1
      let juzNumber = previousIndex + QSQuran.QSQuranJuzsRange.lowerBound
      return QSJuz(juzNumber: juzNumber)
    }
    let juzNumber = QSQuran.QSQuranJuzsRange.upperBound
    return QSJuz(juzNumber: juzNumber)
  }
}

extension QSSura {
  
  static func getSuras() -> [QSSura] {
    
    var suras: [QSSura] = []
    
    for i in 0..<QSQuran.SuraPageStart.count {
      suras.append(QSSura(
        suraNumber: i + 1,
        isMAkki: QSQuran.SuraIsMakki[i],
        numberOfAyahs: QSQuran.SuraNumberOfAyahs[i],
        startPageNumber: QSQuran.SuraPageStart[i]))
    }
    return suras
  }
}
