//
//  STCollectionViewCell.h
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiLoLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *degreeSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeSymbol2;

- (void)setTextColor;

@end
