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
    public var window: UIWindow? = nil
    
    // Only callable from within an UIApplication context
    // For unit testing, instantiate ApplicationSupervisor directly
    // It is acceptable for this to crash if the application delegate is not a ApplicationSupervisor
    public static var sharedInstance: ApplicationSupervisor {
        return UIApplication.sharedApplication().delegate as! ApplicationSupervisor
    }
    
    override public init() {
        super.init()
    }

    /// This property can be set to show a privacy view on top of the visible view controller.
    public var backgroundPrivacyView: UIView = ApplicationSupervisor.defaultPrivacyView()
    /// The default value is Opt-In.
    public var backgroundPrivacyOptions = BackgroundPrivacyOptions.OptIn
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var result = true
        
        if startedPlugins.count == 0 {
            assertionFailure("Perform plugin startup before calling application:didFinishLaunchWithOptions:")
        } else {
            for feature in startedFeaturePlugins {
                // coalesce our return values together
                if let value = feature.application?(application, didFinishLaunchingWithOptions: launchOptions) {
                    result = result || value
                }
            }
        }
        
        return result
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
    
    public func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didRegisterUserNotificationSettings: notificationSettings)
        }
    }
    
    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didReceiveLocalNotification: notification)
        }
    }
    
    public func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forLocalNotification: notification, completionHandler: completionHandler)
        }
    }
    
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
    // NOTE: Don't implement:  application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    //      ...because application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    //      will always be called in favor of application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    //      if both are implemented.
    //      xcdoc://?url=developer.apple.com/library/etc/redirect/xcode/ios/1151/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    public func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    public func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forLocalNotification: notification, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }

    @available(iOS 9.0, *)
    public func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
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
    
    // MARK: Handoff
    // continueUserActivity will be used for features such as universal linking
    // https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW2
    public func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        for feature in startedFeaturePlugins {
            if let featureHandled = feature.application?(application, continueUserActivity: userActivity, restorationHandler: restorationHandler) {
                if featureHandled {
                    return true
                }
            }
        }
        return false // Not handled by any feature plugin
    }
    
}
