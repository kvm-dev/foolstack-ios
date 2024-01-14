//
//  ExaminationVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 10.01.2024.
//

import Foundation
import UIKit

@MainActor
final class ExaminationVC : UIViewController {

    var viewModel: ExaminationVM!
    private weak var questionView: UIView?

    init(viewModel: ExaminationVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.hidesBottomBarWhenPushed = true
        
        viewModel.onShowNextQuestion = { [unowned self] vm in
            self.showNextCard(viewModel: vm)
        }
        viewModel.onShowExamResult = { [unowned self] result in
            self.showFinishResult(result: result)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        viewModel.goNext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func createViews() {
        self.view.backgroundColor = .systemGray4
        
    }
    
    private func createQuestionView(viewModel: ExamQuestionVM) -> UIView {
        let v = ExamQuestionView(viewModel: viewModel, frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        v.pinEdges(to: view.safeAreaLayoutGuide, padding: 12)
        v.backgroundColor = .themeBackgroundSecondary
        v.layer.cornerRadius = 12
        v.setShadow()
        v.clipsToBounds = true
        v.tag = 1
        
        v.onClose = { [weak self] in
            self?.close(withAlert: true)
        }

        return v
    }
    
    private func createConfirmButton(title: String, color: UIColor) -> UIButton {
        let buttonPadding: CGFloat = 12
        let button = BorderButton(backgroundColor: color)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.pinEdges(to: view.safeAreaLayoutGuide, leading: buttonPadding, trailing: -buttonPadding, bottom: -buttonPadding)
        button.pinSize(height: 56)
        return button
    }
    
    private func showNextCard(viewModel: ExamQuestionVM) {
        let currentView = view.viewWithTag(1)
        let newView = createQuestionView(viewModel: viewModel)
        if currentView != nil {
            transitionViews(fromView: currentView, toView: newView)
        }
    }
    
    private func transitionViews(fromView: UIView?, toView: UIView?) {
        toView?.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            toView?.transform = CGAffineTransform.identity
            fromView?.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        } completion: { fin in
            fromView?.removeFromSuperview()
        }

    }
    
    func showFinishResult(result: ExamResult) {
        let vc = ExamFinishView(result: result)
        vc.onLaunchNext = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func close(withAlert: Bool) {
        let popupConfig = ConfirmationPopupConfig(
            title: String(localized: "Do you want to stop testing?"),
            text: String(localized: "The result will not be recorded"),
            onConfirm: PopupButtonAction(onPress: {
                return true
            }, onDismissed: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }),
            onCancel: PopupButtonAction()
        )
        PopupManager.shared.launch(view: popupConfig)
    }
    
}


