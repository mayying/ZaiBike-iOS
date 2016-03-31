//
//  DesignFactory.h
//  ZaiBike-iOS
//
//  Created by May Ying on 30/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DesignFactory : UIViewController

@property NSArray *bgImages;
@property NSArray* bgColors;
@property NSArray* labelColors;

+ (UIImage*) getBgImage:(NSInteger) page;
+ (UIColor*) getBgColor:(NSInteger) page;
+ (UIColor*) getLabelColor:(NSInteger) page;
+ (int) getBgImageCount;

@end
