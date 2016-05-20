//
//  TestObjcClass.h
//  testObjcFramework
//
//  Created by Brandon Sneed on 6/21/15.
//  Copyright (c) 2015 StereoLab. All rights reserved.
//

#import <Foundation/Foundation.h>
@import ELMaestro;

@interface TestObjcClass : NSObject<Pluggable>

@property(nonatomic, copy, readonly) NSString * _Nonnull identifier;
@property(nonatomic, copy, readonly) NSArray<DependencyID *> * _Nullable dependencies;

- (Route * _Nullable)startup:(Supervisor * _Nonnull)supervisor;

@end
