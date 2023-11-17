//
//  UIImageExtensions.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit

extension UIImage {
//  static func symbolImage(_ name: String, pointSize: CGFloat = 22) -> UIImage {
//    let conf = UIImage.SymbolConfiguration(pointSize: pointSize)
//    return UIImage(named: name, in: nil, with: conf) ?? UIImage()
//  }
  static func symbolImage(iconName: IconNames, pointSize: CGFloat = 20) -> UIImage {
    let conf = UIImage.SymbolConfiguration(pointSize: pointSize)
    return UIImage(named: iconName.name, in: nil, with: conf) ?? UIImage()
  }
  static func symbolImage(_ iconName: IconNames, pointSize: CGFloat = 20) -> UIImage {
    let conf = UIImage.SymbolConfiguration(pointSize: pointSize)
    return UIImage(named: iconName.name, in: nil, with: conf) ?? UIImage()
  }
  static func checkboxImage(checked: Bool) -> UIImage {
    return checked ? symbolImage(iconName: .checkboxActive) : symbolImage(iconName: .checkbox)
  }
}

extension UIImage {
  func scaledDown(size: CGSize) -> UIImage {
    var (targetWidth, targetHeight) = (self.size.width, self.size.height)
    var (scaleW, scaleH) = (CGFloat(1), CGFloat(1))
    if targetWidth > size.width {
      scaleW = size.width / targetWidth
    }
    if targetHeight > size.height {
      scaleH = size.height / targetHeight
    }
    let scale = min(scaleW, scaleH)
    targetWidth *= scale; targetHeight *= scale
    let sz = CGSize(width: targetWidth, height: targetHeight)
    return UIGraphicsImageRenderer(size: sz).image { _ in
      self.draw(in: CGRect(origin: .zero, size: sz))
    }
  }
}

extension UIImage {
  static func coloredImageRect(size: CGSize, color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    UIGraphicsBeginImageContext(size)
    color.set()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
  }
}

