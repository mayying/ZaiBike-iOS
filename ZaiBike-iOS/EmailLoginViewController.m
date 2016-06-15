//
//  EmailLoginViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 26/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "RegisterViewController.h"
#import "SignupViewController.h"
#import "Utilities.h"
@implementation EmailLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedManager = [DataManager sharedManager];
    [_emailTF setDelegate:self];
    [self setPage];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)loginFbBtn:(id)sender{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField{
    [textField resignFirstResponder];
    sharedManager.email = [_emailTF text];
    if ([self validateEmail:sharedManager.email]){
        NSString *param = [NSString stringWithFormat:@"action=check_exist&email=%@", sharedManager.email];
        NSLog(@"param %@", param);
        [Utilities httpPOST :param domain: @"signup" completion:^(NSDictionary *request){
            NSLog(@"emailloginviewcontroller%@", request);
            if ([request[@"status"] isEqualToString:@"fail"]){
                [Utilities alert:[NSString stringWithFormat: @"Error message: %@", request[@"reason"]] title:@"Fail" view:self];
            }else if ([request[@"status"] isEqualToString:@"new"]){
                UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RegisterViewController *view = [mySB instantiateViewControllerWithIdentifier:@"RegisterViewController"];
                [self presentViewController:view animated:YES completion:NULL];
            }else if ([request[@"status"] isEqualToString:@"exist"]){
                UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignupViewController *view = [mySB instantiateViewControllerWithIdentifier:@"SignupViewController"];
                sharedManager.signin = YES;
                [self presentViewController:view animated:YES completion:NULL];
            }else{
                [Utilities alert:@"Unknown error occured. Please contact the developer" title:@"Login/Register Error" view:self];
            }
        }];
    }else{
        [Utilities alert:@"Please register/login with your registered email address" title:@"Invalid Email" view:self];
    }

    return YES;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSLog(@"email %@", candidate);
    return [emailTest evaluateWithObject:candidate];
}

-(void)setPage{
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

    _label_0.textColor = [Utilities getLabelColor:(NSInteger)sharedManager.currentPage];
    _label_1.textColor = [Utilities getLabelColor:(NSInteger)sharedManager.currentPage];
    _emailTF.textColor = [Utilities getLabelColor:(NSInteger)sharedManager.currentPage];
    
}
@end
