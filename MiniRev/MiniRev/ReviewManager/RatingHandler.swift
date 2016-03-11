//
//  RatingUtils.swift
//  MiniRev
//
//  Created by Hugo on 7/15/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//

import Foundation
import UIKit


class RatingHandler {
    private let APP_ID : String
    private let AFFILIATE_CODE : String
    private let AFFILIATE_CAMPAIGN_CODE : String
    
    private var url_pattern: String {
        var url = RateDataManager.getAppStoreRateUrl()
        
        if AFFILIATE_CODE != "" {
            url = url.stringByAppendingString("&at=\(AFFILIATE_CODE)")
        }
        if AFFILIATE_CAMPAIGN_CODE != "" {
            url = url.stringByAppendingString("&ct=\(AFFILIATE_CAMPAIGN_CODE)")
        }
        return url
    }
    /**
     Loads Data from the RateConfig.plist file regarding app details to proceed to Rate
     
     :param: rootController  the parent of the StoreKit view -Not ready, Do not use
     
     :returns: a ready to call **func rate()** instance of **RatingHandler**
     */
    init(){
        APP_ID = RateDataManager.getAppID()
        AFFILIATE_CODE = RateDataManager.getAffiliateCode()
        AFFILIATE_CAMPAIGN_CODE = RateDataManager.getCampaignCode()
    }
    
    /**
     Redirects the user to the rate facilities of itunesStore
     
     :returns: true if success
     */
    func rate() -> Bool {
        return navigateToUrl()
    }
    
    private func navigateToUrl() -> Bool {
        if let url = NSURL(string: url_pattern) {
            if Reachability.isConnectedToNetwork() && UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
                return true
            }
        }
        return false
    }
}