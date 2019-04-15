//
//  TestPlugin.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 10/19/17.
//  Copyright © 2017 WalmartLabs. All rights reserved.
//

import Foundation

let testPluginID = "com.walmartlabs.testplugin"

final class TestPlugin: NSObject, PluggableFeature {
    var identifier: String {
        return testPluginID
    }
    
    var dependencies: [DependencyID]? {
        return nil
    }
    
    fileprivate let api = TestPluginAPI()
    
    required public init?(containerBundleID: String?) {
        super.init()
    }
    
    // Provides the default route to this plugin or feature.
    public func startup(_ supervisor: Supervisor) {
        
    }
    
    // MARK: API
    
    public func pluginAPI() -> AnyObject? {
        return api
    }
    
    // MARK: Application  lifecycle events
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        api.applicationDidFinishLaunchingWithOptionsCalled?.fulfill()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Swift.Void) -> Bool {
        api.continuityType = userActivity.activityType
        return true
    }
    
    func applicationWillResignActive() {
        api.applicationWillResignActiveCalled?.fulfill()
    }
    
    func applicationDidEnterBackground() {
        api.applicationDidEnterBackgroundCalled?.fulfill()
    }
    
    func applicationWillEnterForeground() {
        api.applicationWillEnterForegroundCalled?.fulfill()
    }
    
    func applicationDidBecomeActive() {
        api.applicationDidBecomeActiveCalled?.fulfill()
    }
    
    func applicationWillTerminate() {
        api.applicationWillTerminateCalled?.fulfill()
    }
    
    func applicationDidReceiveMemoryWarning() {
        api.applicationDidReceiveMemoryWarningCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        api.didRegisterUserNotificationSettingsCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        api.didReceiveLocalNotificationCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        api.handleActionWithIdentifierForLocalNotificationWithResponseInfoCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        api.didRegisterForRemoteNotificationsWithDeviceTokenCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        api.didFailToRegisterForRemoteNotificationsWithErrorCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        api.didReceiveRemoteNotificationCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        api.handleActionWithIdentifierWithResponseInfoCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        api.handleActionWithIdentifierForLocalNotificationCalled?.fulfill()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        api.handleActionWithIdentifierForRemoteNotificationCalled?.fulfill()
    }
    
    @available(iOS 9.0, *)
    func applicationPerformActionForShortcutItem(_ shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) -> Bool {
        api.performActionForShortcutItemCalled?.fulfill()
        return true
    }
}
