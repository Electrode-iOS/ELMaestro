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

- (NSArray<DependencyID *> * _Nullable)dependencies {
    return nil;
}

- (instancetype)initWithContainerBundleID:(NSString *)containerBundleID {
    self = [super init];
    return self;
}


- (void)startup:(Supervisor * _Nonnull)supervisor {
}

@end
