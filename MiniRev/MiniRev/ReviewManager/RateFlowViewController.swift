//
//  RateFlowViewController.swift
//  MiniRev
//
//  Created by Hugo on 12/22/15.
//  Copyright © 2015 Hugo Alonso. All rights reserved.
//

import Foundation
import UIKit

class RateFlowViewController: UIViewController {
    
    @IBOutlet weak var firstPageTitle: UILabel!
    @IBOutlet weak var giveAReviewTitle: UILabel!
    @IBOutlet weak var sendMailTitle: UILabel!
    @IBOutlet weak var appNamed: UILabel!
    
    override func viewDidLoad() {
        appNamed?.text = RateDataManager.getAppName()
    }
  
    @IBAction func prepareForFeedBack(sender: AnyObject) {
        guard let parentViewController = self.parentViewController?.parentViewController else {
            return
        }
        removeReview() {
        
        let receipt = SocialAccounts.getEmailReceipt()
        let receipts = [receipt]
        let subject = NSLocalizedString(SubjectOptions.WhatIDontLike.rawValue, comment: "Subject")
        let mail = MailHandler(receipts: receipts, subject: subject, messageBody: "")
            mail.sendMail(parentViewController) {
                RateHandler.neverRate()
            }
        }
    }
    
    @IBAction func goToAppStore(sender: AnyObject) {
        removeReview(){
             RateHandler.goToRate()
        }
    }
    
    @IBAction func remindmeLater(sender: AnyObject) {
        removeReview()
    }
    
    func removeReview(doneCallBack: (()->Void)?=nil) {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -110)
            }) { (_) -> Void in
                //self.view.removeFromSuperview()
                
                if let parent = self.parentViewController {
                    parent.removeFromParentViewController()
                }
                //self.removeFromParentViewController()
                
                doneCallBack?()
        }
    }
}
