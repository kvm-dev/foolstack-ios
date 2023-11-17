//
//  UIView+Constraints.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit

extension UIView {
  func pinEdges(to other: UIView, padding: CGFloat = 0) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: padding),
      trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -padding),
      topAnchor.constraint(equalTo: other.topAnchor, constant: padding),
      bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -padding)
    ])
  }

  func pinEdges(to other: UILayoutGuide, padding: CGFloat) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: padding),
      trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -padding),
      topAnchor.constraint(equalTo: other.topAnchor, constant: padding),
      bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -padding)
    ])
  }

  func pinEdges(to other: UIView, leading: CGFloat? = nil, trailing: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil) {
    var constraints: [NSLayoutConstraint] = []
    if let leading = leading {
      constraints.append(self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: leading))
    }
    if let trailing = trailing {
      constraints.append(self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: trailing))
    }
    if let top = top {
      constraints.append(self.topAnchor.constraint(equalTo: other.topAnchor, constant: top))
    }
    if let bottom = bottom {
      constraints.append(self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: bottom))
    }
    if let centerX = centerX {
      constraints.append(self.centerXAnchor.constraint(equalTo: other.centerXAnchor, constant: centerX))
    }
    if let centerY = centerY {
      constraints.append(self.centerYAnchor.constraint(equalTo: other.centerYAnchor, constant: centerY))
    }

    NSLayoutConstraint.activate(constraints)
  }

  func pinEdges(to other: UIView, centerX: CGFloat? = nil, centerY: CGFloat? = nil) {
    var constraints: [NSLayoutConstraint] = []
    if let centerX = centerX {
      constraints.append(self.centerXAnchor.constraint(equalTo: other.centerXAnchor, constant: centerX))
    }
    if let centerY = centerY {
      constraints.append(self.centerYAnchor.constraint(equalTo: other.centerYAnchor, constant: centerY))
    }
    
    NSLayoutConstraint.activate(constraints)
  }

  func pinEdges(to other: UILayoutGuide, leading: CGFloat? = nil, trailing: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil) {
    var constraints: [NSLayoutConstraint] = []
    if let leading = leading {
      constraints.append(self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: leading))
    }
    if let trailing = trailing {
      constraints.append(self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: trailing))
    }
    if let top = top {
      constraints.append(self.topAnchor.constraint(equalTo: other.topAnchor, constant: top))
    }
    if let bottom = bottom {
      constraints.append(self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: bottom))
    }
    if let centerX = centerX {
      constraints.append(self.centerXAnchor.constraint(equalTo: other.centerXAnchor, constant: centerX))
    }
    if let centerY = centerY {
      constraints.append(self.centerYAnchor.constraint(equalTo: other.centerYAnchor, constant: centerY))
    }
    
    NSLayoutConstraint.activate(constraints)
  }
  
  func pinSize(width: CGFloat? = nil, height: CGFloat? = nil) {
    var constraints: [NSLayoutConstraint] = []
    if let width = width {
      constraints.append(self.widthAnchor.constraint(equalToConstant: width))
    }
    if let height = height {
      constraints.append(self.heightAnchor.constraint(equalToConstant: height))
    }
    
    NSLayoutConstraint.activate(constraints)
  }
}


class ViewLayoutGuide: UILayoutGuide {
  var topConstraint: NSLayoutConstraint?
  var bottomConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var trailingConstraint: NSLayoutConstraint?

  func pinEdges(to other: UIView, leading: CGFloat? = nil, trailing: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil) {
    if let leading = leading {
      self.leadingConstraint = self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: leading)
      self.leadingConstraint?.isActive = true
    }
    if let trailing = trailing {
      self.trailingConstraint = self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: trailing)
      self.trailingConstraint?.isActive = true
    }
    if let top = top {
      self.topConstraint = self.topAnchor.constraint(equalTo: other.topAnchor, constant: top)
      self.topConstraint?.isActive = true
    }
    if let bottom = bottom {
      self.bottomConstraint = self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: bottom)
      self.bottomConstraint?.isActive = true
    }
    
  }

}
