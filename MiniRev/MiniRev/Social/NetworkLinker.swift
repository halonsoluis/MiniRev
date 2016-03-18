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
        var scheme:String?
        var page:String = ""
        
        switch self {
        case .Facebook:
            if let faceBookPageId = SocialAccounts.facebook_pageId.obtainData(),
               let faceBookPageName = SocialAccounts.facebook_pageName.obtainData(){
               
                scheme = "fb://profile/\(faceBookPageId)"
                page = "https://www.facebook.com/\(faceBookPageName)"
            }
            
        case .Twitter:
            if let twitterUser = SocialAccounts.twitter_username.obtainData(){
                scheme = "twitter://user?screen_name=\(twitterUser)"
                page = "https://twitter.com/\(twitterUser)"
            }
            
        case .GooglePlus:
            if let PageId = SocialAccounts.gPlusPageId.obtainData(){
                scheme = "gplus://plus.google.com/u/0/\(PageId)"
                page = "https://plus.google.com/\(PageId)"
            }
        case .Instagram:
                if let instagramUser = SocialAccounts.instagram_username.obtainData(){
                    scheme = "instagram://user?username=\(instagramUser)"
                    page = "https://www.instagram.com/\(instagramUser)"
                }
            
        case .FAQPage:
            if let faqPage = SocialAccounts.faqPage.obtainData(){
                page = faqPage
            }
            
        case .PrivacyPolicePage:
            if let privacyPolicePage = SocialAccounts.privacyPolicePage.obtainData(){
                page = privacyPolicePage
            }
        }
        return NetworkUrl(scheme: scheme, page: page)
    }
    
    func openPage() {
        self.url().openPage()
    }
}