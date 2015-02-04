//
//  DBMorphTransitionAnimator.swift
//  DBMorphAnimatedTransition
//
//  Created by Devon Boyer on 2015-02-04.
//  Copyright (c) 2015 Devon Boyer. All rights reserved.
//

import UIKit

@objc protocol DBMorphAnimatedTransitionViewSource {
    
    func viewForMorphTransition() -> UIView!
}

class DBMorphTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.7
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        // A little special treatment if the toVC or fromVC is a navigation controller, this really only applies during modal transitions where the fromVC and toVC do not implicitly return the topViewController like a push transition does
        var initialView: UIView!
        if fromViewController is UINavigationController {
            initialView = ((fromViewController as UINavigationController).topViewController as DBMorphAnimatedTransitionViewSource).viewForMorphTransition()
        } else {
            initialView = (fromViewController as DBMorphAnimatedTransitionViewSource).viewForMorphTransition()
        }

        var finalView: UIView!
        if toViewController is UINavigationController {
            finalView = ((toViewController as UINavigationController).topViewController as DBMorphAnimatedTransitionViewSource).viewForMorphTransition()
        } else {
            finalView = (toViewController as DBMorphAnimatedTransitionViewSource).viewForMorphTransition()
        }
        
        // We are going to need to create a "copy" of the view that the animation will act on
        let animatingView = UIView(frame: initialView.frame)
        animatingView.backgroundColor = initialView.backgroundColor
        animatingView.layer.cornerRadius = initialView.layer.cornerRadius
        animatingView.clipsToBounds = initialView.clipsToBounds
        
        // Add the toViewController's view as well as the animating view to the container view
        containerView.addSubview(toViewController.view)
        containerView.addSubview(animatingView)
        
        // Hide the initial view while animating
        initialView.hidden = true
        finalView.alpha = 0.01 // prevents changing the topLayoutGuide and shifting the view
        
        /*
         * Step 1
         */
        
        toViewController.view.frame = CGRectOffset(toViewController.view.frame, 0, containerView.frame.height)
        UIView.animateWithDuration(transitionDuration(transitionContext) / 2.0 , animations: { () -> Void in
            toViewController.view.frame = containerView.bounds
        })
        
        /*
         * Step 2
         */
        
        // Create the path for the initialView to animate to the finalView
        let path = UIBezierPath()
        path.moveToPoint(animatingView.center)
        path.addQuadCurveToPoint(finalView.center, controlPoint: CGPoint(x: containerView.frame.width / 2, y: containerView.frame.height))
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            
            /*
             * Step 4
             */
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                finalView.layer.mask.removeAllAnimations()
                finalView.layer.mask = nil
                initialView.hidden = false
                transitionContext.completeTransition(true)
            })
            
            animatingView.removeFromSuperview()
            finalView.alpha = 1.0

            var circleMaskPathInital = UIBezierPath(ovalInRect: animatingView.frame)
            var radius = containerView.bounds.width / 2.0
            var circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(animatingView.frame, -radius, -radius))
            
            var maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.CGPath
            finalView.layer.mask = maskLayer
            
            var maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInital.CGPath
            maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
            maskLayerAnimation.duration =
                self.transitionDuration(transitionContext) / 2.0
            maskLayerAnimation.delegate = self
            maskLayer.addAnimation(maskLayerAnimation, forKey: "maskAnimation")
            CATransaction.commit()
        }
        animatingView.center = finalView.center
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = transitionDuration(transitionContext) / 2.0
        pathAnimation.path = path.CGPath
        animatingView.layer.addAnimation(pathAnimation, forKey: "pathAnimation")
        CATransaction.commit()
    }
}
