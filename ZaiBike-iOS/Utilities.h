//
//  Utitlies.h
//  ZaiBike-iOS
//
//  Created by May Ying on 28/5/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utilities : UIViewController
@property NSArray *bgImages;
@property NSArray* bgColors;
@property NSArray* labelColors;

+ (UIImage*) getBgImage:(NSInteger) page;
+ (UIColor*) getBgColor:(NSInteger) page;
+ (UIColor*) getLabelColor:(NSInteger) page;
+ (int) getBgImageCount;
+ (NSDictionary *) httpPOST : (NSString *) params domain: (NSString*) domainName completion:(void (^)(NSDictionary *)) completion;
+ (void)alert:(NSString *) msg title:(NSString *) t view:(UIViewController *) v;

@end
