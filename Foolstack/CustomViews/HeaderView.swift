//
//  HeaderView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit
import Combine

class HeaderBar: NibView {
  @IBOutlet weak var leftButtonStack: UIStackView!
  @IBOutlet weak var rightButtonStack: UIStackView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var sliderView: UIView!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  
    @IBInspectable var color: UIColor = .yellow {//}.themeBackgroundSecondary {
    didSet {
      headerView.backgroundColor = color
    }
  }
  @IBInspectable var withSlider: Bool = false {
    didSet {
      sliderView.isHidden = !withSlider
      topConstraint.constant = withSlider ? 8 : 0
    }
  }
  
  var subscriptions = Set<AnyCancellable>()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  /// - Parameters:
  ///   - withSlider: Short line on top (no interactive)
  ///   - onPopup: For color selection
  init(withSlider: Bool, onPopup: Bool = false) {
    super.init(frame: .zero)
    self.withSlider = withSlider
    sliderView.isHidden = !withSlider
    topConstraint.constant = withSlider ? 8 : 0
      color = .blue// onPopup ? .themeHeaderPopup : .themeHeaderMain
    initialize()
  }
  
  private func initialize() {
    //print("IndicatorView init")
    //slider.setThumbImage(.symbolImage(.iconSlider), for: .normal)
    //self.backgroundColor = .blue
    headerView.layer.cornerRadius = 8
    sliderView.layer.cornerRadius = 2
    headerView.backgroundColor = color
  }
  
  func addLeftButton(button: UIButton) {
    leftButtonStack.addArrangedSubview(button)
  }

  func addRightButton(button: UIButton) {
    rightButtonStack.insertArrangedSubview(button, at: 0)
  }
}

