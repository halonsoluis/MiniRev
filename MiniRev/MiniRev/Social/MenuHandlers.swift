//
//  MenuHandlers.swift
//  MiniRev
//
//  Created by Hugo on 11/24/15.
//  Copyright © 2015 Hugo Alonso. All rights reserved.
//

import Foundation
import Social


enum SubjectOptions : String {
    case WhatIlove = "WhatIlove", Suggestions = "Suggestions", BugReport = "BugReport", Other = "Other", WhatIDontLike = "WhatIDontlove"
    
    static let allValues = [WhatIlove, Suggestions, BugReport, Other]
    
    func description() -> String{
        return NSLocalizedString(self.rawValue, comment: "Subject")
    }
}

enum MenuSocialHandlers {
    case Review, FAQ, PrivacyPolice, TwitterPage, FacebookPage
    
    func goTo() {
        switch self {
        case .FacebookPage: NetworkLinker.Facebook.openPage()
        case .TwitterPage: NetworkLinker.Twitter.openPage()
        case .Review: RatingHandler().rate()
        case .FAQ: NetworkLinker.FAQPage.openPage()
        case .PrivacyPolice: NetworkLinker.PrivacyPolicePage.openPage()
        }
    }
    
    static func shareInFacebookAboutMiniRev(parentViewController:UIViewController) {
        let vc = shareTheLove(SLServiceTypeFacebook)
        parentViewController.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    static func sendATwiitAboutMiniRev(parentViewController:UIViewController) {
        let vc = shareTheLove(SLServiceTypeTwitter)
        parentViewController.presentViewController(vc, animated: true, completion: nil)
    }
    
    private static func shareTheLove(socialNetwork: String) -> SLComposeViewController {
        let vc = SLComposeViewController(forServiceType: socialNetwork)
        vc.setInitialText(NSLocalizedString("check-out-beatune", comment: "Check out MiniRev"))
        //vc.addImage(detailImageView.image!)
        vc.addURL(NSURL(string: "https://itunes.apple.com/app/id\(RateDataManager.getAppID())"))
        return vc
    }
    
    static func sendMail(parentViewController: UIViewController) {
        let receipt = DataManager.getEmailReceipt()
        let receipts = [receipt]
        
        requestMailSubject(parentViewController) { subject in
            let mail = MailHandler(receipts: receipts, subject: subject, messageBody: "")
            mail.sendMail(parentViewController)
        }
    }
    
    static private func requestMailSubject(parentViewController: UIViewController, callBack: (String)->Void) {
        let sendUsEmail = NSLocalizedString("sendUsEmail", comment: "Subject")
        let alert = UIAlertController(title: "", message: sendUsEmail, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for subject in SubjectOptions.allValues{
            //Do something
            
            let bt_action = UIAlertAction(title: subject.description(), style: UIAlertActionStyle.Default) { (action) -> Void in
                callBack(subject.description())
            }
            alert.addAction(bt_action)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancel)
        parentViewController.presentViewController(alert, animated: true, completion: nil)
    }
}



