//
//  ServerConnectionFactory.m
//  ZaiBike-iOS
//
//  Created by May Ying on 30/3/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "ServerConnectionFactory.h"

@implementation ServerConnectionFactory

+ (NSDictionary *) httpPOST : (NSString *) params domain: (NSString*) domainName completion:(void (^)(NSDictionary *)) completion
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://zaibike-gserver.appspot.com/%@/mobile", domainName]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block NSDictionary *dict = nil;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSError *e;
                                                               
                                                               NSLog(@"Data from Server Connection Factory = %@",text);
                                                               dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                                                               completion(dict);
                                                           }}];
    [dataTask resume];
    return dict;
}

@end
