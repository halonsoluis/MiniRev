//
//  DateExtensions.swift
//  MiniRev
//
//  Created by Hugo on 6/7/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//

extension NSDate {
    
    //NSString to NSDate
    public convenience init(dateString:String) {
        let nsDateFormatter = NSDateFormatter()
        nsDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        nsDateFormatter.locale = NSLocale.currentLocale()
        
        let dateObj = nsDateFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:dateObj!)
    }
    
    //NSDate to String
    public func getString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.locale = NSLocale.currentLocale()
        
        return dateFormatter.stringFromDate(self)
    }
    
    public func addNDays(ndays: Int) -> NSDate{
        let dayComponenet = NSDateComponents()
        dayComponenet.day = ndays
        
        let theCalendar = NSCalendar.currentCalendar()
        return theCalendar.dateByAddingComponents(dayComponenet, toDate: self, options: [])!
    }
    
    public func isAfter(otherDate: NSDate) -> Bool {
        let result  = self.compare(otherDate)
        switch result {
        case NSComparisonResult.OrderedDescending:
            return true
        default:
            return false
        }
    }
}