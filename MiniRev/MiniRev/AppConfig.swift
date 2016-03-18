//
//  AppConfig.swift
//  MiniRev
//
//  Created by Hugo Alonso on 3/18/16.
//  Copyright © 2016 halonso. All rights reserved.
//

import Foundation

enum AppConfig: String {
    case
    App_ID = "App_ID",
    Affiliate_Code = "Affiliate_Code",
    Campaign_Code = "Campaign_Code",
    AppName = "AppName"
  
    static let data = DataManager(configFile: "AppConfig").data
    
    func obtainData() -> String? {
        guard let data = self.dynamicType.data, let value = data[self.rawValue] else {
            return nil
        }
        return value
    }
}
