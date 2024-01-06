//
//  NSObjectExtenstions.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
