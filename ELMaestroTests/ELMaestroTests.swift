//
//  ELMaestroTests.swift
//  ELMaestroTests
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import UIKit
import XCTest
@testable import ELMaestro

class ELMaestroTests: XCTestCase {
    func test_pluginLoaded_returnsTrueWhenPluginLoaded() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()

        XCTAssertTrue(supervisor.pluginLoaded(dependencyID: testPluginID))
    }
    
    func test_pluginLoaded_returnsFalseWhenPluginIsNotLoaded() {
        let supervisor = ApplicationSupervisor()
        
        XCTAssertFalse(supervisor.pluginLoaded(dependencyID: testPluginID))
    }
    
    func test_pluginStarted_returnsTrueAfterStartup() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        
        XCTAssertTrue(supervisor.pluginStarted(dependencyID: testPluginID))
    }
    
    func test_pluginStarted_returnsFalseBeforeStartup() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPlugin.self)
        
        XCTAssertFalse(supervisor.pluginStarted(dependencyID: testPluginID))
    }
    
    func test_pluginLoaded_returnsTrueWithDependencies() {
        let testObjcPluginID = "com.walmartlabs.testObjcFramework"
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestObjcClass.self)
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()

        XCTAssertTrue(supervisor.pluginLoaded(dependencyID: testPluginID))
        XCTAssertTrue(supervisor.pluginLoaded(dependencyID: testObjcPluginID))
    }
    
    func test_pluginStarted_returnsTrueWithDependencies() {
        let testObjcPluginID = "com.walmartlabs.testObjcFramework"
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestObjcClass.self)
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        
        XCTAssertTrue(supervisor.pluginStarted(dependencyID: testPluginID))
        XCTAssertTrue(supervisor.pluginStarted(dependencyID: testObjcPluginID))
    }
    
    func test_supervisor_handlesContinueUserActivity() {
        let supervisor = ApplicationSupervisor()
        let applicationDelegate = ApplicationDelegateProxy()
        applicationDelegate.supervisor = supervisor
        
        supervisor.loadPlugin(TestObjcClass.self)
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        
        let api = supervisor.pluginAPI(forIdentifier: testPluginID) as! TestPluginAPI
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        let handled = applicationDelegate.application(UIApplication.shared, continue: userActivity, restorationHandler:{ arr in })
        
        XCTAssertTrue(handled, "Expected a plugin to handle continuity")
        XCTAssertTrue(api.continuityType == NSUserActivityTypeBrowsingWeb, "Expected NSUserActivityTypeBrowsingWeb")
    }
}

// MARK: - Stub Plugin

let testPluginID = "com.walmartlabs.testplugin"

final class TestPlugin: NSObject, PluggableFeature {
    var identifier: String {
        return testPluginID
    }
    
    var dependencies: [DependencyID]? {
        return nil
    }
    
    fileprivate let _pluginAPI = TestPluginAPI()
    
    required public init?(containerBundleID: String?) {
        super.init()
    }
    
    // Provides the default route to this plugin or feature.
    open func startup(_ supervisor: Supervisor) {
        
    }
    
    // MARK: API
    
    open func pluginAPI() -> AnyObject? {
        return _pluginAPI
    }
    
    // MARK: Application  lifecycle events
    open func applicationWillTerminate() {
        
    }
    
    open func applicationDidReceiveMemoryWarning() {
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        _pluginAPI.continuityType = userActivity.activityType
        return true
    }
}

final class TestPluginAPI : NSObject {
    var continuityType: String = ""
}
