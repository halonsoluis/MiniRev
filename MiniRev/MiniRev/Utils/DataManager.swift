//
//  DataManager.swift
//  MiniRev
//
//  Created by Hugo on 9/8/15.
//  Copyright © 2015 Hugo Alonso. All rights reserved.
//

import Foundation


final class DataManager: NSObject {
    
    /// The singleton reference.
    static let sharedInstance : DataManager = {
        return DataManager()
    }()
   
    /// The default social accounts address setted in the plist file.
    static var socialAccountsData: [String:String] {
        
        get {
            return DataManager._socialAccountsData
        }
    }
    private static var _socialAccountsData : [String:String] = {
        
        var socialAccounts = [String:String]()
        
        // Read from the Configuration plist the data.
        guard let path = NSBundle(forClass: DataManager.self).pathForResource("SocialAccounts", ofType: "plist") else {
            return [:]
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) else {
            return [:]
        }
        
        if let data = dict[destinationMail] as? String {
            socialAccounts[destinationMail] = data
        }
        if let data = dict[twitter_username] as? String {
            socialAccounts[twitter_username] = data
        }
        
        if let data = dict[facebook_pageId] as? String {
            socialAccounts[facebook_pageId] = data
        }
        if let data = dict[facebook_pageName] as? String {
            socialAccounts[facebook_pageName] = data
        }
        if let data = dict[faqPage] as? String {
            socialAccounts[faqPage] = data
        }
        if let data = dict[privacyPolicePage] as? String {
            socialAccounts[privacyPolicePage] = data
        }
        
        return socialAccounts
    }()
    /**
     A shortcut to obtain the predefined receipt
     
     - returns: the email to wich mail must be send
     */
    static func getEmailReceipt() -> String {
        let socialAccounts = _socialAccountsData
        if let email = socialAccounts[DataManager.destinationMail] {
            return email
        }
        return ""
    }
        
    private override init() {
        super.init()
        
    }
    
    /// MARK - literal Constants
    static let facebook_pageId = "facebook_pageId"
    static let destinationMail = "destinationMail"
    static let twitter_username = "twiiter_username"
    static let facebook_pageName = "facebook_pageName"
    static let faqPage = "faqPage"
    static let privacyPolicePage = "privacyPolicePage"
}