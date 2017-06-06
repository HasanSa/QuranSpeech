//
//  AudioRecordingView.swift
//  QuranSpeechApp
//
//  Created by Hasan Sa on 04/06/2017.
//  Copyright © 2017 Quran Speech Team. All rights reserved.
//

import UIKit

@IBDesignable class AudioRecordingView: UIView {
  
  @IBInspectable var widthLine: Int = 0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override func draw(_ rect: CGRect) { 
    let h = rect.height
    let w = rect.width
    let bcolor: UIColor = UIColor.lightGray
    
    let drect = CGRect(x: (w * 0.25),
                       y: (h * 0.25),
                       width: (w * 0.5),
                       height: (h * 0.5))
    let bpath:UIBezierPath = UIBezierPath(ovalIn: drect)
    bpath.lineWidth = CGFloat(widthLine) < frame.width  ? CGFloat(widthLine)  : 0.47 * frame.width
    bcolor.set()
    bpath.stroke()
    bpath.fill()
  }
}
