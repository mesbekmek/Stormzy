//
//  STCollectionViewCell.m
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "STCollectionViewCell.h"

@implementation STCollectionViewCell

- (void)awakeFromNib {
    
}

#pragma mark - STCollectionViewCell style setup


- (void)setTextColor {
    
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.hiLoLabel.textColor = [UIColor whiteColor];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    self.degreeSymbolLabel.textColor = [UIColor whiteColor];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    self.dayLabel.textColor = [UIColor whiteColor];
}


@end
