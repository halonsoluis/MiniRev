//
//  MailHandler.swift
//  MiniRev
//
//  Created by Hugo on 11/25/15.
//  Copyright © 2015 Hugo Alonso. All rights reserved.
//

import Foundation
import MessageUI

struct MailHandler {
    let receipts : [String]
    let subject: String
    let messageBody: String
    
    
    func sendMail(parentViewController: MFMailComposeViewControllerDelegate, wellDoneHandler: (()->Void)? = nil, canceledHandler: (()->Void)? = nil) {
        let mailComposeViewController = configuredMailComposeViewController(parentViewController)
        if let parentViewController = parentViewController as? UIViewController {
            if MFMailComposeViewController.canSendMail() {
                parentViewController.presentViewController(mailComposeViewController, animated: true, completion: nil)
                wellDoneHandler?()
            } else {
                showSendMailErrorAlert(parentViewController)
                canceledHandler?()
            }
            
        }
    }
    
    private func showSendMailErrorAlert(parentViewController: UIViewController) {
        let message = NSLocalizedString("sendMailError", comment: "Error Sending Email")
        let title = NSLocalizedString("sendMailErrorTitle", comment: "Error Sending Email")
        let sendMailErrorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        parentViewController.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    private func configuredMailComposeViewController(parentViewController: MFMailComposeViewControllerDelegate) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = parentViewController // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(receipts)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        
        return mailComposerVC
    }
}


extension UIViewController : MFMailComposeViewControllerDelegate {
    // MARK: MFMailComposeViewControllerDelegate Method
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}