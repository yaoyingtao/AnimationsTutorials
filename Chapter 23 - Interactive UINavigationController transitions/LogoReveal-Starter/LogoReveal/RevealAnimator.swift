//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Marin Todorov on 1/15/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning,CAAnimationDelegate {

  let animationDuration = 2.0
  var operation: UINavigationControllerOperation = .push

  weak var storedContext: UIViewControllerContextTransitioning?
    var interactive = false
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    storedContext = transitionContext
    
    if operation == .push {
      
      let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! MasterViewController
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DetailViewController
      
      transitionContext.containerView.addSubview(toVC.view)

      let animation = CABasicAnimation(keyPath: "transform")
      
      animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
      animation.toValue = NSValue(caTransform3D:
        CATransform3DConcat(
          CATransform3DMakeTranslation(0.0, -10.0, 0.0),
          CATransform3DMakeScale(150.0, 150.0, 1.0)
        )
      )

      animation.duration = animationDuration
      animation.delegate = self
      animation.fillMode = kCAFillModeForwards
      animation.isRemovedOnCompletion = false
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

      toVC.maskLayer.add(animation, forKey: nil)
      fromVC.logo.add(animation, forKey: nil)
      
      let fadeIn = CABasicAnimation(keyPath: "opacity")
      fadeIn.fromValue = 0.0
      fadeIn.toValue = 1.0
      fadeIn.duration = animationDuration
      toVC.view.layer.add(fadeIn, forKey: nil)
    } else {
      
      let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
      let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
      
      transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
      
      UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
        fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: {_ in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
      
    }
  }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
      
      if let context = storedContext {
        context.completeTransition(!context.transitionWasCancelled)
        
        //reset logo
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as! MasterViewController
        fromVC.logo.removeAllAnimations()
      }
      
      storedContext = nil
  }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation( in: recognizer.view!.superview!)
        var progress: CGFloat = abs(translation.x / 200.0);
        progress = min(max(progress, 0.01), 0.99)
        switch recognizer.state {
        case .changed:
            update(progress)
            break;
        case .cancelled, .ended:
            let transitionLayer = storedContext?.containerView.layer
            transitionLayer?.beginTime = CACurrentMediaTime()
            if progress < 0.5 {
                completionSpeed = -1.0
                cancel()
            } else {
                completionSpeed = 1.0
                finish()
            }
            interactive = false
        default:
            break
        }
    }
  
}
