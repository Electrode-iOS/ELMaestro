//
//  testClass.swift
//  testFramework
//
//  Created by Brandon Sneed on 6/17/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

import Foundation
import ELMaestro

// this has to be Objc to cross the boundary of the framework.

@objc
public class TestPlugin: NSObject, PluggableFeature {
    public var identifier: String {
        return "com.walmartlabs.testplugin"
    }
    
    public var dependencies: [DependencyID]? {
        return ["com.walmartlabs.testObjcFramework"]
    }
    
    private let _pluginAPI = TestPluginAPI()
    
    required public init?(containerBundleID: String?) {
        super.init()
    }
    
    // Provides the default route to this plugin or feature.
    public func startup(supervisor: Supervisor) {
        
    }
    
    // MARK: API
    
    public func pluginAPI() -> AnyObject? {
        return _pluginAPI
    }
    
    // MARK: Application lifecycle events
    public func applicationWillTerminate() {
        
    }
    
    public func applicationDidReceiveMemoryWarning() {
        
    }
    
    public func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        _pluginAPI.continuityType = userActivity.activityType
        return true
    }
}
