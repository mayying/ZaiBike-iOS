//
//  UIColor.m
//  ZaiBike-iOS
//
//  Created by May Ying on 20/6/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "UIColor.h"

@implementation CALayer(UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
