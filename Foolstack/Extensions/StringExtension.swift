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

extension String {
    /// Encode string to base 64
    func base64Encoded() -> String? {
        let plainData = self.data(using: .utf8)
        return plainData?.base64EncodedString(options: [])
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func placeholderAttributed() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.themeTextSecondary,
        ]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s]+", with: " ", options: .regularExpression, range: nil)
    }
}
