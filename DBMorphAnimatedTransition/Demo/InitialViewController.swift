//
//  InitialViewController.swift
//  DBMorphAnimatedTransition
//
//  Created by Devon Boyer on 2015-02-04.
//  Copyright (c) 2015 Devon Boyer. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UIViewControllerTransitioningDelegate, DBMorphAnimatedTransitionViewSource {
    
    @IBOutlet weak var button: UIButton!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "modalSegue" {
            let destination = segue.destinationViewController as UIViewController
            destination.modalPresentationStyle = .Custom
            destination.transitioningDelegate = self
        }
    }

    func viewForMorphTransition() -> UIView! {
        return button
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DBMorphTransitionAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }

}

