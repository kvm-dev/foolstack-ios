//
//  UIViewExtensions.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.01.2024.
//

import UIKit

extension UIView {
  var isRegular: Bool {
    return traitCollection.horizontalSizeClass == .regular
  }

  var isDarkMode: Bool {
    return traitCollection.userInterfaceStyle == .dark
  }
}

extension UIViewController {
  var isRegular: Bool {
    return traitCollection.horizontalSizeClass == .regular
  }
  
  var isDarkMode: Bool {
    return traitCollection.userInterfaceStyle == .dark
  }
}

extension UIPresentationController {
  var isRegular: Bool {
    self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .regular
  }
}

// MARK: Shadow

extension UIView {
  func setShadow(radius: CGFloat? = nil,
                 color: UIColor = UIColor.themeShadow1,
                 opacity: Float = .shadowOpacity,
                 offset: CGSize = .zero) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowRadius = radius != nil ? radius! : .shadowRadius(self.isRegular)
    layer.shadowOffset = offset
  }
}
