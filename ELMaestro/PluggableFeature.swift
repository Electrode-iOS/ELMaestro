//
//  PluggableFeature.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 5/19/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation
import UIKit
import ELRouter
@objc
public protocol PluggableFeature: Pluggable {
    
    /**
     API factory method for a module's API it exports. You will likely want to
     typecast this, ie:
     
     let wishListAPI = supervisor.pluginAPIForID(WishListID) as? WishListAPI
     */
    optional func pluginAPI() -> AnyObject?
    
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
