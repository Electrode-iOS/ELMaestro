//
//  ApplicationSupervisor.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 5/19/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation

@objc
public class ApplicationSupervisor: Supervisor, UIApplicationDelegate {
    /*
     I had to do the sharedInstance stuff a bit differently here since the app
     ends up instantiating the first ApplicationSupervisor.
     */
    private struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: ApplicationSupervisor? = nil
    }
    
    public static var sharedInstance: ApplicationSupervisor {
        let instance = Static.instance
        return instance!
    }
    
    override public init() {
        super.init()
        dispatch_once(&Static.onceToken) {
            Static.instance = self
        }
    }
    
    public var window: UIWindow? = nil
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    public func applicationWillResignActive(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillResignActive?()
        }
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidEnterBackground?()
        }
    }
    
    public func applicationWillEnterForeground(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillEnterForeground?()
        }
    }
    
    public func applicationDidBecomeActive(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidBecomeActive?()
        }
    }
    
    public func applicationWillTerminate(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidBecomeActive?()
        }
    }
}
