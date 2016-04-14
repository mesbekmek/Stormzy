//
//  STWeather.h
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface STWeather : NSObject

@property (nonatomic) NSString *city;
@property (nonatomic) NSString *temperature;
@property (nonatomic) NSString *minTemp;
@property (nonatomic) NSString *maxTemp;
@property (nonatomic) NSString *dateString;
@property (nonatomic) NSString *iconURL;
@property (nonatomic) NSString *humdity;
@property (nonatomic) NSString *wind;
@property (nonatomic) NSString *feelsLike;
@property (nonatomic) NSString *precipitation;
@property (nonatomic) NSString *condition;

+ (NSArray<STWeather *> *)weatherDataFromJSON:(NSDictionary *)json;
- (void)getIconForWeatherData:(void(^)(UIImage *image))completion;

@end
