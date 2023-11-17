//
//  ValueConstants.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import struct CoreGraphics.CGFloat

extension CGFloat {
  static let buttonSize: CGFloat = 44
  //static let iconSize: CGFloat = 44
  static let cellSideEdge: CGFloat = 12
  static let viewPadding: CGFloat = 8
  static let labelPaddingTop: CGFloat = 11
  static let labelPaddingBottom: CGFloat = 10
  static let imagePointSize: CGFloat = 20
  static func shadowRadius(_ isRegular: Bool) -> CGFloat { isRegular ? 32 : 8 }
}

extension Float {
  static let shadowOpacity: Float = 0.15

}
