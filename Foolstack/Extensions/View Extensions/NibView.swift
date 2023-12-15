//
//  NibView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit

class NibView: UIView {
  var view: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    xibSetup()
  }
  
  private func xibSetup() {
    backgroundColor = .clear
    view = loadNib()
    view.frame = bounds
    addSubview(view)
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
}

extension UIView {
  /// Loads instance from nib with the same name.
  func loadNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nibName = type(of: self).description().components(separatedBy: ".").last!
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first as! UIView
  }
}
