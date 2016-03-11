//
//  RateHandler.swift
//  MiniRev
//
//  Created by Hugo on 7/21/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//

import Foundation
import UIKit

/// Rate Functionalities handler
class RateHandler {
    /**
     Tries to redirect the user to the rate page, if success, marks the Rate to not appear anymore
     */
    static func goToRate() {
        
        if (RatingHandler().rate()) {
            RateDataManager.doNotPromptAnymore()
        }
    }
    /**
     This does nothing right now, variable and conditions reset are handled prior in RateDataManager
     */
    static func rememberToRate() {
    }
    /**
     Marks the Rate to not appear anymore
     */
    static func neverRate() {
        RateDataManager.doNotPromptAnymore()
    }
    /**
     Presents the RateDialog
     
     :param: parent the parent of the view to be shown
     */
    static func presentRateDialog(parent: UIViewController) {
        /// If there's no parent there's nothing to do
        //check for connectivity before trying to show the page and ask the RateDataManager if conditions have been meet
        if !Reachability.isConnectedToNetwork() || !RateDataManager.shouldPrompt() {
            return
        }
        //TODO: Add code here to show the view
        guard let rateVC = UIStoryboard(name: "ReviewFlow", bundle: NSBundle.mainBundle()).instantiateInitialViewController() else {
            return
        }
        
        
        
        rateVC.view.frame = CGRect(x: 0, y: -110, width: parent.view.frame.width, height: 110)
        parent.addChildViewController(rateVC)
        parent.view.addSubview(rateVC.view)
        
        let topBlackBorder = UIView(frame: CGRect(x: 0, y: 0, width: parent.view.frame.width, height: 20))
        topBlackBorder.backgroundColor = UIColor.blackColor()
        parent.view.addSubview(topBlackBorder)
        
        UIView.animateWithDuration(0.35) { () -> Void in
            rateVC.view.transform = CGAffineTransformTranslate(rateVC.view.transform, 0, 110)
        }
    }
    
    
}