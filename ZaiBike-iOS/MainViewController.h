//
//  MainViewController.h
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (nonatomic, weak) IBOutlet UIButton *confirmBtn;
- (IBAction)confirm:(id)sender;
- (void)alert:(NSString *)msg;

@end
