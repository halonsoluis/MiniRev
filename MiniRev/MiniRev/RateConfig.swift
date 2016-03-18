//
//  RateConfig.swift
//  MiniRev
//
//  Created by Hugo Alonso on 3/18/16.
//  Copyright © 2016 halonso. All rights reserved.
//

import Foundation

enum RateConfig: String {
    case
    App_Store_Rate_URL = "App_Store_Rate_URL",
    App_Store_URL = "App_Store_URL",
    AskRateInEveryVersion = "AskRateInEveryVersion",
    debugMode = "debugMode"
    
    private static let configFile = "RateConfig"
    static let data = DataManager(configFile: configFile).data
    
    func obtainData() -> String {
        guard let data = self.dynamicType.data, let value = data[self.rawValue] else {
            if let value = DataManager(configFile: self.dynamicType.configFile, defaults: true).data?[self.rawValue] {
                return value
            }
            return ""
        }
        return value
    }
}
