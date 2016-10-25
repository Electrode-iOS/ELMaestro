# [1.1.2](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v1.1.2)

## New Features

- Added support for Continuity by extending the `PluggableFeature` protocol and dispatching to plugins that implement the API.

## Fixes

- Refactored `ApplicationSupervisor.sharedInstance` to return the shared application’s app delegate.
- Added work-around for known bug in iOS 10.0.x where `application(application, didReceiveRemoteNotification, fetchCompletionHandler)` is not called in backgrounded app case

# [1.1.1](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v1.1.1)

## New Features

-  Dispatch `applicationDidFinishLaunching` to plugins once all plugins have started.  See the `PluggableFeature` protocol for function signature.
