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

#pragma mark - LifeCycle method

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.windLabel.text = [NSString stringWithFormat:@"%@ mph",self.weatherData.wind];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@ %%",self.weatherData.humdity];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%@ inches",self.weatherData.precipitation];
    self.feelingLabel.text = self.weatherData.feelsLike;
    self.conditionLabel.text = self.weatherData.condition;
    
    [self.weatherData getIconForWeatherData:^(UIImage *image) {
        
        self.imageView.image = image;
        [self blurImage];
        
    }];
}

#pragma mark - Navigation method

- (IBAction)doneButtonTapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Blur Effect 

- (void)blurImage {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    [self.imageView addSubview:effectView];
}


@end
