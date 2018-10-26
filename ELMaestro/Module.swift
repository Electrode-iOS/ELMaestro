//
//  Module.swift
//  ELMaestro
//
//  Created by Brandon Sneed on 3/22/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation

/**
 Module definition protocol.  This provides standardized logging and plugin retrieval.
 */
public protocol Module {
    static func pluginClass() -> Pluggable.Type
}

