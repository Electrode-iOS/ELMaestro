//
//  ApplicationSupervisor.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 5/19/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation

@objc
public final class ApplicationSupervisor: Supervisor {
    @objc public static let sharedInstance = ApplicationSupervisor()
    public var window: UIWindow?
    public var navigator: SupervisorNavigator?
    
    /// This property can be set to show a privacy view on top of the visible view controller.
    public var backgroundPrivacyView: UIView = ApplicationSupervisor.defaultPrivacyView()
    /// The default value is Opt-In.
    public var backgroundPrivacyOptions = BackgroundPrivacyOptions.optIn
}
