//
//  STWeather.h
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STWeather : NSObject

@property (nonatomic) NSString *city;
@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *minTemp;
@property (nonatomic) NSNumber *maxTemp;
@property (nonatomic) NSString *dateString;
@property (nonatomic) NSString *iconURL;
@property (nonatomic) NSNumber *humdity;
@property (nonatomic) NSNumber *wind;
@property (nonatomic) NSNumber *feelsLike;
@property (nonatomic) NSNumber *precipitation;

+ (NSArray<STWeather *> *)weatherDataFromJSON:(NSDictionary *)json;

@end
