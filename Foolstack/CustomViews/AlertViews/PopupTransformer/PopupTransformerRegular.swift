//
//  PopupTransformerRegular.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

@MainActor
class PopupTransformerRegular: PopupTransformer {
    var sourceFrame: CGRect = .zero
    
    override func show() {
        let superview = view.superview!
        let safeArea = superview.safeAreaInsets
        let safeAreaPoint = CGPoint(safeArea.left, safeArea.top)
        let superviewFrame = superview.frame.inset(by: safeArea)
        
        let nearestRect = sourceFrame
        compactPopupFrame.size = .init(initialPopupSize.width, initialPopupSize.height)
        let padding: CGFloat = 15
        let fitLeft = nearestRect.minX > compactPopupFrame.width + padding
        let fitRight = nearestRect.maxX < superviewFrame.width - (compactPopupFrame.width + padding)
        let fitTop = nearestRect.minY > compactPopupFrame.height + padding
        let fitBottom = nearestRect.maxY < superviewFrame.height - (compactPopupFrame.height + padding)
        //print("Fit left? \(fitLeft), right? \(fitRight), top? \(fitTop), bottom? \(fitBottom)")
        
        //let pointOnTop = realPoint.y < superviewFrame.height / 2
        //var fromTop = !pointOnTop
        var destPos: CGPoint = .zero
        
        switch alignment {
        case .vertical:
            if fitBottom {
                destPos = .init(nearestRect.minX + nearestRect.width / 2 - compactPopupFrame.width / 2, nearestRect.maxY + padding)
            } else {
                destPos = .init(nearestRect.minX + nearestRect.width / 2 - compactPopupFrame.width / 2, nearestRect.minY - compactPopupFrame.height - padding)
            }
        default:
            break
        }
        //    if fitTop {
        //      fromTop = true
        //      destPos = .init(nearestRect.minX + nearestRect.width / 2 - compactPopupFrame.width / 2, nearestRect.minY - compactPopupFrame.height - padding)
        //    } else if fitBottom {
        //      fromTop = false
        //      destPos = .init(nearestRect.minX + nearestRect.width / 2 - compactPopupFrame.width / 2, nearestRect.maxY + padding)
        //    } else if fitLeft {
        //      destPos = .init(nearestRect.minX - compactPopupFrame.width - padding, superviewFrame.height / 2 - compactPopupFrame.height / 2)
        //    } else if fitRight {
        //      destPos = .init(nearestRect.maxX + padding, superviewFrame.height / 2 - compactPopupFrame.height / 2)
        //    } else {
        //      if pointOnTop {
        //        destPos = .init(nearestRect.minX + nearestRect.width / 2 - compactPopupFrame.width / 2, superviewFrame.maxY - compactPopupFrame.height - padding)
        //      } else {
        //        destPos = .init(nearestRect.minX + nearestRect.width / 2 - compactPopupFrame.width / 2, superviewFrame.minY + padding)
        //      }
        //    }
        
        //    let startPosY = fromTop ? -viewController.view.bounds.height / 2 : superview.bounds.height + viewController.view.bounds.height / 2
        
        destPos = CGPoint(x: min(superviewFrame.maxX - compactPopupFrame.width, max(destPos.x, superviewFrame.minX)),
                          y: min(superviewFrame.maxY - compactPopupFrame.height, max(destPos.y, superviewFrame.minY)))
        
        compactPopupFrame.origin = safeAreaPoint + destPos// - CGPoint(compactPopupFrame.width / 2, compactPopupFrame.height / 2)
        view.center = .init(compactPopupFrame.origin.x + compactPopupFrame.width / 2, compactPopupFrame.origin.y)
        //view.frame = compactPopupFrame
        superview.layoutIfNeeded()
        
        print("SourceFrame \(sourceFrame). DestFrame \(compactPopupFrame)")
        
        //UIView.transition(with: view, duration: 5, options: [.showHideTransitionViews, .transitionCrossDissolve], animations: nil, completion: nil)
        
        //    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseIn, animations: { [weak self] in
        //      guard let self = self else {return}
        //      //self.view.center = .init(sv.center.x, destPosY)
        //      self.viewController.view.frame = self.compactPopupFrame
        //      self.viewController.view.layoutIfNeeded()
        //    }, completion: nil)
    }
}
