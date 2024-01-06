//
//  StringExtension.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 01.01.2024.
//

import Foundation
import UIKit

extension String {
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
    return ceil(boundingBox.height)
  }
  
  func height(width: CGFloat, font: String, fontSize: CGFloat) -> CGFloat {
    self.height(withConstrainedWidth: width, font: UIFont(name: font, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular))
  }
  
  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
    return ceil(boundingBox.width)
  }
}

