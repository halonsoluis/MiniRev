//
//  DataManager.swift
//  MiniRev
//
//  Created by Hugo on 7/21/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//
import Foundation
/// Handler for writing/reading from standard NSUserDefauls / plist files
public class GeneralDataManager {
    //MARK: vars & Singleton instance
    var prefs: NSUserDefaults
    var myDict: NSDictionary?
    
    //MARK: Private Init
    private convenience init() {
        self.init(userDefaults: NSUserDefaults.standardUserDefaults())
    }
    public init(userDefaults: NSUserDefaults) {
        self.prefs = userDefaults
    }
    //MARK: Loading of Plist Dictionaries
    public func defaultDataIsLoaded() -> Bool {
        return myDict != nil
    }
    
    public static func buildDataManager(userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults(), plistConfigFileName: String? = nil, bundle: NSBundle? = nil) -> GeneralDataManager {
        let dataManager = GeneralDataManager(userDefaults: userDefaults)
        
        guard let plistConfigFileName = plistConfigFileName else {
            return dataManager
        }
        
        dataManager.loadPlistDictionary(plistConfigFileName, bundle: bundle)
        
        return dataManager
    }
   
    public func loadPlistDictionary(configFileName: String, bundle: NSBundle?) -> GeneralDataManager {
        // Read from the Configuration plist the data to make the state of the object valid.
        guard myDict == nil else {return self}
        guard bundle != nil else {
            myDict = GeneralDataManager.locatePlistFile(configFileName)
            return self
        }
        myDict = GeneralDataManager.locatePlistFile(configFileName,bundle: bundle)
        return self
    }
    

    //Extract Data from Plist Dictionaries
    public func getDetailsFromDict(locator: String) -> String? {
        if let myDict = myDict {
            return getDetailsFromSpecificDict(locator, dictionary: myDict)
        }
        return nil
    }
    
    public func getArrayDetailsFromDict(locator: String) -> Array<String>? {
        if let myDict = myDict {
            return getArrayDetailsFromSpecificDict(locator, dictionary: myDict)
        }
        return nil
    }
    
    public func getDetailsFromSpecificDict(locator: String, dictionary: NSDictionary) -> String? {
        if let data = dictionary[locator] as? String {
            return data
        }
        return nil
    }
    
    public func getArrayDetailsFromSpecificDict(locator: String, dictionary: NSDictionary) -> Array<String>? {
        if let data = dictionary[locator] as? Array<String> {
            return data
        }
        return nil
    }
    
    
    //MARK: Functions to Handle Store and Retrieve of data from NSUserDefaults
    ///function to save data to NSUserDefaults
    public func saveData(locator: String, object: AnyObject){
        let objectEncoded = NSKeyedArchiver.archivedDataWithRootObject(object)
        prefs.setObject(objectEncoded, forKey: locator)
        prefs.synchronize()
    }
    
    ///function to remove data from NSUserDefaults
    public func removeData(locator: String){
        prefs.removeObjectForKey(locator)
        prefs.synchronize()
    }
    
    ///function to load data from NSUserDefaults
    public func loadStringData(locator: String) -> String? {
        let data: AnyObject? = loadAnyData(locator)
        
        if let _: AnyObject = data {
            let object = data as? String
            return object
        }
        return nil
    }
    
    ///function to load data from NSUserDefaults
    public func loadStringArrayData(locator: String) -> Array<String>? {
        let data: AnyObject? = loadAnyData(locator)
        
        if let _: AnyObject = data {
            let object = data as? Array<String>
            return object
        }
        return nil
    }
    
    ///function to load data from NSUserDefaults
    public func loadStringArrayDataConfig(locator: String) -> Array<String>? {
        let data: AnyObject? = loadAnyData(locator)
        
        if let _: AnyObject = data {
            let object = data as? Array<String>
            return object
        }
        return nil
    }
    
    /**
     General function to load any type of data from an NSUserDefaults
     
     - parameter locator: the locator for desired to load data
     
     - returns: the data loaded
     */
    private func loadAnyData(locator: String) -> AnyObject?{
        let data: AnyObject? = prefs.objectForKey(locator)
        
        if let encodedData: AnyObject = data {
            let object: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData as! NSData)
            return object
        }
        return nil
    }
    
}

//MARK: Search for Plist File
extension GeneralDataManager {
    //Obtain current Bundle, the one of this class
    private static func currentBundle() -> NSBundle {
        return NSBundle(forClass: self)
    }
    /**
     Search for Plist File, first at main bundle (or another specified by user) and then in current bundle
     
     - parameter fileName: plis file name (whithout extension)
     - parameter bundle:   leave empty for search in main bundle, modify to check in another
     
     - returns: the dictionary extracted from the bundle
     */
    static func locatePlistFile(fileName: String, bundle: NSBundle? = NSBundle.mainBundle()) -> NSDictionary? {
        guard let bundle = bundle else {
            return nil
        }
        
        guard let path = bundle.pathForResource(fileName, ofType: "plist") else {
            print("fallback to bundle's plist file, No plist found in bundle: \(bundle.bundleIdentifier!)")
            return locatePlistFile(fileName, bundle: currentBundle())
        }
        guard let dict = NSDictionary(contentsOfFile: path) else {
            return nil
        }
        return dict
    }
    
}