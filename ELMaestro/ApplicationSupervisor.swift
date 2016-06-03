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
    
    /// This property can be set to show a privacy view on top of the visible view controller.
    public var backgroundPrivacyView: UIView = ApplicationSupervisor.defaultPrivacyView()
    /// The default value is Opt-In.
    public var backgroundPrivacyOptions = BackgroundPrivacyOptions.OptIn
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    public func applicationWillResignActive(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillResignActive?()
        }
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        // this will only show the privacy view if the proper criteria is met.
        showPrivacyView()
        
        for feature in startedFeaturePlugins {
            feature.applicationDidEnterBackground?()
        }
    }
    
    public func applicationWillEnterForeground(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillEnterForeground?()
        }
        
        // this will remove the privacy view if it was displayed.
        hidePrivacyView()
    }
    
    public func applicationDidBecomeActive(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidBecomeActive?()
        }
    }
    
    public func applicationWillTerminate(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillTerminate()
        }
    }
    
    public func applicationDidReceiveMemoryWarning(application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidReceiveMemoryWarning()
        }
    }
    
    @available(iOS 9.0, *)
    public func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        for feature in startedFeaturePlugins {
            let handled = feature.applicationPerformActionForShortcutItem?(shortcutItem, completionHandler: completionHandler)
            if handled == true {
                break
            }
        }
    }
}
