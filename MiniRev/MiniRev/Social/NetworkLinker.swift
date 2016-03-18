//
//  SocialNetworkLinker.swift
//  MiniRev
//
//  Created by Hugo on 11/24/15.
//  Copyright © 2015 Hugo Alonso. All rights reserved.
//

import Foundation
import UIKit

struct NetworkUrl {
    let scheme: String?
    let page: String
    
    func openPage() {
        var url:NSURL?
        
        if let scheme = scheme where scheme != "" {
            if let schemeUrl = NSURL(string: scheme) {
                if UIApplication.sharedApplication().canOpenURL(schemeUrl) {
                    url = schemeUrl
                }
            }
        }else {
            url = NSURL(string: page)
        }
        
        if let url = url {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

enum NetworkLinker {
    case Facebook, Twitter, GooglePlus, Instagram, FAQPage, PrivacyPolicePage
    
    private func url() -> NetworkUrl {
        let socialAccounts = DataManager.socialAccountsData
        var scheme:String?
        var page:String = ""
        
        switch self {
        case .Facebook:
            if let faceBookPageId = socialAccounts[DataManager.facebook_pageId],
               let faceBookPageName = socialAccounts[DataManager.facebook_pageName]{
               
                scheme = "fb://profile/\(faceBookPageId)"
                page = "https://www.facebook.com/\(faceBookPageName)"
            }
            
        case .Twitter:
            if let twitterUser = socialAccounts[DataManager.twitter_username]{
                scheme = "twitter://user?screen_name=\(twitterUser)"
                page = "https://twitter.com/\(twitterUser)"
            }
            
        case .GooglePlus:
            if let PageId = socialAccounts[DataManager.gPlusPageId]{
                scheme = "gplus://plus.google.com/u/0/\(PageId)"
                page = "https://plus.google.com/\(PageId)"
            }
        case .Instagram:
                if let instagramUser = socialAccounts[DataManager.instagram_username]{
                    scheme = "instagram://user?username=\(instagramUser)"
                    page = "https://www.instagram.com/\(instagramUser)"
                }
            
        case .FAQPage:
            if let faqPage = socialAccounts[DataManager.faqPage]{
                page = faqPage
            }
            
        case .PrivacyPolicePage:
            if let privacyPolicePage = socialAccounts[DataManager.privacyPolicePage] {
                page = privacyPolicePage
            }
        }
        return NetworkUrl(scheme: scheme, page: page)
    }
    
    func openPage() {
        self.url().openPage()
    }
}