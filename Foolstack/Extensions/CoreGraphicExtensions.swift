//
//  CoreGraphicExtensions.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 07.01.2024.
//

import Foundation

extension CGSize {
  init(_ width: CGFloat, _ height: CGFloat) {
    self.init(width: width, height: height)
  }
}

extension CGPoint {
  init(_ x: CGFloat, _ y: CGFloat) {
    self.init(x: x, y: y)
  }
}

extension CGVector {
  init(_ dx: CGFloat, _ dy: CGFloat) {
    self.init(dx: dx, dy: dy)
  }
}

extension CGRect {
  init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
    self.init(x: x, y: y, width: width, height: height)
  }
  
  init(_ point1: CGPoint, _ point2: CGPoint) {
    self.init(x: min(point1.x, point2.x),
              y: min(point1.y, point2.y),
              width: abs(point1.x - point2.x),
              height: abs(point1.y - point2.y))
  }
}

extension CGRect {
  var center : CGPoint {
    return CGPoint(self.midX, self.midY)
  }
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
  return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}

func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
  sqrt(CGPointDistanceSquared(from: from, to: to))
}
