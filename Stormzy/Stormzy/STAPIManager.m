//
//  STAPIManager.m
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "STAPIManager.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const weatherEndpoint = @"https://api.apixu.com/v1/forecast.json?key=be4be9a1f0404320a9e161640161304&q=Amazon&days=10";

static NSString * const forecastEndpoint = @"https://api.forecast.io/forecast/95ac0e76481513d58b808d31fba3a227/-40.7,70.38";


@implementation STAPIManager


+ (void)getJSONFromAPI:(void(^)(NSDictionary *dict))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:weatherEndpoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@",error.localizedDescription);
        }
    }];
}

@end
