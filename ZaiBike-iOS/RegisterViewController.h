//
//  RegisterViewController.h
//  ZaiBike-iOS
//
//  Created by May Ying on 1/4/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>{
    DataManager *sharedManager;
}
@property (weak, nonatomic) IBOutlet UILabel *label_0;
@property (weak, nonatomic) IBOutlet UITextField *digit_0;
@property (weak, nonatomic) IBOutlet UITextField *digit_1;
@property (weak, nonatomic) IBOutlet UITextField *digit_2;
@property (weak, nonatomic) IBOutlet UITextField *digit_3;
@property (weak, nonatomic) IBOutlet UILabel *warningMsg;
- (IBAction)backButton:(id)sender;
- (IBAction)digitField:(id)sender;

@end
