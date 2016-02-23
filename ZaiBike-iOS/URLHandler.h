//
//  URLHandler.h
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLHandler : UIViewController

- (NSDictionary *) httpPOST: (NSString *)param completion:(void(^)(NSDictionary *))completion;
@end
