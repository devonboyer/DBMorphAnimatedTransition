//
//  InitialViewController.swift
//
//
//  GitHub
//  https://github.com/DevonBoyer/DBMorphAnimatedTransition
//
//
//  Created by Devon Boyer on 2015-02-04.
//  Copyright (c) 2015 Devon Boyer. All rights reserved.
//
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

class InitialViewController: UIViewController, UIViewControllerTransitioningDelegate, DBMorphAnimatedTransitionViewSource {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)

    }
    
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

