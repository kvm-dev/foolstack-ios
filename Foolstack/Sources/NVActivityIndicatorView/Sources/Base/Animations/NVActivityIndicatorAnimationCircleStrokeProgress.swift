//
//
// NVActivityIndicatorAnimationCircleStrokeProgress.swift
// LangReader
//
// Created by Zolkin Evgeny on 03.04.2022
// Copyright © 2022 LangReader LLC. All rights reserved.
//
    

#if canImport(UIKit)
import UIKit

fileprivate let kProgressValueMin: Float = 0.01

class NVActivityIndicatorAnimationCircleStrokeProgress: NVActivityIndicatorAnimationDelegate {
  
  private unowned var layer: CAShapeLayer?
  
  func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
    let beginTime: Double = 0.5
    let strokeStartDuration: Double = 1.2
    let strokeEndDuration: Double = 0.7
    
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotationAnimation.byValue = Float.pi * 2
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    rotationAnimation.duration = strokeStartDuration
    rotationAnimation.repeatCount = .infinity
    rotationAnimation.isRemovedOnCompletion = false
    rotationAnimation.fillMode = .forwards

    /*let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.duration = strokeEndDuration
    strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 1
    
    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.duration = strokeStartDuration
    strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    strokeStartAnimation.fromValue = 0
    strokeStartAnimation.toValue = 1
    strokeStartAnimation.beginTime = beginTime
    
    let groupAnimation = CAAnimationGroup()
    groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
    groupAnimation.duration = strokeStartDuration + beginTime
    groupAnimation.repeatCount = .infinity
    groupAnimation.isRemovedOnCompletion = false
    groupAnimation.fillMode = .forwards*/
    
    let circle = NVActivityIndicatorShape.stroke.layerWith(size: size, color: color)
    let frame = CGRect(
      x: (layer.bounds.width - size.width) / 2,
      y: (layer.bounds.height - size.height) / 2,
      width: size.width,
      height: size.height
    )
    
    circle.strokeStart = 0
    print("ProgressValueMin = \(progressValueMin)")
    circle.strokeEnd = CGFloat(progressValueMin)
    
    circle.frame = frame
    circle.add(rotationAnimation, forKey: "animation")
    layer.addSublayer(circle)
    self.layer = circle
  }
  
  func setProgress(_ progress: Float) {
    layer?.strokeEnd = CGFloat(min(1 - progressValueMin, max(progressValueMin, progress)))
  }
  
  private var progressValueMin: Float {
    let r: CGFloat = layer?.bounds.width ?? 100 * 0.5
    let d = 2 * CGFloat.pi * r
    return Float(3 / d)
  }
}
#endif
