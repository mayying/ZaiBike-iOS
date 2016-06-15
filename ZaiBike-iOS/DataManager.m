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
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

- (id) init{
    if (self == [super init]){
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
