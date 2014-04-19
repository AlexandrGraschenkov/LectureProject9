//
//  SomeObj.m
//  TestRequestAPP
//
//  Created by Alexander on 17.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "SomeObj.h"

@implementation SomeObj

+ (instancetype)sharedInstance
{
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"%@", @"thread safe");
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

+ (instancetype)sharedInstance2
{
    static id _singleton = nil;
    if(!_singleton){
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"%@", @"not thread safe");
        _singleton = [[self alloc] init];
    };
    return _singleton;
}

@end
