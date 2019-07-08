//
//  AnimatorFactory.swift
//  Widgets
//
//  Created by Jackson Ho on 7/8/19.
//  Copyright © 2019 Underplot ltd. All rights reserved.
//

import UIKit

class AnimatorFactory {
  
  static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
    let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)
    
    scale.addAnimations {
      view.alpha = 1
    }
    
    scale.addAnimations({
      view.transform = .identity
    }, delayFactor: 0.33)
    
    scale.addCompletion { (_) in
      print("ready")
    }
   
    return scale
  }
  
  static func jiggle(view: UIView) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, options: [], animations: {
      UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
        
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
          view.transform = CGAffineTransform(rotationAngle: -.pi / 8)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
          view.transform = CGAffineTransform(rotationAngle: +.pi / 8)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.0) {
          view.transform = CGAffineTransform.identity
        }
        
      }, completion: nil)
    }, completion: { _ in
      view.transform = .identity
    })
  }
  
  @discardableResult
  static func fade(effectView: UIVisualEffectView, visible: Bool) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
      effectView.alpha = visible ? 1 : 0
    }, completion: nil)
  }
}
