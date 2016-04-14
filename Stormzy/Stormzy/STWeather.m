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
                 temperature:(NSString *)temperature
                     minTemp:(NSString *)minTemp
                     maxTemp:(NSString *)maxTemp
                  dateString:(NSString *)dateString
                     iconURL:(NSString *)url
                    humidity:(NSString *)humidity
                        wind:(NSString *)wind
                   feelsLike:(NSString *)feelsLike
                   condition:(NSString *)condition
             andPreciptation:(NSString *)precip {
    
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
        self.condition = condition;
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
        NSString *currentTempStr = [STWeather stringFromNumber:currentTemp];
        
        NSArray *weeklyForecastArray = json[@"forecast"][@"forecastday"];
        NSDictionary *todaysForecast = weeklyForecastArray[0];
        
        NSNumber *minTemp = todaysForecast[@"day"][@"mintemp_f"];
        NSString *minTempString = [STWeather stringFromNumber:minTemp];
        
        NSNumber *maxTemp = todaysForecast[@"day"][@"maxtemp_f"];
        NSString *maxTempString = [STWeather stringFromNumber:maxTemp];
        
        NSString *dateString = todaysForecast[@"date"];
        NSString *dayString = [STWeather dayFromDateString:dateString];
        
        NSString *iconUrl = todaysForecast[@"day"][@"condition"][@"icon"];
        NSString *formattedUrl = [NSString stringWithFormat:@"https:%@",iconUrl];
        
        NSNumber *humdity = todaysForecast[@"hour"][0][@"humidity"];
        NSString *humdityString = [STWeather stringFromNumber:humdity];
        
        NSNumber *wind = todaysForecast[@"hour"][0][@"wind_mph"];
        NSString *windString = [STWeather stringFromNumber:wind];
        
        NSNumber *feelsLike = todaysForecast[@"hour"][0][@"feelslike_f"];
        NSString *feelsLikeString = [STWeather stringFromNumber:feelsLike];
        
        NSString *condition = todaysForecast[@"day"][@"condition"][@"text"];
        
        NSNumber *precipitation = todaysForecast[@"hour"][0][@"precip_in"];
        NSString *precipString = [STWeather stringFromNumber:precipitation];
        
        STWeather *today = [[STWeather alloc] initWithCity:city temperature:currentTempStr minTemp:minTempString maxTemp:maxTempString dateString:dayString iconURL:formattedUrl humidity:humdityString wind:windString feelsLike:feelsLikeString condition:condition andPreciptation:precipString];
        
        [weatherDataArray addObject:today];
        
        //i starts at one because today's current info has already been added to the array
        for (int i=1; i < weeklyForecastArray.count; i++) {
            
            NSDictionary *dayInfo = weeklyForecastArray[i];
            
            NSNumber *averageTemp = dayInfo[@"day"][@"avgtemp_f"];
            NSString *averageTempStr = [STWeather stringFromNumber:averageTemp];
            
            NSNumber *minTemp = dayInfo[@"day"][@"mintemp_f"];
            NSString *minTempStr = [STWeather stringFromNumber:minTemp];
            
            NSNumber *maxTemp = dayInfo[@"day"][@"maxtemp_f"];
            NSString *maxTempStr = [STWeather stringFromNumber:maxTemp];
            
            NSString *dateString = dayInfo[@"date"];
            NSString *dayString = [STWeather dayFromDateString:dateString];
            
            NSString *iconUrl = dayInfo[@"day"][@"condition"][@"icon"];
            NSString *formattedUrl = [NSString stringWithFormat:@"https:%@",iconUrl];
            
            NSNumber *humdity = dayInfo[@"hour"][0][@"humidity"];
            NSString *humdityStr = [STWeather stringFromNumber:humdity];
            
            NSNumber *wind = dayInfo[@"hour"][0][@"wind_mph"];
            NSString *windStr = [STWeather stringFromNumber:wind];
            
            NSNumber *feelsLike = dayInfo[@"hour"][0][@"feelslike_f"];
            NSString *feelsLikeStr =[STWeather stringFromNumber:feelsLike];
            
            NSString *condition = dayInfo[@"day"][@"condition"][@"text"];
            
            NSNumber *precipitation = dayInfo[@"hour"][0][@"precip_in"];
            NSString *precipStr = [STWeather stringFromNumber:precipitation];
            
            STWeather *currentDay = [[STWeather alloc] initWithCity:city temperature:averageTempStr minTemp:minTempStr maxTemp:maxTempStr dateString:dayString iconURL:formattedUrl humidity:humdityStr wind:windStr feelsLike:feelsLikeStr condition:condition andPreciptation:precipStr];
            
            [weatherDataArray addObject:currentDay];
        }
    }
    
    return weatherDataArray;
}

+ (NSString *)dayFromDateString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    NSString *day = [formatter stringFromDate:date];
    
    return day;
}

+ (NSString *)stringFromNumber:(NSNumber *)number {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    
    NSString *numString = [formatter stringFromNumber:number];
    
    return numString;
}

- (void)getIconForWeatherData:(void(^)(UIImage *image))completion{
    
    if (!self.iconURL) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      
        NSURL *url = [NSURL URLWithString:self.iconURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        UIImage *img = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(img);
        });
        
    });
}

@end
