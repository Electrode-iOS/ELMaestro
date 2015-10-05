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

@objc
public protocol Pluggable {
    var identifier: String { get }
    var dependencies: [NSBundle]? { get }

    func initializeForContainer(containedBundleID: String?)

    // Provides the default route to this plugin or feature.
    func startup(supervisor: Supervisor) -> Route?
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
