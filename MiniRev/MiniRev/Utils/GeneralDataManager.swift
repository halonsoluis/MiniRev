//
//  DataManager.swift
//  MiniRev
//
//  Created by Hugo on 7/21/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//

public class GeneralDataManager {
    
    private var prefs: NSUserDefaults
    private var myDict: NSDictionary?
        //MARK: Singleton
    public static let instance = GeneralDataManager ()
    
    private convenience init() {
        self.init(userDefaults: NSUserDefaults.standardUserDefaults())
    }
    
    public func defaultDataIsLoaded() -> Bool {
        return myDict != nil
    }
    
    public func loadDefaults(configFileName: String, bundle: NSBundle?) -> GeneralDataManager {
        // Read from the Configuration plist the data to make the state of the object valid.
        if myDict != nil {return self}
        myDict = loadDefaultsDictionary(configFileName,bundle: bundle)
        return self
    }
    
    public func loadDefaultsDictionary(configFileName: String, bundle: NSBundle?) -> NSDictionary? {
        // Read from the Configuration plist the data to make the state of the object valid.
        if bundle == nil {
            print("bundle not found")
            return nil
        }
        let myDict : NSDictionary?
        if let path = bundle!.pathForResource(configFileName, ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }else {
            myDict = nil
        }
        return myDict
    }
    
    private init(userDefaults: NSUserDefaults) {
        self.prefs = userDefaults
    }
    
    public func getDetailsFromDict(locator: String) -> String? {
        if let myDict = myDict {
            return getDetailsFromSpecificDict(locator, dictionary: myDict)
        }
        return nil
    }
    
    public func getDetailsFromSpecificDict(locator: String, dictionary: NSDictionary) -> String? {
        if let data = dictionary[locator] as? String {
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
    public func loadData(locator: String) -> String? {
        let data: AnyObject? = loadAnyData(locator)
        
        if let _: AnyObject = data {
            let object = data as? String
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