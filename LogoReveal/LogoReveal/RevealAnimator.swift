//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Jackson Ho on 6/26/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
  let animationDuration = 0.5
  var operation: UINavigationController.Operation = .push
  weak var storeContext: UIViewControllerContextTransitioning?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    storeContext = transitionContext
    if operation == .push {
      let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
      let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController
      
      transitionContext.containerView.addSubview(toVC.view)
      toVC.view.frame = transitionContext.finalFrame(for: toVC)
      
      let animation = CABasicAnimation(keyPath: "transform")
      animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
      animation.toValue = NSValue(caTransform3D: CATransform3DConcat(
        CATransform3DMakeTranslation(0.0, -10.0, 0.0),
        CATransform3DMakeScale(150.0, 150.0, 1.0)
      ))
      
      animation.duration = animationDuration
      animation.delegate = self
      animation.fillMode = .forwards
      animation.isRemovedOnCompletion = false
      animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
      
      let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
      maskLayer.position = fromVC.logo.position
      toVC.view.layer.mask = maskLayer
      maskLayer.add(animation, forKey: nil)
      fromVC.logo.add(animation, forKey: nil)
      
      toVC.view.layer.opacity = 0
      let fadeIn = CABasicAnimation(keyPath: "opacity")
      fadeIn.duration = animationDuration
      fadeIn.fromValue = 0
      fadeIn.toValue = 1
      toVC.view.layer.add(fadeIn, forKey: nil)
    } else {
      let fromVC = transitionContext.view(forKey: .from)!
      let toVC = transitionContext.view(forKey: .to)!
      let containerView = transitionContext.containerView
      containerView.insertSubview(toVC, belowSubview: fromVC)
      
      UIView.animate(withDuration: animationDuration, animations: {
        fromVC.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        fromVC.alpha = 0.5
      }, completion: { (_) in
        transitionContext.completeTransition(true)
      })
    }
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if let context = storeContext {
      context.completeTransition(!context.transitionWasCancelled)
      let fromVC = context.viewController(forKey: .from) as! MasterViewController
      fromVC.logo.removeAllAnimations()
      let toVC = context.viewController(forKey: .to) as! DetailViewController
      toVC.view.layer.mask = nil
      toVC.view.layer.opacity = 1
    }
    storeContext = nil
  }
}

