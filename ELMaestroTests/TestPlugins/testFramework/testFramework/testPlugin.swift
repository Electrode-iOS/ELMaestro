//
//  testClass.swift
//  testFramework
//
//  Created by Brandon Sneed on 6/17/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

import Foundation
import ELMaestro

@objc
open class TestPlugin: NSObject, PluggableFeature {
    open var identifier: String {
        return "com.walmartlabs.testplugin"
    }
    
    open var dependencies: [DependencyID]? {
        return ["com.walmartlabs.testObjcFramework"]
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
    
    @nonobjc open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: ([Any]?) -> Void) -> Bool {
        _pluginAPI.continuityType = userActivity.activityType
        return true
    }
}
