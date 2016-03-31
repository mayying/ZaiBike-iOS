//
//  DesignFactory.m
//  ZaiBike-iOS
//
//  Created by May Ying on 30/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "DesignFactory.h"

static NSArray *bgImages;
static NSArray *bgColors;
static NSArray *labelColors;

@implementation DesignFactory

+ (UIImage*) getBgImage:(NSInteger)page{
    
    bgImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"login_pc1.png"],
                [UIImage imageNamed:@"login_pc2.png"],
                [UIImage imageNamed:@"login_pc3.png"],
                nil];
    
    return [bgImages objectAtIndex:page];
}

+ (UIColor*) getBgColor: (NSInteger) page{
    bgColors = [[NSArray alloc]initWithObjects:
                [UIColor colorWithRed:255/255.0f green:248/255.0f blue:227/255.0f alpha:1],
                [UIColor colorWithRed:75/255.0f green:190/255.0f blue:208/255.0f alpha:1],
                [UIColor colorWithRed:222/255.0f green:189/255.0f blue:149/255.0f alpha:1], nil];
    
    
    return [bgColors objectAtIndex:page];
}

+ (UIColor*) getLabelColor:(NSInteger)page{
    
    labelColors = [[NSArray alloc] initWithObjects:
                   [UIColor blackColor],
                   [UIColor whiteColor],
                   [UIColor blackColor],nil];
    
    
    
    return [labelColors objectAtIndex:page];
}

+ (int) getBgImageCount{
    
    bgImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"login_pc1.png"],
                [UIImage imageNamed:@"login_pc2.png"],
                [UIImage imageNamed:@"login_pc3.png"],
                nil];
    return (int)[bgImages count];
}

@end
