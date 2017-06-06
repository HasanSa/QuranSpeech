//
//  AyahTableViewCell.swift
//  QuranSpeech
//
//  Created by Hasan Sa on 06/05/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit
import QuranSpeechEngine

class AyahTableViewCell: UITableViewCell {
  
  @IBOutlet weak var foregroundView: UIView! {
    didSet {
      foregroundView.layer.cornerRadius = 10
      foregroundView.layer.masksToBounds = true
      foregroundView.layer.borderColor = UIColor.lightGray.cgColor
      foregroundView.layer.borderWidth = 0.25
    }
  }
  
  @IBOutlet weak var ayahTextLabel: UILabel! {
    didSet {
      ayahTextLabel.text = ""
    }
  }
  @IBOutlet weak var nameLabel: UILabel! {
    didSet {
      nameLabel.text = ""
    }
  }

  @IBOutlet weak var numberLabel: UILabel! {
    didSet {
      numberLabel.text = ""
    }
  }

  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func config(_ ayah: QSAyah) {
    ayahTextLabel.text = ayah.text
    nameLabel.text = QSQuran.nameForSura(ayah.sura)
    numberLabel.text = "\(ayah.ayah)"
    //
    self.contentView.setNeedsLayout()
    self.contentView.layoutIfNeeded()
  }
  
}
