  //
  //  QSAyah.swift
  //  QSQuran
  //
  //  Created by Mohamed Afifi on 4/24/16.
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
  
  public struct QSAyah: Hashable, CustomStringConvertible {
    public let sura: Int
    public let ayah: Int
    public let text: String?
    public var isExpanded = false
    
    public init(sura: Int, ayah: Int, text: String? = nil) {
      self.sura = sura
      self.ayah = ayah
      self.text = text
    }
    
    public var hashValue: Int {
      return "\(sura):\(ayah)".hashValue
    }
    
    public mutating func switchExpandeState() {
      self.isExpanded = !isExpanded
    }
    
    func getStartPage() -> Int {
      
      // sura start index
      var index = QSQuran.SuraPageStart[sura - 1] - 1
      while index < QSQuran.PageSuraStart.count {
        // what's the first sura in that page?
        let ss = QSQuran.PageSuraStart[index]
        
        // if we've passed the sura, return the previous page
        // or, if we're at the same sura and passed the ayah
        if ss > sura || (ss == sura && QSQuran.PageAyahStart[index] > ayah) {
          break
        }
        
        // otherwise, look at the next page
        index += 1
      }
      
      return index
    }
    
    func nextAyah() -> QSAyah? {
      if ayah < QSQuran.numberOfAyahsForSura(sura) {
        // same sura
        return QSAyah(sura: sura, ayah: ayah + 1)
      } else {
        if sura < QSQuran.SuraPageStart.count {
          // next sura
          return QSAyah(sura: sura + 1, ayah: 1)
        } else {
          return nil // last ayah
        }
      }
    }
    
    func previousAyah() -> QSAyah? {
      if ayah > 1 {
        // same sura
        return QSAyah(sura: sura, ayah: ayah - 1)
      } else if sura > 1 {
        // previous sura
        let newSura = sura - 1
        return QSAyah(sura: newSura, ayah: QSQuran.numberOfAyahsForSura(newSura))
      } else {
        return nil
      }
    }
    
    public var description: String {
      return "\(QSQuran.nameForSura(sura)) - \(ayah)"
    }
  }
  
  public func == (lhs: QSAyah, rhs: QSAyah) -> Bool {
    return lhs.sura == rhs.sura && lhs.ayah == rhs.ayah
  }
  
  extension QSAyah {
    var startsWithBesmallah: Bool {
      return ayah == 1 && sura != 1 && sura != 9
    }
  }
  
  extension QSAyah {
    // GCP API RESPONSE
    init?(json: JSONDictionary) {
      guard let suraId = json["surah"] as? Int,
        let ayaId = json["verse"] as? Int,
        let text = json["text"] as? String else {
          return nil
      }
      
      self.sura = suraId
      self.ayah = ayaId
      self.text = text
    }
    // ALFANOOSE API RESPONSE
    
    //  init?(json: JSONDictionary) {
    //    guard let identifier = json["identifier"] as? JSONDictionary,
    //      let suraId = identifier["sura_id"] as? Int,
    //      let ayaId = identifier["aya_id"] as? Int else {
    //        return nil
    //    }
    //
    //    guard let aya = json["aya"] as? JSONDictionary,
    //      let text = aya["text"] as? String else {
    //        return nil
    //    }
    //
    //    self.sura = suraId
    //    self.ayah = ayaId
    //    self.text = text
    //  }
  }
