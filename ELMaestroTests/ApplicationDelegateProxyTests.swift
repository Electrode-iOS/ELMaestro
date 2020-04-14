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

    func test_applicationWillFinishLaunchingWithOptions_shouldCallPlugins() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationWillFinishLaunchingWithOptionsCalled = expectation(description: "Should call `applicationwillFinishLaunchingWithOptions`")

        let _ =  proxy.application(UIApplication.shared, willFinishLaunchingWithOptions: nil)

        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidFinishLaunchingWithOptions_shouldCallPlugins() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationDidFinishLaunchingWithOptionsCalled = expectation(description: "Should call `applicationDidFinishLaunchingWithOptions`")
        
        let _ =  proxy.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationWillResignActive_shouldCallPlugins() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationWillResignActiveCalled = expectation(description: "Should call `applicationWillResignActive`")
        
        proxy.applicationWillResignActive(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidEnterBackground_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationDidEnterBackgroundCalled = expectation(description: "Should call `applicationDidEnterBackground`")
        
        proxy.applicationDidEnterBackground(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationWillEnterForeground_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationWillEnterForegroundCalled = expectation(description: "Should call `applicationWillEnterForeground`")
        
        proxy.applicationWillEnterForeground(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidBecomeActive_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationDidBecomeActiveCalled = expectation(description: "Should call `applicationDidBecomeActive`")
        
        proxy.applicationDidBecomeActive(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationWillTerminate_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationWillTerminateCalled = expectation(description: "Should call `applicationWillTerminate`")
        
        proxy.applicationWillTerminate(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_applicationDidReceiveMemoryWarning_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationDidReceiveMemoryWarningCalled = expectation(description: "Should call `applicationDidReceiveMemoryWarning`")
        
        proxy.applicationDidReceiveMemoryWarning(UIApplication.shared)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didReceiveRemoteNotification_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.didReceiveRemoteNotificationCalled = expectation(description: "Should call `didReceiveRemoteNotification`")
        
        proxy.application(UIApplication.shared, didReceiveRemoteNotification: [AnyHashable: Any]()) { result in
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didRegisterForRemoteNotificationsWithDeviceToken_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.didRegisterForRemoteNotificationsWithDeviceTokenCalled = expectation(description: "Should call `didRegisterForRemoteNotificationsWithDeviceToken`")
        
        proxy.application(UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: Data())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_didFailToRegisterForRemoteNotificationsWithError_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.didFailToRegisterForRemoteNotificationsWithErrorCalled = expectation(description: "Should call `didFailToRegisterForRemoteNotificationsWithError`")
        
        proxy.application(UIApplication.shared, didFailToRegisterForRemoteNotificationsWithError: RemoteNotificationError.somethingsGoneWrong)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_handleActionWithIdentifierForRemoteNotification_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.handleActionWithIdentifierForRemoteNotificationCalled = expectation(description: "Should call `handleActionWithIdentifierForRemoteNotification`")
        
        proxy.application(UIApplication.shared, handleActionWithIdentifier: nil, forRemoteNotification: [AnyHashable: Any]()) { 
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_handleActionWithIdentifierForRemoteNotificationWithResponseInfo_shouldCallPlugin() {

        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.handleActionWithIdentifierWithResponseInfoCalled = expectation(description: "Should call `handleActionWithIdentifierWithResponseInfo`")
        
        proxy.application(UIApplication.shared, handleActionWithIdentifier: nil, forRemoteNotification: [AnyHashable: Any](), withResponseInfo: [AnyHashable: Any]()) {
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_applicationOpenOptions_shouldCallPlugin() {
        let proxy = proxyForTesting()
        let supervisor = supervisorForTesting(proxy: proxy)
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        api.applicationOpenOptionsCalled = expectation(description: "Should call `application:open:options:`")
        let url = URL(string: "https://www.walmart.com/")!

        let _ = proxy.application(UIApplication.shared, open: url, options: [UIApplication.OpenURLOptionsKey : Any]())

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}

enum RemoteNotificationError: Error {
    case somethingsGoneWrong
}
