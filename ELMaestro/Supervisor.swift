//
//  Supervisor.swift
//  ELMaestro
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation

@objc
public class Supervisor: NSObject {
    var startedPlugins = [Pluggable]()
    
    /// Get all of the started plugins that conform to PluggableFeature
    var startedFeaturePlugins: [PluggableFeature] {
        return startedPlugins.compactMap { $0 as? PluggableFeature }
    }
    
    // unordered, keyed collection of started plugins for faster lookup
    private var startedPluginsLookup = [String: Pluggable]()
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
    }
    
    public func pluginLoaded(dependencyID: DependencyID) -> Bool {
        return loadedPlugins.contains(where: { (item) -> Bool in
            return (item.identifier == dependencyID)
        })
    }
    
    public func pluginStarted(dependencyID: DependencyID) -> Bool {
        return startedPlugins.contains(where: { (item) -> Bool in
            return (item.identifier == dependencyID)
        })
    }
    
    @objc public func pluginAPI(forIdentifier id: DependencyID) -> Any? {
        var result: AnyObject? = nil
        
        if let plugin = plugin(forIdentifier: id) as? PluggableFeature {
            result = plugin.pluginAPI?()
        }
        
        return result
    }
    
    private func plugin(forIdentifier id: DependencyID) -> Pluggable? {
        return startedPluginsLookup[id.lowercased()]
    }
    
    private func start(plugin: Pluggable) {
        if !pluginStarted(dependencyID: plugin.identifier) {
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
            startedPlugins.append(plugin)
            let lowercasedIdentifier = plugin.identifier.lowercased()
            guard startedPluginsLookup[lowercasedIdentifier] == nil else {
                assertionFailure("tried to started more than one plugin with id \(plugin.identifier)!")
                return
            }
            startedPluginsLookup[plugin.identifier.lowercased()] = plugin
        }
    }
    
    private func validateProposedPlugins(_ proposedPlugins: [Pluggable]) -> [Pluggable] {
        var acceptedPlugins = [Pluggable]()
        
        for i in 0..<proposedPlugins.count {
            // look at the dependencies and make sure they're all there.
            if let deps = proposedPlugins[i].dependencies {
                for item in deps {
                    let present = proposedPlugins.contains { (plugin) -> Bool in
                        return (plugin.identifier == item)
                    }
                    
                    // the dependency is present, validate it.
                    if present {
                        acceptedPlugins.append(proposedPlugins[i])
                    } else {
                        assertionFailure("ERROR: proposed plugin \(item) is missing dependency \(item).")
                    }
                }
            } else {
                // it doesn't have any dependencies, so it's validated.
                acceptedPlugins.append(proposedPlugins[i])
            }
        }
        
        return acceptedPlugins
    }
}
