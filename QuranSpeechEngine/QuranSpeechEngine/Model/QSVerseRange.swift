//
//  VerseRange.swift
//  QSQuran
//
//  Created by Mohamed Afifi on 3/23/17.
//
//  QSQuran for iOS is a QSQuran reading application for iOS.
//  Copyright (C) 2017  QSQuran.com
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

struct VerseRange {
    let lowerBound: QSAyah
    let upperBound: QSAyah
}

extension VerseRange {

    func getAyahs() -> [QSAyah] {
        var ayahs: [QSAyah] = []
        for sura in lowerBound.sura...upperBound.sura {

            let startQSAyah = sura == lowerBound.sura ? lowerBound.ayah : 1
            let endQSAyah = sura == upperBound.sura ? upperBound.ayah : QSQuran.numberOfAyahsForSura(sura)

            for ayah in startQSAyah...endQSAyah {
                ayahs.append(QSAyah(sura: sura, ayah: ayah))
            }
        }
        return ayahs
    }
}
