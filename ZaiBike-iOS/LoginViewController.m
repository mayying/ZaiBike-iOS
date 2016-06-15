//
//  MainViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "URLHandler.h"
#import "Utilities.h"

@implementation LoginViewController

-(BOOL)shouldAutorotate{
    return NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (IBAction)confirm:(id)sender
{
    // Authenticate user with server
    NSString *param = [NSString stringWithFormat:@"action=sign_in&username=%@", _numberTF.text];
    NSLog(@"param: %@", param);
    URLHandler *urlObject = [[URLHandler alloc] init];
    [urlObject httpPOST :param completion:^(NSDictionary *request){
        NSLog(@"%@", request[@"user_id"]);
        long long unsigned int userID = [request[@"user_id"] longLongValue];
        NSString *status = request[@"status"];
        NSLog(@"status %@, user_id %llu", status, userID);
        
        if ([status isEqualToString:@"ok"]){
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%llu", userID] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Instantiate View Controller from Storyboard
            UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *view = [mySB instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self presentViewController:view animated:YES completion:NULL];
        }else{
            [Utilities alert:@"Please contact ZaiBike team through Whatsapp group! Alternatively, do sign up first to enjoy ZaiBike service through zaibike.com" title:@"Sign in Error!" view:self];
            
        }
        
    }];

}
@end
