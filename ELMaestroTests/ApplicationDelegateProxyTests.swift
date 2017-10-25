//
//  ApplicationDelegateProxyTests.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 10/19/17.
//  Copyright © 2017 WalmartLabs. All rights reserved.
//

import XCTest
@testable import ELMaestro

class ApplicationDelegateProxyTests: XCTestCase {
    
    // MARK: - Test Objects
    
    func proxyForTesting() -> ApplicationDelegateProxy {
        let proxy = ApplicationDelegateProxy()
        return proxy
    }
    
    func supervisorForTesting(proxy: ApplicationDelegateProxy) -> Supervisor {
        let supervisor = ApplicationSupervisor()
        proxy.supervisor = supervisor
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        return supervisor
    }
    
    // MARK: - Tests
    
    func test_applicationDidFinishLaunchingWithOptions_shouldCallPlugins() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationDidFinishLaunchingWithOptionsCalled = expectation(description: "Should call `applicationDidFinishLaunchingWithOptions`")
        
        let _ =  proxy.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationWillResignActive_shouldCallPlugins() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationWillResignActiveCalled = expectation(description: "Should call `applicationWillResignActive`")
        
        proxy.applicationWillResignActive(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidEnterBackground_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationDidEnterBackgroundCalled = expectation(description: "Should call `applicationDidEnterBackground`")
        
        proxy.applicationDidEnterBackground(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationWillEnterForeground_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationWillEnterForegroundCalled = expectation(description: "Should call `applicationWillEnterForeground`")
        
        proxy.applicationWillEnterForeground(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidBecomeActive_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationDidBecomeActiveCalled = expectation(description: "Should call `applicationDidBecomeActive`")
        
        proxy.applicationDidBecomeActive(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationWillTerminate_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationWillTerminateCalled = expectation(description: "Should call `applicationWillTerminate`")
        
        proxy.applicationWillTerminate(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidReceiveMemoryWarning_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.applicationDidReceiveMemoryWarningCalled = expectation(description: "Should call `applicationDidReceiveMemoryWarning`")
        
        proxy.applicationDidReceiveMemoryWarning(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didRegisterNotificationSettings_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.didRegisterUserNotificationSettingsCalled = expectation(description: "Should call `didRegisterUserNotificationSettings`")
        
        proxy.application(UIApplication.shared, didRegister: UIUserNotificationSettings())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didReceiveLocalNotification_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.didReceiveLocalNotificationCalled = expectation(description: "Should call `didReceiveLocalNotification`")
        
        proxy.application(UIApplication.shared, didReceive: UILocalNotification())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didReceiveRemoteNotification_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.didReceiveRemoteNotificationCalled = expectation(description: "Should call `didReceiveRemoteNotification`")
        
        proxy.application(UIApplication.shared, didReceiveRemoteNotification: [AnyHashable: Any]()) { result in
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_handleActionWithIdentifierForLocalNotification_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.handleActionWithIdentifierForLocalNotificationCalled = expectation(description: "Should call `handleActionWithIdentifierForLocalNotification`")
        
        proxy.application(UIApplication.shared, handleActionWithIdentifier: nil, for: UILocalNotification()) { 
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didRegisterForRemoteNotificationsWithDeviceToken_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.didRegisterForRemoteNotificationsWithDeviceTokenCalled = expectation(description: "Should call `didRegisterForRemoteNotificationsWithDeviceToken`")
        
        proxy.application(UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: Data())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didFailToRegisterForRemoteNotificationsWithError_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.didFailToRegisterForRemoteNotificationsWithErrorCalled = expectation(description: "Should call `didFailToRegisterForRemoteNotificationsWithError`")
        
        proxy.application(UIApplication.shared, didFailToRegisterForRemoteNotificationsWithError: RemoteNotificationError.somethingsGoneWrong)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_handleActionWithIdentifierForRemoteNotification_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.handleActionWithIdentifierForRemoteNotificationCalled = expectation(description: "Should call `handleActionWithIdentifierForRemoteNotification`")
        
        proxy.application(UIApplication.shared, handleActionWithIdentifier: nil, forRemoteNotification: [AnyHashable: Any]()) { 
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_handleActionWithIdentifierForRemoteNotificationWithResponseInfo_shouldCallPlugin() {
        guard #available(iOS 9.0, *) else {
            return
        }
        
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.handleActionWithIdentifierWithResponseInfoCalled = expectation(description: "Should call `handleActionWithIdentifierWithResponseInfo`")
        
        proxy.application(UIApplication.shared, handleActionWithIdentifier: nil, forRemoteNotification: [AnyHashable: Any](), withResponseInfo: [AnyHashable: Any]()) {
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_handleActionWithIdentifierForLocalNotificationWithResponseInfo_shouldCallPlugin() {
        guard #available(iOS 9.0, *) else {
            return
        }
        
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.handleActionWithIdentifierForLocalNotificationWithResponseInfoCalled = expectation(description: "Should call `handleActionWithIdentifierForLocalNotificationWithResponseInfo`")
        
        proxy.application(UIApplication.shared, handleActionWithIdentifier: nil, for: UILocalNotification(), withResponseInfo: [AnyHashable: Any]()) { 
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_performActionForShorcutItem_shouldCallPlugin() {
        guard #available(iOS 9.0, *) else {
            return
        }
        
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        api.performActionForShortcutItemCalled = expectation(description: "Should call `performActionForShortcutItem`")
        
        proxy.application(UIApplication.shared, performActionFor: UIApplicationShortcutItem(type: "test", localizedTitle: "test")) { _ in
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}

enum RemoteNotificationError: Error {
    case somethingsGoneWrong
}
