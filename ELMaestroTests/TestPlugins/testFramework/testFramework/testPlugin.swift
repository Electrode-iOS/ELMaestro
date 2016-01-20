//
//  testClass.swift
//  testFramework
//
//  Created by Brandon Sneed on 6/17/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

import Foundation
import ELMaestro
import ELRouter

// this has to be Objc to cross the boundary of the framework.

@objc
public class TestPlugin: NSObject, PluggableFeature {
    public var identifier: String {
        return "com.walmartlabs.testplugin"
    }
    
    public var dependencies: [DependencyID]? {
        return ["com.walmartlabs.testObjcFramework"]
    }
    
    required public init?(containerBundleID: String?) {
        super.init()
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
