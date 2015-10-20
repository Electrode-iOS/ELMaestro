//
//  Plugin.swift
//  THGSupervisor
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 theholygrail. All rights reserved.
//

import Foundation
import UIKit

/* 

Plugin implementor provides a top level function in their bundle defined as:

swift: public func pluginInit(appBundleID: String, supervisor: Supervisor) -> Plugin?
objc : extern MyPluginClass * __nullable pluginForBundle(NSString * __nonnull appBundleID, Supervisor * __nonnull supervisor);

*/

public typealias PluggableID = String

@objc
public protocol Pluggable {
    var identifier: PluggableID { get }
    var dependencies: [PluggableID]? { get }

    init?(containerBundleID: String?)

    // Provides the default route to this plugin or feature.
    func startup(supervisor: Supervisor) -> Route?
}

public extension Pluggable {
    func dependsOn(dependencyID: PluggableID) -> Bool {
        if let deps = dependencies {
            return deps.contains(dependencyID)
        }
        return false
    }
    
    func pluginDescription() -> String {
        var result = ""
        
        result += "\(identifier)\n"
        
        if let deps = dependencies {
            for i in 0..<deps.count {
                result += "  (\(deps[i]))\n"
            }
        }
        
        return result
    }    
}


@objc
public protocol PluggableFeature: Pluggable {
    
    /**
    URL Handling
    */
    optional func routeForURL(url: NSURL) -> Route?
    
    /**
    Notification handling
    */
    optional func routeForLocalNotification(notification: UILocalNotification) -> Route?
    optional func routeForRemoteNotification(userInfo: [NSObject : AnyObject]) -> Route?
    
    /**
    Application lifecycle events
    */
    func applicationWillTerminate()
    func applicationDidReceiveMemoryWarning()
    
    optional func applicationWillResignActive()
    optional func applicationDidEnterBackground()
    optional func applicationWillEnterForeground()
    optional func applicationDidBecomeActive()
    
    /**
    Application events for background event handling
    */
    optional func applicationHandleEventsForBackgroundURLSession(identifier: String, completionHandler: () -> Void)
    
    /**
    Application events for watchkit handling -- is this needed?
    */
    optional func applicationHandleWatchKitExtensionRequest(userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!)
}

