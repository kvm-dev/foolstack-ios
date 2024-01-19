//
//  SpinnerProgressView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 19.01.2024.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class SpinnerProgressVC : UIViewController {
    enum SpinnerType {
        case simple
        case progress
    }
    private(set) var spinner: NVActivityIndicatorView!
    
    var type: SpinnerType = .simple
    private(set) var size: CGFloat = 100
    //  var progressLabel: UILabel!
    //var cancelButton: UIButton!
    
    private var onCancel: (() -> Void)?
    
    init(type: SpinnerType, parent: UIViewController, autolayoutView: UIView? = nil, size: CGFloat = 100, color: UIColor? = nil, onCancel: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.onCancel = onCancel
        self.type = type
        self.size = 72//size
        
        parent.addChild(self)
        
        parent.view.addSubview(self.view)
        self.didMove(toParent: parent)
        self.viewWillAppear(false)
        self.viewDidAppear(false)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.pinEdges(to: autolayoutView ?? parent.view)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = .themeOverlay// .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        
        let mainColor = UIColor.themeAccent
        
        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backView)
        backView.pinSize(width: size, height: size)
        backView.pinEdges(to: view, centerX: 0, centerY: 0)
        
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        let radius1: CGFloat = size / 2
        
        path.addArc(withCenter: CGPoint(x: size / 2, y: size / 2),
                    radius: radius1,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = UIColor.themeBackgroundMain.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        backView.layer.addSublayer(layer)
        
        let spinnerSize: CGFloat = size / 1.2857
        
        let layer2: CAShapeLayer = CAShapeLayer()
        let path2: UIBezierPath = UIBezierPath()
        let radius2: CGFloat = spinnerSize / 2
        
        path2.addArc(withCenter: CGPoint(x: size / 2, y: size / 2),
                     radius: radius2,
                     startAngle: 0,
                     endAngle: CGFloat(2 * Double.pi),
                     clockwise: false)
        layer2.strokeColor = UIColor.themeHeader.cgColor
        layer2.lineWidth = 4
        layer2.fillColor = nil
        layer2.backgroundColor = nil
        layer2.path = path2.cgPath
        layer2.frame = CGRect(x: 0, y: 0, width: size, height: size)
        backView.layer.addSublayer(layer2)
        
        let indicatorType: NVActivityIndicatorType = type == .simple ? .circleStrokeSpin : .circleStrokeSpin//.strokeProgress
        spinner = NVActivityIndicatorView(frame: CGRect(0,0,spinnerSize,spinnerSize), type: indicatorType, color: mainColor)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //    progressLabel = UILabel()
        //    progressLabel.font = UIFont(name: .fontSFSemibold, size: 25)
        //    progressLabel.textColor = spinner.color
        //    progressLabel.text = "0"
        //
        //    view.addSubview(progressLabel)
        //    progressLabel.translatesAutoresizingMaskIntoConstraints = false
        //    progressLabel.pinEdges(to: spinner, centerX: 0, centerY: 0)
        
        if onCancel != nil {
            createCancelButton()
        } else {
            createCenterImage()
        }
        
        UIView.animate(withDuration: 0.3) { [weak view] in
            view?.alpha = 1
        }
    }
    
    private func createCancelButton() {
        let buttonSize: CGFloat = max(44, size)
        let imageSize = size / 1.8
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        cancelButton.setImage(.symbolImage(iconName: .delete, pointSize: imageSize), for: .normal)
        cancelButton.tintColor = spinner.color
        //cancelButton.setTitle("Cancel", for: .normal)
        //cancelButton.tintColor = spinner.color
        view.addSubview(cancelButton)
        //cancelButton.topAnchor.constraint(equalTo: spinner.bottomAnchor).isActive = true
        cancelButton.pinEdges(to: spinner, centerX: 0, centerY: 0)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
    }
    
    private func createCenterImage() {
        let imageSize = size / 1.8
        
        let centerImage = UIImageView(image: UIImage(named: "indicator_waiting_logo_1"))
        centerImage.translatesAutoresizingMaskIntoConstraints = false
        centerImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        centerImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        //cancelButton.setTitle("Cancel", for: .normal)
        //cancelButton.tintColor = spinner.color
        view.addSubview(centerImage)
        //cancelButton.topAnchor.constraint(equalTo: spinner.bottomAnchor).isActive = true
        centerImage.pinEdges(to: spinner, centerX: 0, centerY: 0)
    }
    
    func close() {
        UIView.animate(withDuration: 0.3) { [weak view] in
            view?.alpha = 0
        } completion: { [unowned self] _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    func setProgress(_ progress: Float) {
        let val: Float = min(1, max(0, progress))
        //    progressLabel.text = "\(val)"
        spinner.setProgress(val)
    }
    
    @objc func cancelPressed(_ sender: UIButton) {
        print("--------- CANCEL PRESSED -----------")
        onCancel?()
        sender.isEnabled = false
    }
}
