//
//  SignupViewController.h
//  ZaiBike-iOS
//
//  Created by May Ying on 3/6/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
@interface SignupViewController : UIViewController <UITextViewDelegate>{
    DataManager *sharedManager;
}

@property (weak, nonatomic) IBOutlet UILabel *label_0;
@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UILabel *warning;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *password;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwButton;
@property (strong, nonatomic) NSString *confirmPassword;
- (IBAction)forgotPwBtn:(id)sender;
- (IBAction)loginFbBtn:(id)sender;
- (IBAction)changeEmail:(id)sender;
@end
