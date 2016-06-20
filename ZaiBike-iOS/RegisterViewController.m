//
//  RegisterViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 1/4/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "RegisterViewController.h"
#import "Utilities.h"
#import "EmailLoginViewController.h"
#import "SignupViewController.h"
@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedManager = [DataManager sharedManager];
    [self setPage];
    [_digit_0 setDelegate:self];
    [_digit_1 setDelegate:self];
    [_digit_2 setDelegate:self];
    [_digit_3 setDelegate:self];
    if (sharedManager.digit0 != NULL && sharedManager.digit1 != NULL && sharedManager.digit2 != NULL && sharedManager.digit3 != NULL){
        NSArray *digits = @[sharedManager.digit0, sharedManager.digit1, sharedManager.digit2, sharedManager.digit3];
        NSArray *digitTFs = @[_digit_0, _digit_1, _digit_2, _digit_3];
        for (int i = 0; i < [digits count]; i++){
            // Delay execution of my block for 10 seconds.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"Object%@", [digitTFs objectAtIndex:i]);
                [[digitTFs objectAtIndex:i] setText:[digits objectAtIndex:i]];
                if (i == [digits count] - 1){
                    [self verifyCode];
                }
            });
        }
    }
    
    [_digit_0 becomeFirstResponder];

    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}


- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}


-(void)setPage{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    CIImage *inputImage = [CIImage imageWithCGImage:[[Utilities getBgImage: (NSInteger) sharedManager.currentPage] CGImage]];
    [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@25 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[inputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    CGRect frame = self.view.bounds;
    
    UIImageView *newPageView = [[UIImageView alloc] initWithImage:image];
    newPageView.contentMode = UIViewContentModeScaleAspectFit;
    newPageView.frame = frame;
    self.view.backgroundColor = [Utilities getBgColor:(NSInteger)sharedManager.currentPage];
    [self.view addSubview:newPageView];
    
    _label_0.textColor = [Utilities getLabelColor:(NSInteger)sharedManager.currentPage];
    [self.view sendSubviewToBack:newPageView];

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        if (textField.tag == 1) {
            [_digit_0 becomeFirstResponder];
            _digit_1.text = @"";
        }else if (textField.tag == 2){
            [_digit_1 becomeFirstResponder];
            _digit_2.text = @"";
        }else if (textField.tag == 3){
            [_digit_2 becomeFirstResponder];
            _digit_3.text = @"";
        }else if (textField.tag == 0){
            _digit_0.text = @"";
        }
        NSLog(@"Backspace");
        return NO;
    }
    
    return YES;
}

- (IBAction)backButton:(id)sender {
    UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmailLoginViewController *view = [mySB instantiateViewControllerWithIdentifier:@"EmailLoginViewController"];
    [self presentViewController:view animated:YES completion:NULL];
}

- (void)triggerShakeAnimation:(UIView*) view {
    const int MAX_SHAKES = 6;
    const CGFloat SHAKE_DURATION = 0.05;
    const CGFloat SHAKE_TRANSFORM = 4;
    
    CGFloat direction = 1;
    
    for (int i = 0; i <= MAX_SHAKES; i++) {
        [UIView animateWithDuration:SHAKE_DURATION
                              delay:SHAKE_DURATION * i
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             if (i >= MAX_SHAKES) {
                                 view.transform = CGAffineTransformIdentity;
                             } else {
                                 view.transform = CGAffineTransformMakeTranslation(SHAKE_TRANSFORM * direction, 0);
                             }
                         } completion:nil];
        
        direction *= -1;
    }
}

