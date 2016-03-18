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
    
    static let data = DataManager(configFile: "RateConfig").data
    
    func obtainData() -> String? {
        guard let data = self.dynamicType.data, let value = data[self.rawValue] else {
            return nil
        }
        return value
    }
}
