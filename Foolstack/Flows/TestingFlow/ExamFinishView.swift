//
//  ExamFinishView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.01.2024.
//

import UIKit
import Combine

class ExamFinishView: UIViewController {
    var onLaunchNext: (() -> Void)?
    
    private var centerView: UIView!
    private var firstContentStack: UIStackView!
    private var statsView: ExamStatsView!
    private var firstCounter: UICounterLabel!
    private var secondCounter: UICounterLabel!
    private var confirmButton: UIButton!
    
    private var examResult: ExamResult!
    private var subscriptions = Set<AnyCancellable>()
    
    init(result: ExamResult) {
        super.init(nibName: nil, bundle: nil)
        self.examResult = result
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createContent()
        updateBottomButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present()
    }
    
    func present() {
        let learned = examResult.correctAnswers
        let unlearned = examResult.wrongAnswers
        
        statsView.setup(first: learned, second: unlearned, animated: true)
        
        if learned > 0 {
            firstCounter.superview!.isHidden = false
            firstCounter.countFrom(0, to: CGFloat(learned), withDuration: 1.0)
        } else {
            firstCounter.superview!.isHidden = true
        }
        if unlearned > 0 {
            secondCounter.superview!.isHidden = false
            secondCounter.countFrom(0, to: CGFloat(unlearned), withDuration: 1.0)
        } else {
            secondCounter.superview!.isHidden = true
        }
        
        updateBottomButton()
        
        UIView.animate(withDuration: 2) { [weak self] in
            guard let self = self else {return}
            self.confirmButton.isHidden = false
            
        }
    }
    
    func updateBottomButton() {
        //    let str = viewModel.nextPackTerms.isEmpty ? NSLocalizedString("NO WORDS. EXIT", comment: "") : String.localizedStringWithFormat(NSLocalizedString("learn the next %d words", comment: ""), viewModel.nextPackTerms.count)
        //    bottomButton.setTitle(str, for: .normal)
    }
    
    func createContent() {
        self.view.backgroundColor = .systemGray4

        centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerView)
        centerView.pinEdges(to: view.safeAreaLayoutGuide, padding: 12)
        centerView.backgroundColor = .themeBackgroundSecondary
        centerView.layer.cornerRadius = 12
        centerView.setShadow()
        centerView.clipsToBounds = true

        let w: CGFloat = 271
        let statsView = ExamStatsView(frame:.zero, color1: .themeStatGood, color2: .themeStatBad)
        self.statsView = statsView
        statsView.translatesAutoresizingMaskIntoConstraints = false
        self.centerView.addSubview(statsView)
        statsView.pinEdges(to: self.centerView, centerX: 0, centerY: 0)
        statsView.pinSize(width: w, height: w)
        
        let buttonPadding: CGFloat = 12
        let button = BorderButton(backgroundColor: .themeAccent)
        self.centerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Finish"), for: .normal)
        button.pinEdges(to: self.centerView, leading: buttonPadding, trailing: -buttonPadding, bottom: -buttonPadding)
        button.pinSize(height: 56)
        button.isHidden = true
        button.addTarget(self, action: #selector(launchNextOrExit), for: .touchUpInside)
        self.confirmButton = button

        createLabels()
    }

    private func createLabels() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        //stack.backgroundColor = .brown
        //stack.distribution = .equalCentering
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.centerView.addSubview(stack)
        stack.pinEdges(to: self.centerView, centerX: 0, centerY: 0)
        
        firstCounter = createLabelView(color: .themeStatGood, on: stack)
        firstCounter.format = "+%d"
        secondCounter = createLabelView(color: .themeStatBad, on: stack)
        secondCounter.format = "-%d"
    }
    
    private func createLabelView(color: UIColor, on stackView: UIStackView) -> UICounterLabel {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = color
        v.layer.cornerRadius = 8
        
        let label = UICounterLabel(method: .UILabelCountingMethodEaseInOut, duration: 3)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        label.pinEdges(to: v, centerX: 0, centerY: 0)
        label.font = CustomFonts.defaultSemiBold(size: 24)
        label.textColor = .themeBackgroundMain
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.pinEdges(to: v, leading: 10, top: 5)
        v.pinEdges(to: label, trailing: 10, bottom: 5)
        
        stackView.addArrangedSubview(v)
        
        return label
    }
    
    @objc func launchNextOrExit() {
        onLaunchNext?()
    }
}



