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
     Local and Remote Notification events
     */
    optional func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    optional func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
    optional func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void)
    optional func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    optional func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    optional func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    optional func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void)
    
    @available(iOS 9.0, *)
    optional func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void)
    
    @available(iOS 9.0, *)

    optional func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void)
    
    /**
     Application events for background event handling
     */
    optional func applicationHandleEventsForBackgroundURLSession(identifier: String, completionHandler: () -> Void)
    
    /**
     Application events for watchkit handling -- is this needed?
     */
    optional func applicationHandleWatchKitExtensionRequest(userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!)
    
    @available(iOS 9.0, *)
    /**
     Application events for handling force touch springboard shortcuts
     
     - parameter shortcutItem:      The shortcut shortcut item
     - parameter completionHandler: The completion handler, fired after the shortcut has been handled
     
     - returns: Whether the action was performed by the plugin
     */
    optional func applicationPerformActionForShortcutItem(shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) -> Bool
}
