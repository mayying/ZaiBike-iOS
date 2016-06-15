//
//  DataManager.h
//  ZaiBike-iOS
//
//  Created by May Ying on 8/6/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataManager : NSObject{

    int step;
    BOOL signin;
    NSInteger* currentPage;
    NSString* email;
    NSString* digit0;
    NSString* digit1;
    NSString* digit2;
    NSString* digit3;
}

@property (assign, nonatomic) int step;
@property (assign, nonatomic) BOOL signin;
@property (assign, nonatomic) NSInteger *currentPage;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString* digit0;
@property (strong, nonatomic) NSString* digit1;
@property (strong, nonatomic) NSString* digit2;
@property (strong, nonatomic) NSString* digit3;

+ (id) sharedManager;

@end
