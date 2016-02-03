//
//  MockNSNotificationCenter.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 03/02/2016.
//  Copyright © 2016 Edina. All rights reserved.
//  Copied from http://codingtopher.co.uk/post/98837177572/swift-using-and-testing-notifications

import Foundation

class MockNSNotificationCenter: NSNotificationCenter {
    
    var observerCount = 0
    
    var postCount = 0
    
    var lastPostedNotificationName:String?
    
    override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
        
        observerCount++
        
    }
    
    override func postNotificationName(aName: String?, object anObject: AnyObject?) {
        
        lastPostedNotificationName = aName!
        
        postCount++
        
    }
    
}

