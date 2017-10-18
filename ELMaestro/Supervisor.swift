//
//  Supervisor.swift
//  ELMaestro
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation
import ELLog

@objc
public class Supervisor: NSObject {
    internal private(set) var startedPlugins = [String: Pluggable]()
    
    /// Get all of the started plugins that conform to PluggableFeature
    internal private(set) var startedFeaturePlugins = [PluggableFeature]()
    
    // unordered, keyed collection of started plugins for faster lookup
    private var proposedPlugins = [Pluggable]()
    private var loadedPlugins = [Pluggable]()
    
    public func loadPlugin(_ pluginType: AnyObject.Type) {
        // I used AnyObject.Type here, because Pluggable.Type translates
        // to Class<Pluggable> in objc, but returns an AnyObject.Type instead.
        
        // WARNING: Don't step through this, or you'll crash Xcode.. cuz it sucks.
        if let pluginType = pluginType as? Pluggable.Type {
            if let plugin = pluginType.init(containerBundleID: "com.walmart.ELMaestro") {
                proposedPlugins.append(plugin)
            }
        }
        // END WARNING.
    }
    
    public func loadPlugins(_ pluginTypes: [Pluggable.Type]) {
        for plugin in pluginTypes {
            loadPlugin(plugin)
        }
    }
    
    public func startup() {
        // identify the plugins we will actually load.
        loadedPlugins = validateProposedPlugins(proposedPlugins)
        
        for i in 0..<loadedPlugins.count {
            let plugin = loadedPlugins[i]
            
            start(plugin: plugin)
        }
        
        for (_, plugin) in startedPlugins {
            if let featurePlugin = plugin as? PluggableFeature {
                startedFeaturePlugins.append(featurePlugin)
            }
        }
    }
    
    public func pluginLoaded(dependencyID: DependencyID) -> Bool {
        return loadedPlugins.contains(where: { (item) -> Bool in
            return (item.identifier == dependencyID)
        })
    }
    
    public func pluginStarted(dependencyID: DependencyID) -> Bool {
        for (_, plugin) in startedPlugins where plugin.identifier == dependencyID {
            return true
        }
        return false
    }
    
    public func pluginAPI(forIdentifier id: DependencyID) -> AnyObject? {
        var result: AnyObject? = nil
        
        if let plugin = plugin(forIdentifier: id) as? PluggableFeature {
            result = plugin.pluginAPI?()
        }
        
        return result
    }
    
    private func plugin(forIdentifier id: DependencyID) -> Pluggable? {
        return startedPlugins[id.lowercased()]
    }
    
    private func start(plugin: Pluggable) {
        if !pluginStarted(dependencyID: plugin.identifier) {
            log(.Debug, "starting: \(plugin.identifier)")
            
            // try find any dependencies that haven't been started yet.
            if let deps = plugin.dependencies {
                for i in 0..<deps.count {
                    if let dep = self.plugin(forIdentifier: deps[i]) {
                        // if it's already loaded, this does nothing.
                        start(plugin: dep)
                    }
                }
            }
            
            plugin.startup(self)

            let lowercasedIdentifier = plugin.identifier.lowercased()
            guard startedPlugins[lowercasedIdentifier] == nil else {
                assertionFailure("tried to started more than one plugin with id \(plugin.identifier)!")
                return
            }
            startedPlugins[plugin.identifier.lowercased()] = plugin
            log(.Debug, "started: \(plugin.identifier)")
        }
    }
    
    private func validateProposedPlugins(_ proposedPlugins: [Pluggable]) -> [Pluggable] {
        var acceptedPlugins = [Pluggable]()
        
        for i in 0..<proposedPlugins.count {
            log(.Debug, "checking proposal: \(proposedPlugins[i].identifier).")
            var hasDeps = true
            // look at the dependencies and make sure they're all there.
            if let deps = proposedPlugins[i].dependencies {
                for item in deps {
                    let present = proposedPlugins.contains { (plugin) -> Bool in
                        return (plugin.identifier == item)
                    }
                    
                    // the dependency is present, validate it.
                    if present {
                        hasDeps = true
                        acceptedPlugins.append(proposedPlugins[i])
                    } else {
                        log(.Error, "ERROR: proposed plugin \(item) is missing dependency \(item).")
                    }
                }
            } else {
                // it doesn't have any dependencies, so it's validated.
                hasDeps = false
                acceptedPlugins.append(proposedPlugins[i])
            }
            let subtext = hasDeps ? "(dependencies present)" : "(no dependencies required)"
            log(.Debug, "validating proposal: \(proposedPlugins[i].identifier) \(subtext)")
        }
        
        return acceptedPlugins
    }
}
