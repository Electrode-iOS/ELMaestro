//
//  ApplicationSupervisor.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 5/19/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation

public final class ApplicationSupervisor: Supervisor {
    public static let sharedInstance = ApplicationSupervisor()
    public var window: UIWindow?
}
