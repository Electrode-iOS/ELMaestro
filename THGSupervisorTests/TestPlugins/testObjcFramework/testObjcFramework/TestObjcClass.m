//
//  TestObjcClass.m
//  testObjcFramework
//
//  Created by Brandon Sneed on 6/21/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

#import "TestObjcClass.h"

@implementation TestObjcClass

// Pluggable interface

- (NSString * _Nonnull)identifier {
    return [NSBundle bundleForClass:[TestObjcClass class]].bundleIdentifier;
}

- (NSArray<NSString *> * _Nullable)dependencies {
    return nil;
}

- (instancetype)initWithContainedBundleID:(NSString *)containedBundleID {
    self = [super init];
    return self;
}


- (Route * _Nullable)startup:(Supervisor * _Nonnull)supervisor {
    return nil;
}

@end
