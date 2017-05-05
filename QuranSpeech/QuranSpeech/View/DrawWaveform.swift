//
//  Draw2dWaveform.swift
//  Beatmaker
//
//  Created by Miguel Saldana on 10/17/16.
//  Copyright © 2016 Miguel Saldana. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
class DrawWaveform: UIView {
  
  var arrayFloatValues:[Float] = [] {
    didSet {
      setNeedsDisplay()
    }
  }
  var points:[CGFloat] = []
  
  
  override func draw(_ rect: CGRect) {
    // print(rect)
    self.convertToPoints()
    var f = 0
    // print("draw")
    
    let aPath = UIBezierPath()
    let aPath2 = UIBezierPath()
    
    aPath.lineWidth = 2.0
    aPath2.lineWidth = 2.0
    
    aPath.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
    aPath2.move(to: CGPoint(x:0.0 , y:rect.height ))
    
    
    // // print(points)
    for _ in points{
      //separation of points
      var x:CGFloat = 2.5
      aPath.move(to: CGPoint(x:aPath.currentPoint.x + x , y:aPath.currentPoint.y ))
      
      //Y is the amplitude
      aPath.addLine(to: CGPoint(x:aPath.currentPoint.x  , y:aPath.currentPoint.y - (points[f] * 190) - 1.0))
      
      aPath.close()
      
      //// print(aPath.currentPoint.x)
      x += 1
      f += 1
    }
    
    //If you want to stroke it with a Orange color
    UIColor.orange.set()
    aPath.stroke()
    //If you want to fill it as well
    aPath.fill()
    
    
    f = 0
    aPath2.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
    
    //Reflection of waveform
    for _ in points{
      var x:CGFloat = 2.5
      aPath2.move(to: CGPoint(x:aPath2.currentPoint.x + x , y:aPath2.currentPoint.y ))
      
      //Y is the amplitude
      aPath2.addLine(to: CGPoint(x:aPath2.currentPoint.x  , y:aPath2.currentPoint.y - ((-1.0 * points[f]) * 50)))
      
      // aPath.close()
      aPath2.close()
      
      //// print(aPath.currentPoint.x)
      x += 1
      f += 1
    }
    
    //If you want to stroke it with a Orange color with alpha2
    UIColor.orange.set()
    aPath2.stroke(with: CGBlendMode.normal, alpha: 0.5)
    //   aPath.stroke()
    
    //If you want to fill it as well
    aPath2.fill()
  }
  
  func convertToPoints() {
    var processingBuffer = [Float](repeating: 0.0,
                                   count: Int(arrayFloatValues.count))
    let sampleCount = vDSP_Length(arrayFloatValues.count)
    //// print(sampleCount)
    vDSP_vabs(arrayFloatValues, 1, &processingBuffer, 1, sampleCount);
    
    let multiplier = 0.25
    // print(multiplier)
//    if multiplier < 1{
//      multiplier = 1.0
//      
//    }
    
    
    let samplesPerPixel = Int(90 * multiplier)
    let filter = [Float](repeating: 1.0 / Float(samplesPerPixel),
                         count: Int(samplesPerPixel))
    let downSampledLength = Int(arrayFloatValues.count / samplesPerPixel)
    var downSampledData = [Float](repeating:0.0,
                                  count:downSampledLength)
    vDSP_desamp(processingBuffer,
                vDSP_Stride(samplesPerPixel),
                filter, &downSampledData,
                vDSP_Length(downSampledLength),
                vDSP_Length(samplesPerPixel))
    
    // // print(" DOWNSAMPLEDDATA: \(downSampledData.count)")
    
    //convert [Float] to [CGFloat] array
    points = downSampledData.map{CGFloat($0)}
    
    
  }
}
