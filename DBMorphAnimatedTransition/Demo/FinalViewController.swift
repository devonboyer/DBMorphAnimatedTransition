//
//  FinalViewController.swift
//  DBMorphAnimatedTransition
//
//  Created by Devon Boyer on 2015-02-04.
//  Copyright (c) 2015 Devon Boyer. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController, DBMorphAnimatedTransitionViewSource {
    
    @IBAction func closeTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func viewForMorphTransition() -> UIView! {
        return navigationController?.navigationBar
    }
}
