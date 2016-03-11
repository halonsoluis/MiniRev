//
//  Application.swift
//  MiniRev
//
//  Created by Hugo on 9/1/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//

class VersionUtils {

/**
Asks main bundle about current version build

- returns: build number for current version _._.X
*/
static func getBuildVersion()->String {
    return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
}

/**
Asks main bundle about current version

- returns: version number X.X
*/
static func getShortAppVersion()->String {
   return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
}

/**
Asks main bundle about version and current build of this app

- returns: version number X.X.X
*/
static func getFullAppVersion()->String {
    return "\(getShortAppVersion()).\(getBuildVersion())"
}

}