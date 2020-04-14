//
//  Plugin.swift
//  ELMaestro
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation
import UIKit

public typealias DependencyID = String

public protocol Pluggable {
    var identifier: DependencyID { get }
    var dependencies: [DependencyID]? { get }

    init?(containerBundleID: String?)

    // Provides the default route to this plugin or feature.
    func startup(_ supervisor: Supervisor)

    /// API factory method for a module's API it exports.
    func pluginAPI() -> AnyObject?
}

public extension Pluggable {
    func dependsOn(_ dependencyID: DependencyID) -> Bool {
        if let deps = dependencies {
            return deps.contains(dependencyID)
        }
        return false
    }
    
    func pluginDescription() -> String {
        var result = "\(identifier)\n"
        
        if let deps = dependencies {
            for i in 0..<deps.count {
                result += "  (\(deps[i]))\n"
            }
        }
        
        return result
    }    
}
