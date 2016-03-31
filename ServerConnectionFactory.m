//
//  ServerConnectionFactory.m
//  ZaiBike-iOS
//
//  Created by May Ying on 30/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "ServerConnectionFactory.h"

@implementation ServerConnectionFactory

+ (NSDictionary *) dispatcher:(NSString *)msg parameter: (NSString*) param semaphore:(dispatch_semaphore_t) sema{
    NSDictionary* r;
    if ([msg isEqualToString:@"emailLogin"]){
        r = [self httpPOST :param domain: @"signup" completion:^(NSDictionary *request){
            dispatch_semaphore_signal(sema);
        }];
        
    }
    NSLog(@"Dict your mom= %@", r);
   
    return r;
}



+ (NSDictionary *) httpPOST : (NSString *) params domain: (NSString*) domainName completion:(void (^)(NSDictionary *)) completion
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat: @"https://zaibike-gserver.appspot.com/%@/mobile", domainName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"param %@", params);

    __block NSDictionary *dict = nil;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           // NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSError *e;
                                                               // NSLog(@"Data = %@",text);
                                                               dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                                                               NSLog(@"Dict= %@", dict);
                                                               completion(dict);
                                                           }}];
    [dataTask resume];
    return dict;
}


@end
