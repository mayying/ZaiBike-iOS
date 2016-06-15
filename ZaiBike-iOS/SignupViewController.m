//
//  SignupViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 3/6/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "SignupViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "EmailLoginViewController.h"
#import "Utilities.h"

@implementation SignupViewController

- (void) viewDidLoad{
    sharedManager = [DataManager sharedManager];
    [self setPage];
    [_textfield setDelegate:self];
    if (sharedManager.step == 1){
        [_label_0 setText:@"Please create a password of length between 8 to 16"];
        [_textfield setText:@""];
        [_textfield setSecureTextEntry:YES];
        [_textfield setPlaceholder:@"Password"];
        [_forgetPwButton setHidden:YES];
        sharedManager.signin = NO;
    }else if (sharedManager.signin == YES){
        [_label_0 setText:@"Welcome back! Please enter your password!"];
        [_textfield setText:@""];
        [_textfield setSecureTextEntry:YES];
        [_textfield setPlaceholder:@"Password"];
        [_forgetPwButton setHidden:NO];
    }else{
        [_forgetPwButton setHidden:YES];
        sharedManager.signin = NO;
    }
    
    [_textfield becomeFirstResponder];
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
        if (sharedManager.step == 1 && !sharedManager.signin){
            [_label_0 setText:@"What's your name?"];
            [_textfield setText: _fullName];
            [_textfield setSecureTextEntry:NO];
            [_textfield setPlaceholder:@"Full name"];
            sharedManager.step -= 1;
        }else if (sharedManager.step == 2){
            [_label_0 setText:@"Please create a password of length 8 to 16."];
            [_textfield setText: _password];
            [_textfield setSecureTextEntry:YES];
            [_textfield setPlaceholder:@"Password"];
            sharedManager.step -= 1;
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField{
    [_warning setHidden:YES];
    if (sharedManager.signin == YES){
        [textField resignFirstResponder];
        NSString *password = [_textfield text];
        
        if ([password length] == 0){
            [_warning setText:@"Invalid password length"];
            [_warning setHidden:NO];

            return NO;
        }else{
            NSString *param = [NSString stringWithFormat:@"action=signin&email=%@&password=%@", sharedManager.email, password];
            [Utilities httpPOST :param domain: @"signup" completion:^(NSDictionary *request){
                if ([request[@"status"] isEqualToString:@"fail"]){
                    [_warning setText:@"Incorrect password. Please try again"];
                    [_warning setHidden:NO];
                }else if ([request[@"status"] isEqualToString:@"ok"]){
                    long long unsigned int userID = [request[@"user_id"] longLongValue];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%llu", userID] forKey:@"user_id"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    // Instantiate View Controller from Storyboard
                    UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MainViewController *view = [mySB instantiateViewControllerWithIdentifier:@"MainViewController"];
                    [self presentViewController:view animated:YES completion:NULL];
                }
            }];
        }
        return YES;
        
    }else if (sharedManager.step == 0){
        _fullName = [textField text];
        [_label_0 setText:@"Please create a password of length between 8 to 16."];
        [_textfield setText:@""];
        [textField setSecureTextEntry:YES];
        [_textfield setPlaceholder:@"Password"];
        [_textfield setReturnKeyType:UIReturnKeyNext];
    }else if (sharedManager.step == 1){
        _password = [textField text];
    
        if ([_password length] < 8){
            [_warning setText:@"Password too short."];
            [_warning setHidden:NO];
            return NO;
        }else if ([_password length] > 16){
            [_warning setText:@"Password too long."];
            [_warning setHidden:NO];
            return NO;
        }
        
        [_label_0 setText:@"Please re-enter your password."];
        [_textfield setText:@""];
        [textField setSecureTextEntry:YES];
        [_textfield setPlaceholder:@"Password"];
        [_textfield setReturnKeyType:UIReturnKeyGo];
    }else if (sharedManager.step == 2){
        _confirmPassword = [textField text];
        NSLog(@"password %@%@", _password, _confirmPassword);
        if(![_password isEqualToString:_confirmPassword]){
            [_warning setText:@"Password mismatch!"];
            [_warning setHidden:NO];
            return NO;
        }
        
        NSString *param;
        if (sharedManager.signin){
            param = [NSString stringWithFormat:@"action=change_pw&email=%@&password=%@", sharedManager.email, _password];
        }
        param = [NSString stringWithFormat:@"action=create_acc&email=%@&password=%@&name=%@", sharedManager.email, _password, _fullName];
        [Utilities httpPOST :param domain: @"signup" completion:^(NSDictionary *request){
            if ([request[@"status"] isEqualToString:@"fail"]){
                [Utilities alert:[NSString stringWithFormat: @"Error message: %@", request[@"reason"]] title:@"Fail" view:self];
            }else if ([request[@"status"] isEqualToString:@"ok"]){
                long long unsigned int userID = [request[@"user_id"] longLongValue];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%llu", userID] forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // Instantiate View Controller from Storyboard
                UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainViewController *view = [mySB instantiateViewControllerWithIdentifier:@"MainViewController"];
                [self presentViewController:view animated:YES completion:NULL];
            }
        }];
    }
    sharedManager.step += 1;
    [textField becomeFirstResponder];
    
    return YES;
}

- (IBAction)forgotPwBtn:(id)sender {
    NSString *param = [NSString stringWithFormat:@"action=forgot_pw&email=%@", sharedManager.email];
    [Utilities httpPOST :param domain: @"signup" completion:^(NSDictionary *request){
        if ([request[@"status"] isEqualToString:@"verify"]){
            UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RegisterViewController *view = [mySB instantiateViewControllerWithIdentifier:@"RegisterViewController"];
            sharedManager.step = 1;
            [self presentViewController:view animated:YES completion:NULL];
            
        }else{
            [Utilities alert:@"Unknown error occured. Please contact the developer" title:@"Change Password Error" view:self];
        }
    }];
    
    
}


- (IBAction)loginFbBtn:(id)sender {
    
}

- (void)setPage{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    CIImage *inputImage = [CIImage imageWithCGImage:[[Utilities getBgImage:(NSInteger)sharedManager.currentPage] CGImage]];
    [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@25 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[inputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    
    CGRect frame = self.view.bounds;
    
    UIImageView *newPageView = [[UIImageView alloc] initWithImage:image];
    newPageView.contentMode = UIViewContentModeScaleAspectFit;
    newPageView.frame = frame;
    self.view.backgroundColor = [Utilities getBgColor:(NSInteger)sharedManager.currentPage];
    [self.view addSubview:newPageView];
    
    _label_0.textColor = [Utilities getLabelColor:(NSInteger) sharedManager.currentPage];
    _label_1.textColor = [Utilities getLabelColor:(NSInteger) sharedManager.currentPage];
    _textfield.textColor = [Utilities getLabelColor:(NSInteger) sharedManager.currentPage];
}


- (IBAction)changeEmail:(id)sender {
    UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmailLoginViewController *view = [mySB instantiateViewControllerWithIdentifier:@"EmailLoginViewController"];
    [self presentViewController:view animated:YES completion:NULL];
    sharedManager.digit0 = NULL;
    sharedManager.digit1 = NULL;
    sharedManager.digit2 = NULL;
    sharedManager.digit3 = NULL;
    
}
@end
