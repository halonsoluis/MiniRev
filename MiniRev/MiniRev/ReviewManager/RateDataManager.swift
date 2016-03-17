//
//  RateDataManager.swift
//  MiniRev
//
//  Created by Hugo on 7/21/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//

import Foundation

/// Handles all the logic about when to show the RateDialog
class RateDataManager {
    private static let debugMode = true
    // If false the conditions will not be evaluated since next restart of the app
    private static var shouldAsk = true
    // Loads the manager in charge of loading data from NSUserDefaults and Config files
    private static var _dataManager : GeneralDataManager?
    
    private static var dataManager: GeneralDataManager {
        if _dataManager == nil{
            _dataManager = GeneralDataManager.instance.loadPlistDictionary("RateConfig", bundle: locateBundle())
        }
        return _dataManager!
    }
    /**
     Asks if the conditions have been met
     
     :returns: true if the Rate Dialog should be presented to the user
     */
    static func shouldPrompt() -> Bool {
        
        guard !debugMode else {
            return true
        }
        
        // if conditions previously met in this session then do not show the RateDialog again
        guard shouldAsk else {
            return false
        }
        
        //if there is no data in the NSUserDefaults (then is the first time app has being opened), set initial data to start counting
        guard let prompt = dataManager.loadStringData(doNotShowRateDialogAnymore) else {
            dataManager.saveData(doNotShowRateDialogAnymore, object: "false")
            dataManager.saveData(timesAppHasBeingOpened, object: "1")
            
            //If conditions include time..
            if getDaysDelay() != -1 {
                let nextDate = NSDate().addNDays(getDaysDelay())
                dataManager.saveData(nextPromptLocator, object: nextDate.getString())
                
            }
            return false
        }
        
        // if the user has decided not to rate or has already rated the app then do not show the RateDialog again
        guard prompt != "true" else {
            shouldAsk = false
            if askForRateEveryVersion() &&  ratedVersionIsNotCurrent() {
                dataManager.saveData(doNotShowRateDialogAnymore, object: "false")
                dataManager.saveData(timesAppHasBeingOpened, object: "1")
            }
            return false
        }
     
        guard conditionOfMaxOfTimesAppHasBeingOpenedFromNotificationFulfilled() else {
            return false
        }
      
        guard conditionOfMaxOfTimesUserHasOpenedDataViewFulfilled() else {
            return false
        }

        /// If there is data in the NSUserDefaults
        guard let data = dataManager.loadStringData(timesAppHasBeingOpened) , let num = Int(data) else {
            return false
        }
        //if conditions include times opened and still not there..
        guard !(num != -1 && num < getTimesOpenedDelay()) else {
            //increase counter of times opened
            dataManager.saveData(timesAppHasBeingOpened, object: (num + 1).description)
            shouldAsk = false
            return false
        }
        
        //if conditions of times opened has being met...
        //If conditions include Date related ones...
        guard getDaysDelay() == -1 else {
            //Load next Date to ask for rating
            if let dateString = dataManager.loadStringData(nextPromptLocator) {
                let nextDate = NSDate(dateString: dateString)
                //if now is after that date
                if NSDate().isAfter(nextDate) {
                    //Add delay of days to the value stored to ask for it next time conditions are met if user taps on remember later
                    let dateString = nextDate.addNDays(getDaysDelay()).getString()
                    dataManager.saveData(nextPromptLocator, object: dateString)
                    // if conditions include times app is opened
                    if num != -1 {
                        //then condition has being met so, do not ask for it anymore in conditions evaluation
                        dataManager.saveData(timesAppHasBeingOpened, object: (-1).description)
                    }
                    shouldAsk = false
                    //The rate dialog should be presented
                    return true
                }
            }
            return false
        }
        
        //If conditions does not include Date related ones
        //Resets counter of times app has being opened to 0
        dataManager.removeData(Times_Opened_DataView)
        dataManager.removeData(Times_Opened_From_Notification)
        dataManager.saveData(timesAppHasBeingOpened, object: (0).description)
        shouldAsk = false
        //The rate dialog should be presented
        return true
    }
    
    private static func ratedVersionIsNotCurrent() -> Bool{
        return getLast_Rated_Version() != VersionUtils.getFullAppVersion()
    }
    
    static func ratedInPreviousVersion() -> Bool{
        return getLast_Rated_Version() == "" ? false : true
    }
    
    static func getLast_Rated_Version() -> String{
        if let ratedVersion = dataManager.loadStringData(Last_Rated_Version) {
            return ratedVersion
        }
        return ""
    }

    
    private static func conditionOfMaxOfTimesAppHasBeingOpenedFromNotificationFulfilled() -> Bool {
        return getTimesAppHasBeingOpenedFromNotification() > getReminder_Delay_In_Open_Notification()
    }
    
    private static func conditionOfMaxOfTimesUserHasOpenedDataViewFulfilled() -> Bool {
        return getTimesUserHasOpenedDataView() > getReminder_Delay_In_Open_DataView()
    }
    
    static func appHasBeingOpenedFromNotification() {
        guard let numberTimesData = dataManager.loadStringData(Times_Opened_From_Notification), let numberTimes = Int(numberTimesData) else {
            dataManager.saveData(Times_Opened_From_Notification, object: 1.description)
            return
        }
        dataManager.saveData(Times_Opened_From_Notification, object: (numberTimes + 1).description)
    }
    
