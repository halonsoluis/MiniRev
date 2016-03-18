//
//  DataManager.swift
//  MiniRev
//
//  Created by Hugo on 9/8/15.
//  Copyright © 2015 Hugo Alonso. All rights reserved.
//

import Foundation


final class DataManager: NSObject {
    /// The default social accounts address setted in the plist file.
    let data: [String:String]?
   
   
    init(configFile: String) {
        data = GeneralDataManager.locatePlistFile(configFile) as? [String : String]
   /*
        guard data != nil else {
            return nil
        }
*/
    }
    
 
}