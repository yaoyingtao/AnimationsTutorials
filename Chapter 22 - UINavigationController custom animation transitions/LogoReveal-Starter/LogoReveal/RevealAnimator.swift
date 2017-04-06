//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by yaoyt on 2017/4/6.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate {
    let animationDuration = 2.0;
    var operation: UINavigationControllerOperation = .push
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration;
    }
    

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
        
        storedContext = transitionContext;
        
        let fromVC = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.from) as! MasterViewController;
        let toVC = transitionContext.viewController(forKey:UITransitionContextViewControllerKey.to) as! DetailViewController
        
        transitionContext.containerView.addSubview(toVC.view);
        
        let animation = CABasicAnimation(keyPath: "transform");
        animation.duration = animationDuration;
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity);
        animation.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, -10, 0), CATransform3DMakeScale(150, 150, 1)));
        animation.delegate = self;
        animation.fillMode = kCAFillModeForwards;
        animation.isRemovedOnCompletion = false;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);
        
        toVC.maskLayer.add(animation, forKey: nil);
        fromVC.logo.add(animation, forKey: nil);
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0;
        fadeIn.toValue = 1.0;
        fadeIn.duration = animationDuration;
        toVC.view.layer.add(fadeIn, forKey: nil);
        } else {
            let fromVC = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.from) as! DetailViewController;
            let toVC = transitionContext.viewController(forKey:UITransitionContextViewControllerKey.to) as! MasterViewController
            
            transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view);
            
            UIView.animate(withDuration: animationDuration, animations: { 
                fromVC.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
            }, completion: { _ in
                transitionContext.completeTransition(true);
            })
            
        }
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
            let fromVC = context.viewController( forKey: UITransitionContextViewControllerKey.from) as! MasterViewController
            fromVC.logo.removeAllAnimations()
        }
        storedContext = nil
    }
}
