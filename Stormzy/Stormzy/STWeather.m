//
//  STWeather.m
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "STWeather.h"

@implementation STWeather


- (instancetype)initWithCity:(NSString *)city
                 temperature:(NSNumber *)temperature
                     minTemp:(NSNumber *)minTemp
                     maxTemp:(NSNumber *)maxTemp
                  dateString:(NSString *)dateString
                     iconURL:(NSString *)url
                    humidity:(NSNumber *)humidity
                        wind:(NSNumber *)wind
                   feelsLike:(NSNumber *)feelsLike
             andPreciptation:(NSNumber *)precip {
    
    if (self = [super init]) {
        self.city = city;
        self.temperature = temperature;
        self.minTemp = minTemp;
        self.maxTemp = maxTemp;
        self.dateString = dateString;
        self.iconURL = url;
        self.humdity = humidity;
        self.wind = wind;
        self.feelsLike = feelsLike;
        self.precipitation = precip;
    }
    return self;
}

+ (NSArray<STWeather *> *)weatherDataFromJSON:(NSDictionary *)json {
    
    NSMutableArray<STWeather *> *weatherDataArray = [NSMutableArray new];
    
    if (json) {
        
        //Today's weather condition
        NSDictionary *locationDict = json[@"location"];
        NSString *city = locationDict[@"name"];
        
        NSDictionary *currentCondition = json[@"current"];
        NSNumber *currentTemp = currentCondition[@"temp_f"];
        
        NSArray *weeklyForecastArray = json[@"forecast"][@"forecastday"];
        NSDictionary *todaysForecast = weeklyForecastArray[0];
        
        NSNumber *minTemp = todaysForecast[@"day"][@"mintemp_f"];
        NSNumber *maxTemp = todaysForecast[@"day"][@"maxtemp_f"];
        
        NSString *dateString = todaysForecast[@"date"];
        NSString *dayString = [STWeather dayFromDateString:dateString];
        
        NSString *iconUrl = todaysForecast[@"day"][@"condition"][@"icon"];
        NSString *formattedUrl = [NSString stringWithFormat:@"https:%@",iconUrl];
        
        NSNumber *humdity = todaysForecast[@"hour"][0][@"humidity"];
        NSNumber *wind = todaysForecast[@"hour"][0][@"wind_mph"];
        
        NSNumber *feelsLike = todaysForecast[@"hour"][0][@"feelslike_f"];
        NSNumber *precipitation = todaysForecast[@"hour"][0][@"precip_in"];
        
        STWeather *today = [[STWeather alloc] initWithCity:city temperature:currentTemp minTemp:minTemp maxTemp:maxTemp dateString:dayString iconURL:formattedUrl humidity:humdity wind:wind feelsLike:feelsLike andPreciptation:precipitation];
        
        [weatherDataArray addObject:today];
        
        //i starts at one because today's current info has already been added to the array
        for (int i=1; i < weeklyForecastArray.count; i++) {
            
            NSDictionary *dayInfo = weeklyForecastArray[i];
            
            NSNumber *averageTemp = dayInfo[@"day"][@"avgtemp_f"];
            NSNumber *minTemp = dayInfo[@"day"][@"mintemp_f"];
            NSNumber *maxTemp = dayInfo[@"day"][@"maxtemp_f"];
            
            NSString *dateString = dayInfo[@"date"];
            NSString *dayString = [STWeather dayFromDateString:dateString];
            
            NSString *iconUrl = dayInfo[@"day"][@"condition"][@"icon"];
            NSString *formattedUrl = [NSString stringWithFormat:@"https:%@",iconUrl];
            
            NSNumber *humdity = todaysForecast[@"hour"][0][@"humidity"];
            NSNumber *wind = todaysForecast[@"hour"][0][@"wind_mph"];
            
            NSNumber *feelsLike = todaysForecast[@"hour"][0][@"feelslike_f"];
            NSNumber *precipitation = todaysForecast[@"hour"][0][@"precip_in"];
            
            STWeather *currentDay = [[STWeather alloc] initWithCity:city temperature:averageTemp minTemp:minTemp maxTemp:maxTemp dateString:dayString iconURL:formattedUrl humidity:humdity wind:wind feelsLike:feelsLike andPreciptation:precipitation];
            
            [weatherDataArray addObject:currentDay];
        }
    }
    
    return weatherDataArray;
}

+ (NSString *)dayFromDateString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    NSDate *date = [formatter dateFromString:dateString];
    
    NSString *day = [formatter stringFromDate:date];
    
    return day;
}

@end
