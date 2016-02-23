//
//  URLHandler.m
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import "URLHandler.h"

@implementation URLHandler{
    
}

- (NSDictionary *) httpPOST : (NSString *) params completion:(void (^)(NSDictionary *)) completion
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"https://zaibike-gserver.appspot.com/generalapi/mobile"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block NSDictionary *dict = nil;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSError *e;
                                                               
                                                               NSLog(@"Data = %@",text);
                                                               dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                                                               completion(dict);
                                                           }}];
    [dataTask resume];
    return dict;
}

@end
