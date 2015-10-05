//
//  THGSupervisorTests.swift
//  THGSupervisorTests
//
//  Created by Brandon Sneed on 9/23/15.
//  Copyright (c) 2015 theholygrail. All rights reserved.
//

import UIKit
import XCTest
import THGSupervisor

// test plugins
import testFramework
import testObjcFramework

class THGSupervisorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBasicLoading() {
        let supervisor = ApplicationSupervisor.sharedInstance
        
        supervisor.loadPlugin(testFramework.pluginClass())
        supervisor.loadPlugin(testObjcFramework.pluginClass())
        
        supervisor.startup()
        
        XCTAssertTrue(supervisor.pluginLoaded("io.theholygrail.testplugin"))
        XCTAssertTrue(supervisor.pluginLoaded("io.theholygrail.testObjcFramework"))

        XCTAssertTrue(supervisor.pluginStarted("io.theholygrail.testplugin"))
        XCTAssertTrue(supervisor.pluginStarted("io.theholygrail.testObjcFramework"))
    }
}
