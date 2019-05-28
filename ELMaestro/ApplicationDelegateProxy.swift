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
    
    override public init() {
        super.init()
    }

    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var result = true

        if supervisor.startedPlugins.count == 0 {
            assertionFailure("Perform plugin startup before calling application:willFinishLaunchingWithOptions:")
        } else {
            for feature in supervisor.startedFeaturePlugins {
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
            for feature in supervisor.startedFeaturePlugins {
                // coalesce our return values together
                if let value = feature.application?(application, didFinishLaunchingWithOptions: launchOptions) {
                    result = result || value
                }
            }
        }
        
        return result
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        for feature in supervisor.startedFeaturePlugins {
            feature.applicationWillResignActive?()
        }
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        // this will only show the privacy view if the proper criteria is met.
        supervisor.showPrivacyView()
        
        for feature in supervisor.startedFeaturePlugins {
            feature.applicationDidEnterBackground?()
        }
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        for feature in supervisor.startedFeaturePlugins {
            feature.applicationWillEnterForeground?()
        }
        
        // this will remove the privacy view if it was displayed.
        supervisor.hidePrivacyView()
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        for feature in supervisor.startedFeaturePlugins {
            feature.applicationDidBecomeActive?()
        }
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        for feature in supervisor.startedFeaturePlugins {
            feature.applicationWillTerminate()
        }
    }
    
    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        for feature in supervisor.startedFeaturePlugins {
            feature.applicationDidReceiveMemoryWarning()
        }
    }
    
    open func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, didRegisterUserNotificationSettings: notificationSettings)
        }
    }
    
    open func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, didReceiveLocalNotification: notification)
        }
    }
    
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forLocalNotification: notification, completionHandler: completionHandler)
        }
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, didFailToRegisterForRemoteNotificationsWithError: error as NSError)
        }
    }
    
    // NOTE: Don't implement:  application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    //      ...because application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    //      will always be called in favor of application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    //      if both are implemented.
    //      xcdoc://?url=developer.apple.com/library/etc/redirect/xcode/ios/1151/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forLocalNotification: notification, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in supervisor.startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        for feature in supervisor.startedFeaturePlugins {
            let handled = feature.applicationPerformActionForShortcutItem?(shortcutItem, completionHandler: completionHandler)
            if handled == true {
                break
            }
        }
    }
    
    // MARK: Handoff
    // continueUserActivity will be used for features such as universal linking
    // https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW2
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        for feature in supervisor.startedFeaturePlugins {
            if let featureHandled = feature.application?(application, continue: userActivity, restorationHandler: restorationHandler) {
                if featureHandled {
                    return true
                }
            }
        }
        return false // Not handled by any feature plugin
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        for feature in supervisor.startedFeaturePlugins {
            let handled = feature.application?(app, open: url, options: options)
            if let featureHandled = handled, featureHandled {
                return true
            }
        }

        return false
    }
}
