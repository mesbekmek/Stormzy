//
//  STDetailViewController.m
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/13/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "STDetailViewController.h"

@interface STDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation STDetailViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.humidityLabel.text = self.weatherData.humdity;
    self.precipitationLabel.text = self.weatherData.precipitation;
    self.feelingLabel.text = self.weatherData.feelsLike;
    self.conditionLabel.text = self.weatherData.condition;
}

@end
