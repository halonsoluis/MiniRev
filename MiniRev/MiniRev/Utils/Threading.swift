//
//  Threading.swift
//  MiniRev
//
//  Created by Hugo on 7/25/15.
//  Copyright (c) 2015 Hugo Alonso. All rights reserved.
//
import Foundation

/// Main queue of execution
private var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

/**
Allows to call a function after some time

- parameter delayInMilliSeconds: amount of time in milliseconds
- parameter scheduledTask:       the task to execute
*/
public func callFunctionWithDelay(delayInMilliSeconds:Int,scheduledTask: ()->Void){
    let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInMilliSeconds * 1000000)) // Calculates time to wait
    dispatch_after(popTime, GlobalMainQueue) { // Put on queue the exec of the function after popTime
        
        scheduledTask()
    }
}
/**
Allows to call a function asynchronously

- parameter asyncFunction: The function to call
*/
public func callFunctionAsync(asyncFunction: () -> Void){
    dispatch_async(GlobalMainQueue, asyncFunction)
}


public func lock(obj: AnyObject, blk:() -> ()) {
    objc_sync_enter(obj)
    blk()
    objc_sync_exit(obj)
}