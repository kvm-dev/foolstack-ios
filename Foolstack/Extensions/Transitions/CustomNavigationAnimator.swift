//
//  CustomNavigationAnimator.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.01.2024.
//

import Foundation
import UIKit

class CustomNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  var operation: UINavigationController.Operation = .push
  
  init(operation: UINavigationController.Operation) {
    self.operation = operation
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    TimeInterval(0.35)//UINavigationController.hideShowBarDuration)
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // 4
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }
    
    // 5
    let duration = transitionDuration(using: transitionContext)
    
    // 6
    let container = transitionContext.containerView

    let presenting = operation == .push
    if presenting {
      container.addSubview(toView)
    } else {
      container.insertSubview(toView, belowSubview: fromView)
    }
    
    // 7
    let toViewFrame = toView.frame
    toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width, y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)

      toView.alpha = 0
    let animations = {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.8) {
        toView.alpha = 1
      }
      UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
        fromView.alpha = 0.0
      }

      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
        toView.frame = toViewFrame
        fromView.frame = CGRect(x: presenting ? -fromView.frame.width : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
      }
      
    }
    
    let anim = UIViewPropertyAnimator(
      duration: duration, timingParameters: UICubicTimingParameters(animationCurve: presenting ? .easeOut : .easeIn))
    anim.addAnimations {
      UIView.animateKeyframes(withDuration: 0,
                              delay: 0,
                              options: [],//.calculationModeCubic,
                              animations: animations,
                              completion: { finished in
        // 8
        container.addSubview(toView)
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
    anim.startAnimation()
  }
  
  func animationEnded(_ transitionCompleted: Bool) {
    //print("ended") // called twice?? I've no idea why but no harm done
    // cleanup!
    //self.anim = nil
  }
  
}
