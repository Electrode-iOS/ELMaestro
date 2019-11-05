//
//  PluggableFeature.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 5/19/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//
import Foundation
import UIKit

@objc
public protocol PluggableFeature: Pluggable {
    /**
     API factory method for a module's API it exports. You will likely want to
     typecast this, ie:
     
     let pluginAPI = supervisor.pluginAPI(forIdentifier: "com.myorg.mymodule") as? MyPluginAPI
     */
    @objc optional func pluginAPI() -> AnyObject?

    @objc optional func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool
    @objc optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool

    /**
     Application lifecycle events
     */
    func applicationWillTerminate()
    func applicationDidReceiveMemoryWarning()
    
    @objc optional func applicationWillResignActive()
    @objc optional func applicationDidEnterBackground()
    @objc optional func applicationWillEnterForeground()
    @objc optional func applicationDidBecomeActive()
    
    /**
     Remote Notification events
     */

    @objc optional func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    @objc optional func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    @objc optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    @objc optional func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void)
    
    @objc optional func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void)
    
    // Continuity
    
    @objc optional func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    
    /**
     Application events for background event handling
     */
    @objc optional func applicationHandleEventsForBackgroundURLSession(_ identifier: String, completionHandler: () -> Void)
    
    /**
     Application events for watchkit handling -- is this needed?
     */
    @objc optional func applicationHandleWatchKitExtensionRequest(_ userInfo: [AnyHashable: Any]?, reply: (([AnyHashable: Any]?) -> Void)!)

    /**
     Application events for handling force touch springboard shortcuts
     
     - parameter shortcutItem:      The shortcut shortcut item
     - parameter completionHandler: The completion handler, fired after the shortcut has been handled
     
     - returns: Whether the action was performed by the plugin
     */

    @objc optional func applicationPerformActionForShortcutItem(_ shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) -> Bool

    @objc optional func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool

    @objc optional func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
}
