//
//  testEntry.h
//  testObjcFramework
//
//  Created by Brandon Sneed on 6/21/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

#ifndef testObjcFramework_testEntry_h
#define testObjcFramework_testEntry_h

/**
 
 This header has to be included in the public-header space in the project settings.
 
 */

#import <testObjcFramework/TestObjcClass.h>
#import <THGSupervisor/THGSupervisor-Swift.h>

extern Class<Pluggable> __nullable pluginClass();

#endif
