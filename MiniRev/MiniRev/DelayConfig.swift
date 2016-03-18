//
//  DelayConfig.swift
//  MiniRev
//
//  Created by Hugo Alonso on 3/18/16.
//  Copyright © 2016 halonso. All rights reserved.
//

import Foundation

enum DelayConfig: String {
    case
    //Config File
    Delay_In_Days = "Delay_In_Days",
    Delay_In_Times_App_Tried_To_Show_Rev = "Delay_In_Times_App_Tried_To_Show_Rev",
    Delay_In_Criteria_A = "Delay_In_Criteria_A",
    Delay_In_Criteria_B = "Delay_In_Criteria_B"
    
    private static let configFile = "DelayConfig"
    
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
