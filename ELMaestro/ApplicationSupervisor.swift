//
//  ApplicationSupervisor.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 5/19/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation

@objc
final public class ApplicationSupervisor: Supervisor, UIApplicationDelegate {
    open var window: UIWindow? = nil
    
    // Only callable from within an UIApplication context
    // For unit testing, instantiate ApplicationSupervisor directly
    // It is acceptable for this to crash if the application delegate is not a ApplicationSupervisor
    open static var sharedInstance: ApplicationSupervisor {
        return UIApplication.shared.delegate as! ApplicationSupervisor
    }
    
    override public init() {
        super.init()
    }

    /// This property can be set to show a privacy view on top of the visible view controller.
    open var backgroundPrivacyView: UIView = ApplicationSupervisor.defaultPrivacyView()
    /// The default value is Opt-In.
    open var backgroundPrivacyOptions = BackgroundPrivacyOptions.optIn
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
    
    open func applicationWillResignActive(_ application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillResignActive?()
        }
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        // this will only show the privacy view if the proper criteria is met.
        showPrivacyView()
        
        for feature in startedFeaturePlugins {
            feature.applicationDidEnterBackground?()
        }
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillEnterForeground?()
        }
        
        // this will remove the privacy view if it was displayed.
        hidePrivacyView()
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidBecomeActive?()
        }
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationWillTerminate()
        }
    }
    
    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        for feature in startedFeaturePlugins {
            feature.applicationDidReceiveMemoryWarning()
        }
    }
    
    open func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didRegisterUserNotificationSettings: notificationSettings)
        }
    }
    
    open func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didReceiveLocalNotification: notification)
        }
    }
    
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forLocalNotification: notification, completionHandler: completionHandler)
        }
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didFailToRegisterForRemoteNotificationsWithError: error as NSError)
        }
    }
    
    // NOTE: Don't implement:  application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    //      ...because application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    //      will always be called in favor of application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    //      if both are implemented.
    //      xcdoc://?url=developer.apple.com/library/etc/redirect/xcode/ios/1151/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forLocalNotification: notification, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }

    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        for feature in startedFeaturePlugins {
            feature.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS 9.0, *)
    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
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
    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
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
