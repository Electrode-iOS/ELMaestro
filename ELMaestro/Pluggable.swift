//
//  Plugin.swift
//  ELMaestro
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation
import UIKit

/* 

Plugin implementor provides a top level function in their bundle defined as:

swift: public func pluginInit(appBundleID: String, supervisor: Supervisor) -> Plugin?
objc : extern MyPluginClass * __nullable pluginForBundle(NSString * __nonnull appBundleID, Supervisor * __nonnull supervisor);

*/

public typealias DependencyID = String

@objc
public protocol Pluggable {
    var identifier: DependencyID { get }
    var dependencies: [DependencyID]? { get }

    init?(containerBundleID: String?)

    // Provides the default route to this plugin or feature.
    func startup(supervisor: Supervisor)
}

public extension Pluggable {
    func dependsOn(dependencyID: DependencyID) -> Bool {
        if let deps = dependencies {
            return deps.contains(dependencyID)
        }
        return false
    }
    
    func pluginDescription() -> String {
        var result = ""
        
        result += "\(identifier)\n"
        
        if let deps = dependencies {
            for i in 0..<deps.count {
                result += "  (\(deps[i]))\n"
            }
        }
        
        return result
    }    
}


