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

func zeroPoint(for volume: Float) -> Float {
  var zeroPointValue: Float = 0
  switch Int(volume) {
  case 0:
    zeroPointValue = 120
  case 1...3:
    zeroPointValue = 119
  case 4:
    zeroPointValue = 118
  case 5:
    zeroPointValue = 117
  case 6:
    zeroPointValue = 116
  case 7:
    zeroPointValue = 115
  case 8:
    zeroPointValue = 114
  case 9:
    zeroPointValue = 113
  case 10:
    zeroPointValue = 112
  case 11:
    zeroPointValue = 105
  case 12:
    zeroPointValue = 103
  case 13:
    zeroPointValue = 100
  case 14:
    zeroPointValue = 97
  case 15:
    zeroPointValue = 94
  case 16:
    zeroPointValue = 91
  case 17:
    zeroPointValue = 88
  case 18:
    zeroPointValue = 85
  case 19:
    zeroPointValue = 82
  case 20:
    zeroPointValue = 79
  case 21:
    zeroPointValue = 75
  case 22:
    zeroPointValue = 74
  case 23:
    zeroPointValue = 71
  case 24:
    zeroPointValue = 68
  case 25:
    zeroPointValue = 65
  case 26:
    zeroPointValue = 63
  case 27:
    zeroPointValue = 61
  case 28:
    zeroPointValue = 60
  case 29, 30:
    zeroPointValue = 57
  case 31, 32:
    zeroPointValue = 56
  case 33, 34:
    zeroPointValue = 55
  case 35, 36:
    zeroPointValue = 54
  case 38:
    zeroPointValue = 53
  case 39, 40, 41:
    zeroPointValue = 52
  case 42:
    zeroPointValue = 51
  case 43:
    zeroPointValue = 50
  case 44,45:
    zeroPointValue = 49
  case 46,47:
    zeroPointValue = 48
  case 48,49:
    zeroPointValue = 47
  case 50,51:
    zeroPointValue = 46
  case 52,53:
    zeroPointValue = 45
  case 54,55:
    zeroPointValue = 44
  case 56,57:
    zeroPointValue = 43
  case 58,59:
    zeroPointValue = 42
  case 60,61:
    zeroPointValue = 41
  case 62...65:
    zeroPointValue = 40
  case 85...160:
    zeroPointValue = 35
  default:
    zeroPointValue = 0
  }
  return zeroPointValue
}