extension UIImage {
    static func learnStatsImage(learned: Int, unlearned: Int) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: 271, height: 271)
        let radiusBig: CGFloat = frame.width * 0.5
        let radiusSmall: CGFloat = frame.width * 0.3
        let multiOffset: CGFloat = learned > 0 && unlearned > 0 ? 1 : 0
        let angleOffsetBig: CGFloat = 2.0 / radiusBig * multiOffset
        let angleOffsetSmall: CGFloat = 2.0 / radiusSmall * multiOffset
        
        let all = learned + unlearned
        let learnedAngle: CGFloat = CGFloat(learned) / CGFloat(all) * .pi*2
        let unlearnedAngle: CGFloat = .pi*2 - learnedAngle
        
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        
        let img = renderer.image { ctx in
            let x: CGFloat = frame.width/2
            let y: CGFloat = frame.height/2
            
            if learned > 0 {
                ctx.cgContext.setFillColor(UIColor.themeStatGood.cgColor)
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radiusSmall, startAngle: -.pi/2 + angleOffsetSmall, endAngle: -.pi/2 + learnedAngle - angleOffsetSmall, clockwise: false)
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radiusBig, startAngle: -.pi/2 + learnedAngle - angleOffsetBig, endAngle: -.pi/2 + angleOffsetBig, clockwise: true)
                
                ctx.cgContext.drawPath(using: .fill)
            }
            
            if unlearned > 0 {
                ctx.cgContext.setFillColor(UIColor.themeStatBad.cgColor)
                
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radiusSmall, startAngle: -.pi/2 - angleOffsetSmall, endAngle: -.pi/2 - unlearnedAngle + angleOffsetSmall, clockwise: true)
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radiusBig, startAngle: -.pi/2 - unlearnedAngle + angleOffsetBig, endAngle: -.pi/2 - angleOffsetBig, clockwise: false)
                
                ctx.cgContext.drawPath(using: .fill)
            }
        }
        return img
    }
}



class ExamStatsView: UIView {
    var duration: TimeInterval = 1.0
    private(set) var firstValue: Int = 0
    private(set) var secondValue: Int = 0
    private weak var firstProgressView: CircularProgressView!
    private weak var secondProgressView: CircularProgressView!
    private weak var linesView: CircleWatchLines!
    
