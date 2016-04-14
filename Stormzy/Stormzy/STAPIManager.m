//
//  STAPIManager.m
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "STAPIManager.h"
#import <AFNetworking/AFNetworking.h>


static NSString * const exampleEndpoint = @"https://api.apixu.com/v1/forecast.json?key=be4be9a1f0404320a9e161640161304&q=Amazon&days=10";

static NSString * const baseURL = @"https://api.apixu.com/v1/forecast.json?key=be4be9a1f0404320a9e161640161304&q=";

@implementation STAPIManager


+ (void)getJSONFromAPI:(void(^)(NSDictionary *dict))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:exampleEndpoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            NSLog(@"Error: %@",error.localizedDescription);
        }
    }];
}

+ (void)getJSONFromAPIForLocation:(CLLocation *)location
                            block:(void (^)(NSDictionary *dict))completion{
    
    float latitude  = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    NSString *query = [NSString stringWithFormat:@"%@%f,%f&days=10",baseURL,latitude,longitude];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:query parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
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
