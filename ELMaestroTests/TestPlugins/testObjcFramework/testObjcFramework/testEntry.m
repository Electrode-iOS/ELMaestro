//
//  testEntry.m
//  testObjcFramework
//
//  Created by Brandon Sneed on 6/17/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "testEntry.h"

@import ELMaestro;

extern Class<Pluggable> _Nonnull pluginClass() {
    //return nil;
    return [TestObjcClass class];
}
