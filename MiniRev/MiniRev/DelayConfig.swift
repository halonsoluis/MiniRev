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
    Reminder_Delay_In_Days = "Reminder_Delay_In_Days",
    Reminder_Delay_In_Times_App_Opened = "Reminder_Delay_In_Times_App_Opened",
    Reminder_Delay_In_Open_Notification = "Reminder_Delay_In_Open_Notification",
    Reminder_Delay_In_Open_DataView = "Reminder_Delay_In_Open_DataView"
    
    static let data = DataManager(configFile: "DelayConfig").data
    
    func obtainData() -> String? {
        guard let data = self.dynamicType.data, let value = data[self.rawValue] else {
            return nil
        }
        return value
    }
}
