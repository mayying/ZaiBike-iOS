//
//  EmailLoginViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 26/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "DesignFactory.h"
#import "ServerConnectionFactory.h"

@implementation EmailLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)loginEmailBtn:(id)sender{
    NSString* email = [_emailTF text];
    if ([self validateEmail:email]){
        NSString *param = [NSString stringWithFormat:@"action=check_exist&email=%@", email];
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSDictionary* output = [ServerConnectionFactory dispatcher: @"emailLogin" parameter: param semaphore:sema];
        NSLog(@"output %@", output);
    }else{
        [self alert:@"Please register/login with your registered email address"];
    }
    
}

-(void)alert:(NSString *) msg
{
    UIAlertController *myAlert = [UIAlertController
                                  alertControllerWithTitle:@"Invalid email!"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [myAlert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [myAlert addAction:ok];
    [super presentViewController:myAlert animated:YES completion:nil];
    
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSLog(@"email %@", candidate);
    return [emailTest evaluateWithObject:candidate];
}

-(void)setPage:(NSInteger) page{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    CIImage *inputImage = [CIImage imageWithCGImage:[[DesignFactory getBgImage:page] CGImage]];
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
    self.view.backgroundColor = [DesignFactory getBgColor:page];
    [self.view addSubview:newPageView];

    _label_0.textColor = [DesignFactory getLabelColor:page];
    _label_1.textColor = [DesignFactory getLabelColor:page];
    _emailTF.textColor = [DesignFactory getLabelColor:page];
    
}
@end
