//
//  Route.swift
//  THGSupervisor
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 theholygrail. All rights reserved.
//

import Foundation

@objc
public enum RoutingType: UInt {
    case Tab
    case Screen
    case Modal
    case Other // ??
}

@objc
public class Route: NSObject {
    // the type of route happening.
    let type: RoutingType
    // the destination of the route, ie: tab 5 or a given ViewController
    // object type determined by RoutingType
    let destination: AnyObject
    // any further Routes that need to take place will be contained here
    let routes: [Route]
    
    init(type: RoutingType, destination: AnyObject, routes: [Route]) {
        self.type = type
        self.destination = destination
        self.routes = routes
    }
}

