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

        XCTAssertTrue(supervisor.pluginLoaded(dependencyID: TestPlugin.pluginID))
    }
    
    func test_pluginLoaded_returnsFalseWhenPluginIsNotLoaded() {
        let supervisor = ApplicationSupervisor()
        
        XCTAssertFalse(supervisor.pluginLoaded(dependencyID: TestPlugin.pluginID))
    }
    
    func test_pluginStarted_returnsTrueAfterStartup() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        
        XCTAssertTrue(supervisor.pluginStarted(dependencyID: TestPlugin.pluginID))
    }
    
    func test_pluginStarted_returnsFalseBeforeStartup() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPlugin.self)
        
        XCTAssertFalse(supervisor.pluginStarted(dependencyID: TestPlugin.pluginID))
    }
    
    func test_pluginLoaded_returnsTrueWithDependencies() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPluginTwo.self)
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()

        XCTAssertTrue(supervisor.pluginLoaded(dependencyID: TestPlugin.pluginID))
        XCTAssertTrue(supervisor.pluginLoaded(dependencyID: TestPluginTwo.pluginID))
    }
    
    func test_pluginStarted_returnsTrueWithDependencies() {
        let supervisor = ApplicationSupervisor()
        supervisor.loadPlugin(TestPluginTwo.self)
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        
        XCTAssertTrue(supervisor.pluginStarted(dependencyID: TestPlugin.pluginID))
        XCTAssertTrue(supervisor.pluginStarted(dependencyID: TestPluginTwo.pluginID))
    }
    
    func test_supervisor_handlesContinueUserActivity() {
        let supervisor = ApplicationSupervisor()
        let applicationDelegate = ApplicationDelegateProxy()
        applicationDelegate.supervisor = supervisor
        
        supervisor.loadPlugin(TestPlugin.self)
        supervisor.startup()
        
        let api = supervisor.pluginAPI(forIdentifier: TestPlugin.pluginID) as! TestPluginAPI
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        let handled = applicationDelegate.application(UIApplication.shared, continue: userActivity, restorationHandler:{ arr in })
        
        XCTAssertTrue(handled, "Expected a plugin to handle continuity")
        XCTAssertTrue(api.continuityType == NSUserActivityTypeBrowsingWeb, "Expected NSUserActivityTypeBrowsingWeb")
    }
}
