//
//  FinalViewController.swift
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

class FinalViewController: UIViewController, DBMorphAnimatedTransitionViewSource {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func viewForMorphTransition() -> UIView! {
        return navigationController?.navigationBar
    }
}
