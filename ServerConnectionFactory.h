//
//  ServerConnectionFactory.h
//  ZaiBike-iOS
//
//  Created by May Ying on 30/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerConnectionFactory : UIViewController
+ (NSDictionary *) dispatcher:(NSString*) msg parameter:(NSString *) param semaphore: (dispatch_semaphore_t)sema;

@end