    init(frame: CGRect, color1: UIColor, color2: UIColor) {
        super.init(frame: frame)
        initialize(color1: color1, color2: color2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //changeShape()
    }
    
    func initialize(color1: UIColor, color2: UIColor) {
        self.backgroundColor = .clear
        
        let lineWidth: CGFloat = 56
        let padding = lineWidth / 2
        //let width: CGFloat = 271 - lineWidth
        
        let cp1 = CircularProgressView(frame: .zero, isReverse: false)
        self.firstProgressView = cp1
        cp1.lineWidth = lineWidth
        cp1.trackColor = UIColor.clear
        cp1.progressColor = color1
        cp1.backgroundColor = .clear
        self.addSubview(cp1)
        cp1.translatesAutoresizingMaskIntoConstraints = false
        cp1.pinEdges(to: self, leading: padding, trailing: -padding, top: padding, bottom: -padding)
        //cp1.pinSize(width: width, height: width)
        //cp1.pinSize(width: width - lineWidth, height: width - lineWidth)
        
        let cp2 = CircularProgressView(frame: .zero, isReverse: true)
        self.secondProgressView = cp2
        cp2.lineWidth = lineWidth
        cp2.trackColor = UIColor.clear
        cp2.progressColor = color2
        cp2.backgroundColor = .clear
        self.addSubview(cp2)
        cp2.translatesAutoresizingMaskIntoConstraints = false
        cp2.pinEdges(to: self, leading: padding, trailing: -padding, top: padding, bottom: -padding)
        //    cp2.pinEdges(to: self, centerX: 0, centerY: 0)
        //    cp2.pinSize(width: width - lineWidth, height: width - lineWidth)
        
        let lines = CircleWatchLines(frame: .zero)
        self.addSubview(lines)
        lines.translatesAutoresizingMaskIntoConstraints = false
        lines.pinEdges(to: self, leading: 0, trailing: 0, top: 0, bottom: 0)
        self.linesView = lines
        
        setup()
    }
    
    func setup(first: Int = 0, second: Int = 0,
               animated: Bool = false) {
        self.firstValue = first
        self.secondValue = second
        self.linesView.setValues(first: first, second: second)
        
        if animated {
            animateShape()
        } else {
            changeShape()
        }
    }
    
    private func changeShape() {
        //let frame = self.bounds
        //let radiusBig: CGFloat = frame.width * 0.5
        //let radiusSmall: CGFloat = frame.width * 0.3
        let multiOffset: CGFloat = firstValue > 0 && secondValue > 0 ? 1 : 0
        //let angleOffsetBig: CGFloat = 2.0 / radiusBig * multiOffset
        //let angleOffsetSmall: CGFloat = 2.0 / radiusSmall * multiOffset
        
        //let all = firstValue + secondValue
        //let learnedValue: CGFloat = CGFloat(firstValue) / CGFloat(all)
        //let unlearnedValue: CGFloat = 1.0 - learnedValue
        
        linesView.isHidden = multiOffset < 1
        
        //    firstProgressView.progressValue = learnedValue
        //    secondProgressView.progressValue = unlearnedValue
    }
    
    private func animateShape() {
        //let frame = self.bounds
        //let radiusBig: CGFloat = frame.width * 0.5
        //let radiusSmall: CGFloat = frame.width * 0.3
        let multiOffset: CGFloat = firstValue > 0 && secondValue > 0 ? 1 : 0
        //let angleOffsetBig: CGFloat = (1.0 / radiusBig) / .pi * multiOffset
        //let angleOffsetSmall: CGFloat = (1.0 / radiusSmall) / .pi * multiOffset
        let offset: CGFloat = 0//(angleOffsetSmall + angleOffsetBig) / 2.0
        
        let all = firstValue + secondValue
        let learnedValue: CGFloat = CGFloat(firstValue) / CGFloat(all) - offset
        let unlearnedValue: CGFloat = CGFloat(secondValue) / CGFloat(all) - offset//1.0 - learnedValue - offset
        
        linesView.isHidden = multiOffset < 1
        firstProgressView.startValue = offset
        secondProgressView.startValue = offset
        firstProgressView.setProgressWithAnimation(duration: duration, value: learnedValue)
        secondProgressView.setProgressWithAnimation(duration: duration, value: unlearnedValue)
    }
    
}

class CircleWatchLines: UIView {
    var firstValue: Int = 0
    var secondValue: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = .clear
        
    }
    
    func setValues(first: Int, second: Int) {
        self.firstValue = first
        self.secondValue = second
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        let all = firstValue + secondValue
        let angle: CGFloat = CGFloat(firstValue) / CGFloat(all) * .pi*2 - .pi/2
        
        let x = self.bounds.width / 2.0
        let y = self.bounds.height / 2.0
        let radius = x
        
        context.saveGState()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: 0))
        
        let x2 = x + radius * cos(angle)
        let y2 = y + radius * sin(angle)
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x2, y: y2))
        context.addPath(path)
        context.setStrokeColor(UIColor.themeBackgroundMain.cgColor)
        context.setLineWidth(4)
        context.drawPath(using: CGPathDrawingMode.stroke)
        context.restoreGState()
        
    }
}

