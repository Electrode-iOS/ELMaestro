//
//  TestPluginAPI.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 10/19/17.
//  Copyright © 2017 WalmartLabs. All rights reserved.
//

import Foundation
import XCTest

final class TestPluginAPI : NSObject {
    var continuityType: String = ""

    var applicationWillFinishLaunchingWithOptionsCalled: XCTestExpectation?
    var applicationDidFinishLaunchingWithOptionsCalled: XCTestExpectation?
    var applicationWillResignActiveCalled: XCTestExpectation?
    var applicationDidEnterBackgroundCalled: XCTestExpectation?
    var applicationWillEnterForegroundCalled: XCTestExpectation?
    var applicationDidBecomeActiveCalled: XCTestExpectation?
    var applicationWillTerminateCalled: XCTestExpectation?
    var applicationDidReceiveMemoryWarningCalled: XCTestExpectation?
    var didRegisterUserNotificationSettingsCalled: XCTestExpectation?
    var handleActionWithIdentifierForLocalNotificationWithResponseInfoCalled: XCTestExpectation?
    var didRegisterForRemoteNotificationsWithDeviceTokenCalled: XCTestExpectation?
    var didFailToRegisterForRemoteNotificationsWithErrorCalled: XCTestExpectation?
    var didReceiveRemoteNotificationCalled: XCTestExpectation?
    var handleActionWithIdentifierForRemoteNotificationCalled: XCTestExpectation?
    var handleActionWithIdentifierForLocalNotificationCalled: XCTestExpectation?
    var handleActionWithIdentifierWithResponseInfoCalled: XCTestExpectation?
    var performActionForShortcutItemCalled: XCTestExpectation?
    var didReceiveLocalNotificationCalled: XCTestExpectation?
}
