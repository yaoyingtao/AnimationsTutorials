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
        if operation != .push {
            return;
        }
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
