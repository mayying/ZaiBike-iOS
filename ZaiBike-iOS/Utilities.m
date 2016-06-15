//
//  Utitlies.m
//  ZaiBike-iOS
//
//  Created by May Ying on 28/5/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "Utilities.h"

static NSArray *bgImages;
static NSArray *bgColors;
static NSArray *labelColors;

@implementation Utilities
+ (NSDictionary *) httpPOST : (NSString *) params domain: (NSString*) domainName completion:(void (^)(NSDictionary *)) completion
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://zaibike-gserver.appspot.com/%@/mobile", domainName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSLog(@"Utilities %@", params);
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block NSDictionary *dict = nil;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSError *e;
                                                               
                                                               NSLog(@"Data from Utilities = %@",text);
                                                               dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                                                               completion(dict);
                                                           }}];
    [dataTask resume];
    return dict;
}

+ (UIImage*) getBgImage:(NSInteger)page{
    
    bgImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"login_pc1.png"],
                [UIImage imageNamed:@"login_pc2.png"],
                [UIImage imageNamed:@"login_pc3.png"],
                nil];
    
    return [bgImages objectAtIndex:page];
}

+ (UIColor*) getBgColor: (NSInteger) page{
    bgColors = [[NSArray alloc]initWithObjects:
                [UIColor colorWithRed:255/255.0f green:248/255.0f blue:227/255.0f alpha:1],
                [UIColor colorWithRed:75/255.0f green:190/255.0f blue:208/255.0f alpha:1],
                [UIColor colorWithRed:222/255.0f green:189/255.0f blue:149/255.0f alpha:1], nil];
    
    
    return [bgColors objectAtIndex:page];
}

+ (UIColor*) getLabelColor:(NSInteger)page{
    
    labelColors = [[NSArray alloc] initWithObjects:
                   [UIColor blackColor],
                   [UIColor whiteColor],
                   [UIColor blackColor],nil];
    
    
    
    return [labelColors objectAtIndex:page];
}

+ (int) getBgImageCount{
    
    bgImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"login_pc1.png"],
                [UIImage imageNamed:@"login_pc2.png"],
                [UIImage imageNamed:@"login_pc3.png"],
                nil];
    return (int)[bgImages count];
}

+ (void)alert:(NSString *) msg title:(NSString *) t view:(UIViewController *) v
{
    UIAlertController *myAlert = [UIAlertController
                                  alertControllerWithTitle:t
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
    [v presentViewController:myAlert animated:YES completion:nil];
    
}

@end
