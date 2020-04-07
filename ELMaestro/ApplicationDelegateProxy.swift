//
//  ApplicationDelegateProxy.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 10/13/17.
//  Copyright © 2017 WalmartLabs. All rights reserved.
//

import Foundation

@objc
open class ApplicationDelegateProxy: UIResponder, UIApplicationDelegate {
    public internal(set) var supervisor = ApplicationSupervisor.sharedInstance
    
    public var window: UIWindow? {
        get {
            return supervisor.window
        }
        set {
            supervisor.window = newValue
        }
    }

    var applicationDelegates: [UIApplicationDelegate] {
        return supervisor.startedPlugins.compactMap { $0 as? UIApplicationDelegate }
    }
    
    override public init() {
        super.init()
    }

    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var result = true

        if supervisor.startedPlugins.count == 0 {
            assertionFailure("Perform plugin startup before calling application:willFinishLaunchingWithOptions:")
        } else {
            for feature in applicationDelegates {
                // coalesce our return values together
                if let value = feature.application?(application, willFinishLaunchingWithOptions: launchOptions) {
                    result = result || value
                }
            }
        }

        return result
    }
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var result = true
        
        if supervisor.startedPlugins.count == 0 {
            assertionFailure("Perform plugin startup before calling application:didFinishLaunchWithOptions:")
        } else {
            for feature in applicationDelegates {
                // coalesce our return values together
                if let value = feature.application?(application, didFinishLaunchingWithOptions: launchOptions) {
                    result = result || value
                }
            }
        }
        
        return result
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        for feature in applicationDelegates {
            feature.applicationWillResignActive?(application)
        }
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        // this will only show the privacy view if the proper criteria is met.
        supervisor.showPrivacyView()
        
        for feature in applicationDelegates {
            feature.applicationDidEnterBackground?(application)
        }
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        for feature in applicationDelegates {
            feature.applicationWillEnterForeground?(application)
        }
        
        supervisor.hidePrivacyView()
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        for feature in applicationDelegates {
            feature.applicationDidBecomeActive?(application)
        }
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        for feature in applicationDelegates {
            feature.applicationWillTerminate?(application)
        }
    }
    
    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        for feature in applicationDelegates {
            feature.applicationDidReceiveMemoryWarning?(application)
        }
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for feature in applicationDelegates {
            feature.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for feature in applicationDelegates {
            feature.application?(application, didFailToRegisterForRemoteNotificationsWithError: error as NSError)
        }
    }

    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for feature in applicationDelegates {
            feature.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in applicationDelegates {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }

    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in applicationDelegates {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }

    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        for feature in applicationDelegates {
            feature.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)
        }
    }

    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        for feature in applicationDelegates {
            if let featureHandled = feature.application?(application, continue: userActivity, restorationHandler: restorationHandler) {
                if featureHandled {
                    return true
                }
            }
        }
        return false // Not handled by any feature plugin
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        for feature in applicationDelegates {
            let handled = feature.application?(app, open: url, options: options)
            if let featureHandled = handled, featureHandled {
                return true
            }
        }

        return false
    }

    open func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        for feature in applicationDelegates {
            if let orientationMask = feature.application?(application, supportedInterfaceOrientationsFor: window) {
                return orientationMask
            }
        }
        return .portrait
    }
}
