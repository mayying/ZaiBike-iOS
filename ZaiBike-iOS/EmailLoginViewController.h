//
//  EmailLoginViewController.h
//  ZaiBike-iOS
//
//  Created by May Ying on 26/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface EmailLoginViewController : UIViewController <UITextViewDelegate>{
    DataManager *sharedManager;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *label_0;
@property (weak, nonatomic) IBOutlet UILabel *label_1;
- (IBAction)loginFbBtn:(id)sender;
- (void) setPage;


@end
