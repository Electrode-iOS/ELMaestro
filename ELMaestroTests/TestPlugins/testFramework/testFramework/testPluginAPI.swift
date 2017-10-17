//
//  testPluginAPI.swift
//  testFramework
//
//  Created by Steve Riggins on 7/8/16.
//  Copyright © 2016 StereoLab. All rights reserved.
//

import Foundation

open class TestPluginAPI : NSObject {    
    open var continuityType: String = ""
}

final class TestDelegate: ApplicationDelegateProxy {
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        return true
    }
}
