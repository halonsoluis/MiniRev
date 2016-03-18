//
//  SocialAccount.swift
//  MiniRev
//
//  Created by Hugo Alonso on 3/18/16.
//  Copyright © 2016 halonso. All rights reserved.
//

import Foundation

enum SocialAccounts: String {
    case
    facebook_pageId = "facebook_pageId",
    destinationMail = "destinationMail",
    twitter_username = "twiiter_username",
    facebook_pageName = "facebook_pageName",
    faqPage = "faqPage",
    privacyPolicePage = "privacyPolicePage",
    instagram_username = "instagram_username",
    gPlusPageId = "gPlusPageId"
    
    static let data = DataManager(configFile: "SocialAccounts").data
    
    func obtainData() -> String? {
        guard let data = self.dynamicType.data, let value = data[self.rawValue] else {
            return nil
        }
        return value
    }
    /**
     A shortcut to obtain the predefined receipt
     
     - returns: the email to wich mail must be send
     */
    static func getEmailReceipt() -> String {
        guard let value = SocialAccounts.destinationMail.obtainData() else {
            return ""
        }
       return value
    }
}