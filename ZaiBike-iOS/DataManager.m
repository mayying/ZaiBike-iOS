//
//  DataManager.m
//  ZaiBike-iOS
//
//  Created by May Ying on 8/6/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize step;
@synthesize signin;
@synthesize currentPage;
@synthesize email;
@synthesize digit0;
@synthesize digit1;
@synthesize digit2;
@synthesize digit3;

+ (id) sharedManager{
//    static DataManager *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//    });
//    return sharedMyManager;
    static DataManager *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil)
            sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (id) init{
    if (self = [super init]){
        NSLog(@"self %@", self);
        NSLog(@"enter here???????? %@", self);

        step = 0;
        signin = NO;
        currentPage = NULL;
        email = NULL;
        digit0 = NULL;
        digit1 = NULL;
        digit2 = NULL;
        digit3 = NULL;
    }
    return self;
}

@end
