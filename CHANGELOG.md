# [4.0.2](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v4.0.2)

- Xcode 9.3 updates

# [4.0.1](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v4.0.1)

- Satisfy `window` property requirement of `UIApplicationDelegate`

# [4.0.0](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v4.0.0)

- Migrate to Swift 4

# [3.0.0](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v3.0.0)

- Decouple `ApplicationSupervisor` from `UIApplicationDelegate`

# [2.0.6](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.6)

- Add efficient plugin lookup by id

# [2.0.5](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.5)

- Add constraints to privacy view for iPad orientations

# [2.0.4](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.4)

Use default settings for bitcode

# [2.0.3](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.3)

- Made `PluggableFeature` consistent with `UIApplicationDelegate` interface for completion handlers.

# [2.0.2](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.2)

- Fix unit tests that started failing after Swift 3 migration
  - Made `PluggableFeature` continuity API match UIAppDelegate continuity API
  - Updated mock plugin to use Swift 3 continuity API
  - Configured testFramework target to link ELMaestro to fix tests that are failing to run on Travis CI.

# [2.0.1](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.1)

- Make `Supervisor` public
- Make `ApplicationSupervisor` open to support inheritance

# [2.0.0](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v2.0.0)

- Migrate to Swift 3
- Remove ELRouter as a dependency

# [1.2.0](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v1.2.0)

- Added support for Xcode 8, Swift 2.3, and iOS SDK 10

# [1.1.1](https://github.com/Electrode-iOS/ELMaestro/releases/tag/v1.2.1)

## New Features

-  Dispatch `applicationDidFinishLaunching` to plugins once all plugins have started.  See the `PluggableFeature` protocol for function signature.