- (void) verifyCode{
    NSString *veriCode = @"";
    veriCode = [veriCode stringByAppendingString:_digit_0.text];
    veriCode = [veriCode stringByAppendingString:_digit_1.text];
    veriCode = [veriCode stringByAppendingString:_digit_2.text];
    veriCode = [veriCode stringByAppendingString:_digit_3.text];
    NSLog(@"verificationcode %@", veriCode);
    NSString *param = [NSString stringWithFormat:@"action=verify&email=%@&verification=%@", sharedManager.email, veriCode];
    [Utilities httpPOST :param domain: @"signup" completion:^(NSDictionary *request){
        if([request[@"status"] isEqualToString:@"verified"]){
            [UIView animateWithDuration:2.0f delay:1.5f options:UIViewAnimationOptionTransitionNone animations:^{
                [_warningMsg setText:@"Verified!"];
                [_warningMsg setTextColor:[UIColor colorWithRed:0/255.0f green:139/255.0f blue:0/255.0f alpha:1]];
                [_warningMsg setHidden:NO];
            } completion:^(BOOL finished){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        SignupViewController *view = [mySB instantiateViewControllerWithIdentifier:@"SignupViewController"];
                        [self presentViewController:view animated:YES completion:NULL];
                });
                
            }];
        }else if ([request[@"status"] isEqualToString:@"fail"]){
            if ([request[@"reason"] isEqualToString:@"wrong verification"]){
                _digit_0.text = @"";
                _digit_1.text = @"";
                _digit_2.text = @"";
                _digit_3.text = @"";
                
                [_digit_0 becomeFirstResponder];
                
                [self triggerShakeAnimation:_digit_0];
                [self triggerShakeAnimation:_digit_1];
                [self triggerShakeAnimation:_digit_2];
                [self triggerShakeAnimation:_digit_3];
                
                [_warningMsg setHidden:NO];
            }
        }
    }];
}

- (IBAction)digitField:(id)sender {
    NSLog(@"triggered me!");
    [_digit_0 becomeFirstResponder];
    if ([_digit_3.text length] == 1 && [_digit_2.text length] == 1 && [_digit_1.text length] == 1 && [_digit_0.text length] == 1){
        if([self validateDigit:_digit_3.text] && [self validateDigit:_digit_2.text] && [self validateDigit:_digit_1.text] && [self validateDigit:_digit_0.text]){
            [self verifyCode];
        }else{
            _digit_3.text = @"";
        }
    }else if ([_digit_2.text length] == 1 && [_digit_1.text length] == 1 && [_digit_0.text length] == 1  && [_digit_3.text length] == 0){
        if([self validateDigit:_digit_2.text] && [self validateDigit:_digit_1.text] && [self validateDigit:_digit_0.text]){
            [_digit_3 becomeFirstResponder];
        }else{
            _digit_2.text = @"";
        }
    }else if ([_digit_1.text length] == 1 && [_digit_0.text length] == 1 && [_digit_2.text length] == 0 && [_digit_3.text length] == 0){
        if ([self validateDigit:_digit_1.text] && [self validateDigit:_digit_0.text]){
            [_digit_2 becomeFirstResponder];
        }else{
            _digit_1.text = @"";
        }
    }else if ([_digit_0.text length] == 1 && [_digit_1.text length] == 0 && [_digit_2.text length] == 0 && [_digit_3.text length] == 0){
        if ([self validateDigit:_digit_0.text]){
            [_digit_1 becomeFirstResponder];
        }else{
            _digit_0.text = @"";
        }
    }else{
        NSLog(@"exceeeddd");
        if ([_digit_0.text length] > 1){
            _digit_0.text = [_digit_0.text substringWithRange:NSMakeRange(0,1)];
        }
        if ([_digit_1.text length] > 1){
            _digit_1.text = [_digit_1.text substringWithRange:NSMakeRange(0,1)];
        }
        if ([_digit_2.text length] > 1){
            _digit_2.text = [_digit_2.text substringWithRange:NSMakeRange(0,1)];
        }
        if ([_digit_3.text length] > 1){
            _digit_3.text = [_digit_3.text substringWithRange:NSMakeRange(0,1)];
        }
    }
    
}

- (BOOL) validateDigit: (NSString *) candidate {
    NSString *passcodeRegex = @"[0-9]{1}";
    NSPredicate *passcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passcodeRegex];
    NSLog(@"passcode %@", candidate);
    return [passcodeTest evaluateWithObject:candidate];
}

@end
