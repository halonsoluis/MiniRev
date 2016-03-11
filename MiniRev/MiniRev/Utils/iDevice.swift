//
//  iDevice.swift
//  MiniRev
//
//  Created by Hugo on 7/25/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//
import UIKit

public func isRunningOnIphone()-> Bool{
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
        return true
    }
    return false
}