    private static func getTimesUserHasOpenedDataView() -> Int {
        guard let numberTimesData = dataManager.loadStringData(Times_Opened_DataView), let numberTimes = Int(numberTimesData) else {
            return 0
        }
        return numberTimes
    }
    
    private static func getTimesAppHasBeingOpenedFromNotification() -> Int {
        guard let numberTimesData = dataManager.loadStringData(Times_Opened_From_Notification), let numberTimes = Int(numberTimesData) else {
            return 0
        }
        return numberTimes
    }
    
    static func userHasOpenedDataView() {
        guard let numberTimesData = dataManager.loadStringData(Times_Opened_DataView), let numberTimes = Int(numberTimesData) else {
            dataManager.saveData(Times_Opened_DataView, object: 1.description)
            return
        }
        dataManager.saveData(Times_Opened_DataView, object: (numberTimes + 1).description)
        
    }
    
    /**
     Sets conditions to never again show RateDialog, cleans out some resources
     */
    static func doNotPromptAnymore() {
        dataManager.saveData(doNotShowRateDialogAnymore, object: "true")
        dataManager.saveData(Last_Rated_Version, object: VersionUtils.getFullAppVersion())
        
        dataManager.removeData(nextPromptLocator)
        dataManager.removeData(timesAppHasBeingOpened)
        dataManager.removeData(Times_Opened_DataView)
        dataManager.removeData(Times_Opened_From_Notification)
        shouldAsk = false
    }
    
    static func getDaysDelay() -> Int{
        if let days = dataManager.getDetailsFromDict(Reminder_Delay_In_Days){
            if let days = Int(days) {
                return days
            }
        }
        //default value
        return 5
    }
    static func getReminder_Delay_In_Open_DataView() -> Int {
        if let days = dataManager.getDetailsFromDict(Reminder_Delay_In_Open_DataView){
            if let days = Int(days) {
                return days
            }
        }
        //default value
        return 5
    }
    static func getReminder_Delay_In_Open_Notification() -> Int{
        if let days = dataManager.getDetailsFromDict(Reminder_Delay_In_Open_Notification){
            if let days = Int(days) {
                return days
            }
        }
        //default value
        return 5
    }
    static func getTimesOpenedDelay() -> Int{
        if let num = dataManager.getDetailsFromDict(Reminder_Delay_In_Times_App_Opened){
            if let num = Int(num) {
                return num
            }
        }
        //default value
        return 5
    }
    static func getAppID() -> String{
        if let data = dataManager.getDetailsFromDict(App_ID){
            return data
            
        }
        //default value
        return ""
    }
    static func getAffiliateCode() -> String {
        if let data = dataManager.getDetailsFromDict(Affiliate_Code){
            return data
            
        }
        //default value
        return ""
    }
    static func getCampaignCode() -> String{
        if let data = dataManager.getDetailsFromDict(Campaign_Code){
            return data
        }
        //default value
        return ""
    }
    
    static func askForRateEveryVersion() -> Bool{
        if let data = dataManager.getDetailsFromDict(AskRateInEveryVersion){
            return data == "false" ? false : true
        }
        //default value
        return true
    }
    
    static func getAppStoreUrl() -> String{
        if let data = dataManager.getDetailsFromDict(App_Store_URL){
            return data.stringByReplacingOccurrencesOfString("APP_ID", withString: getAppID(), options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        //default value
        return "itms-apps://itunes.apple.com/app/id\(getAppID())"
    }
    static func getAppStoreRateUrl() -> String{
        if let data = dataManager.getDetailsFromDict(App_Store_Rate_URL){
            return data.stringByReplacingOccurrencesOfString("APP_ID", withString: getAppID(), options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        //default value
        return "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=\(getAppID())"
    }
    
    static func locateBundle() -> NSBundle {
        return NSBundle(forClass: RateDataManager.self)
    }
    
    //MARK: Locators
    
    //NSUSERDefaults
    
    private static let nextPromptLocator = "nextPromptLocator"
    private static let doNotShowRateDialogAnymore = "doNotShowRateDialogAnymore"
    private static let timesAppHasBeingOpened = "timesAppHasBeingOpened"
    private static let Last_Rated_Version = "Last_Rated_Version"
    private static let Times_Opened_From_Notification = "Times_Opened_From_Notification"
    private static let Times_Opened_DataView = "Times_Opened_DataView"
    
    //Config File
    private static let Reminder_Delay_In_Days = "Reminder_Delay_In_Days"
    private static let Reminder_Delay_In_Times_App_Opened = "Reminder_Delay_In_Times_App_Opened"
    private static let App_ID = "App_ID"
    private static let Affiliate_Code = "Affiliate_Code"
    private static let Campaign_Code = "Campaign_Code"
    private static let App_Store_Rate_URL = "App_Store_Rate_URL"
    private static let App_Store_URL = "App_Store_URL"
    private static let AskRateInEveryVersion = "AskRateInEveryVersion"
    
    private static let Reminder_Delay_In_Open_Notification = "Reminder_Delay_In_Open_Notification"
    private static let Reminder_Delay_In_Open_DataView = "Reminder_Delay_In_Open_DataView"
    
   
    
}