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
  
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var textView: UIView!
  
  @IBOutlet weak var foregroundView: UIView! {
    didSet {
      foregroundView.layer.cornerRadius = 5
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
    textViewHeightConstraint.constant = 0.0
    textView.isHidden = true
  }
  
  func config(_ ayah: QSAyah) {
    nameLabel.text = QSQuran.nameForSura(ayah.sura)
    numberLabel.text = "\(ayah.ayah)"
    ayahTextLabel.attributedText = ayah.text?.html2AttributedString
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    let constant: CGFloat = selected ? 360.0 : 0.0
    
    print("Setting constant to \(constant) - Animated: \(animated)")
    
    if !animated {
      textViewHeightConstraint.constant = constant
      textView.isHidden = !selected
      
      return
    }
    
    UIView.animate(withDuration: 0.3, delay: 0.0,
                   options: [.allowUserInteraction, .beginFromCurrentState],
                   animations: {
                    self.textViewHeightConstraint.constant = constant
                    self.layoutIfNeeded()
    }, completion: { completed in
      self.textView.isHidden = !selected
    })
  }
  
}
