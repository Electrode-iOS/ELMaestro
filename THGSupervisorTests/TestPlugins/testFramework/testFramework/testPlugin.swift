//
//  testClass.swift
//  testFramework
//
//  Created by Brandon Sneed on 6/17/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

import Foundation
import THGSupervisor

// this has to be Objc to cross the boundary of the framework.

@objc
public class TestPlugin: NSObject, PluggableFeature {
    public var identifier: String {
        return "io.theholygrail.testplugin"
    }
    
    public var dependencies: [NSBundle]? { return nil }
    
    public func initializeForContainer(containedBundleID: String?) {
        print(containedBundleID)
    }
    
    // Provides the default route to this plugin or feature.
    public func startup(supervisor: Supervisor) -> Route? {
        return nil
    }
    
    /**
    URL Handling
    */
    public func routeForURL(url: NSURL) -> Route? {
        return nil
    }
    
    /**
    Notification handling
    */
    public func routeForLocalNotification(notification: UILocalNotification) -> Route? {
        return nil
    }
    
    public func routeForRemoteNotification(userInfo: [NSObject : AnyObject]) -> Route? {
        return nil
    }
    
    /**
    Application lifecycle events
    */
    public func applicationWillTerminate() {
        
    }
    
    public func applicationDidReceiveMemoryWarning() {
        
    }
}
