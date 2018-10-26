# ELMaestro 

[![Build Status](https://travis-ci.org/Electrode-iOS/ELMaestro.svg?branch=master)](https://travis-ci.org/Electrode-iOS/ELMaestro)

ELMaestro is a Swift framework that provides plugin system for iOS applications.

## Installation

ELMaestro requires Swift 4.2 and Xcode 10.

### Carthage

Install with [Carthage](https://github.com/Carthage/Carthage) by adding the framework to your project's [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "Electrode-iOS/ELMaestro"
```

### Manual

Install by adding ELMaestro.xcodeproj to your project and configuring your target to link ELMaestro.framework from `ELMaestro` target.

There are two target that builds `ELMaestro.framework`.
1. `ELMaestro`: Creates dynamically linked `ELMaestro.framework.`
2. `ELMaestro_static`: Creates statically linked `ELMaestro.framework`.

## Usage

ELMaestro provides a plugin system for managing a modular architecture of an application. It enables your app to be organized into self-contained modules that can subscribe to application delegate events. This prevents your app delegate from being bloated by feature-specific code and keeps concerns cleanly separated.

ELMaestro consists of three main concepts:

- ApplicationSupervisor - A registrar for plugin instances that handles forwarding app delegate events to plugins
- Plugin - A type that contains feature-specific implementation. Typically this type is encapsulated within a Swift framework.
- Plugin API - An interface that a plugin provides that other modules use to interact with the plugin

### Plugins

A Plugin is composed of three different protocols:

- `Module`
- `Pluggable`
- `PluggableFeature` (optional)

#### Module

The `Module` protocol defines a plugin type for a plugin.

```

public protocol Module {
    static func pluginClass() -> Pluggable.Type
}
```

Example implementation:

```
@objc
open class MyPlugin: NSObject, Module {    
    open static func pluginClass() -> Pluggable.Type {
        return MyPlugin.self
    }
}
```

#### Pluggable

The `Pluggable` protocol defines the plugin indentifer, plugin dependencies, as well as startup and initialization methods.

```
@objc
public protocol Pluggable {
    var identifier: DependencyID { get }
    var dependencies: [DependencyID]? { get }

    init?(containerBundleID: String?)
    func startup(_ supervisor: Supervisor)
}
```

Example implementation:

```
/// Identifier used to lookup the instance with `ApplicationSupervisor`
public let MyPluginID = "com.myorganization.mymodule"

extension MyPlugin: Pluggable {
    let identifier: String = MyPluginID

    /**
     An array of identifiers of any other modules that 
     this module is dependant on
    */
    let dependencies: [DependencyID]? = nil

    /**
     Called when the plugin is first initialized by 
     the `ApplicationSupervisor`
    */
    required init?(containerBundleID: String?) {
        
    }

    /**
     Called after all dependant plugins are started up
    */
    func startup(_ supervisor: Supervisor) {

    }
}
```

#### PluggableFeature

The `PluggableFeature` protocol defines all of the application delegate events that a plugin can handle. Aside from `applicationWillTerminate` and `applicationDidReceiveMemoryWarning`, all of the app delegate methods are defined as `optional` so you can choose which methods the plugin needs to handle.

```
@objc public protocol PluggableFeature : Pluggable {
    /**
     API factory method for a module's API it exports. You will likely want to
     typecast this, ie:
     
     let pluginAPI = supervisor.pluginAPI(forIdentifier: "com.myorg.mymodule") as? MyPluginAPI
     */
    @objc optional public func pluginAPI() -> AnyObject?

    /**
     After all plugins have been started, the system will dispatch this to your plugin.
     */
    @objc optional public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any]?) -> Bool

    /**
     Application lifecycle events
     */
    public func applicationWillTerminate()

    public func applicationDidReceiveMemoryWarning()

    @objc optional public func applicationWillResignActive()

    @objc optional public func applicationDidEnterBackground()

    @objc optional public func applicationWillEnterForeground()

    @objc optional public func applicationDidBecomeActive()

    /**
     Local and Remote Notification events
     */
    @objc optional public func application(_ application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: () -> Void) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: () -> Void) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: () -> Void) -> <<error type>>

    @objc optional public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: ([Any]?) -> Void) -> Bool

    /**
     Application events for background event handling
     */
    @objc optional public func applicationHandleEventsForBackgroundURLSession(_ identifier: String, completionHandler: () -> Void)

    /**
     Application events for watchkit handling -- is this needed?
     */
    @objc optional public func applicationHandleWatchKitExtensionRequest(_ userInfo: [AnyHashable : Any]?, reply: (([AnyHashable : Any]?) -> Void)!)

    @objc optional public func applicationPerformActionForShortcutItem(_ shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) -> Bool
}
```

Example implementation:

```
extension MyPlugin: PluggableFeature {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        // handle app launch event
    }
    public func applicationWillTerminate() {
        // handle app will terminate event
    }

    public func applicationDidReceiveMemoryWarning() {
        // handle memory warning event
    }
}
```

#### Plugin API

The `PluggableFeature` defines an optional function `pluginAPI() -> AnyObject?` that enables a plugin to return an implementation for the public interface of the plugin.

For example, suppose the plugin needed to provide user data to other plugins. You can define an implementation for the plugin's API with a property to access the user's name.

```
@objc public protocol MyPluginAPI {
    var username: String {get}
}
```

Define a type for the implementatino and declare it as `internal` to prevent it from being publicly accessible outside of the module.

```
internal final class MyPluginAPIImpl: MyPluginAPI {
    let username: String = "mrmeeseeks"
}
```

Add a property to the plugin to contain the instance of the plugin API implementation.

```
@objc
open class MyPlugin: NSObject, Module {
    open static let logging = Logger()
    var pluginAPI = MyPluginAPIImpl()
    
    open static func pluginClass() -> Pluggable.Type {
        return MyPlugin.self
    }
}
```

Return the instance of the plugin API in the `pluginAPI()` function.

```
extension MyPlugin: PluggableFeature {
    func pluginAPI() -> AnyObject? {
        return pluginAPI
    }

    func applicationWillTerminate() {

    }

    func applicationDidReceiveMemoryWarning() {

    }
}
```

### ApplicationSupervisor

The `ApplicationSupervisor` is used to register a plugin. The `ApplicationSupervisor` will handle loading the plugin, loading any of the plugin's dependencies first, and calling the `startup()` method of the plugin once all dependant plugins are loaded.

The `ApplicationSupervisor` will also handle sending app delegate events to the plugin.

#### Loading Plugins

Call `loadPlugin` to register a plugin to load upon startup.

```
ApplicationSupervisor.sharedInstance.loadPlugin(MyPlugin.self)
```

#### Startup

After all plugins have been loaded, call the `startup` method to start the plugins.

```
ApplicationSupervisor.sharedInstance.startup()
```

#### Referencing Plugin APIs

Use the `pluginAPI(forIdentifier:)` method to get a reference to a plugin API.

```
guard let pluginAPI = ApplicationSupervisor.sharedInstance.pluginAPI(forIdentifier: MyPluginID) as? MyPluginAPI else {
    // plugin API not found
    return
}

let username = pluginAPI.username
```
