//
//  STViewController.m
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "STViewController.h"
#import "STAPIManager.h"
#import "STCollectionViewCell.h"
#import "STCollectionViewFlowLayout.h"
#import "STWeather.h"
#import "STDetailViewController.h"
@import CoreLocation;

@interface STViewController () <
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray<STWeather *> *weatherData;
@property (nonatomic, assign) CGFloat previousOffset;
@property (nonatomic, assign) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation STViewController {
    CLLocationManager *locationManager;
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupWeatherData];
    [self startStandardUpdates];
    [self setupCollectionView];
    self.backgroundImageView.image = [UIImage imageNamed:@"bg"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Weather Data setup

- (void)setupWeatherData {
    self.weatherData = [NSMutableArray new];
    
    [STAPIManager getJSONFromAPI:^(NSDictionary *dict) {
        self.weatherData = [NSMutableArray arrayWithArray:[STWeather weatherDataFromJSON:dict]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Location methods

- (void)startStandardUpdates
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) < 15.0) {
        
        [STAPIManager getJSONFromAPIForLocation:location block:^(NSDictionary *dict) {
            self.weatherData = [NSMutableArray arrayWithArray:[STWeather weatherDataFromJSON:dict]];
            [self.collectionView reloadData];
        }];
        
        [locationManager stopUpdatingLocation];
        [locationManager stopMonitoringSignificantLocationChanges];
        
        if(locationManager!=nil){
            locationManager.delegate= nil;
            locationManager= nil;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusNotDetermined ) {
        [locationManager requestWhenInUseAuthorization];
    }
}


#pragma mark - Collection setup

- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"STCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"WeatherCellIdentifier"];
    
    self.collectionView.clipsToBounds = NO;
    
    UICollectionViewFlowLayout *myLayout = [[STCollectionViewFlowLayout alloc] init];
    
    CGFloat margin = ((self.view.frame.size.width - self.collectionView.frame.size.width) / 2);
    
    // This assumes that the the collectionView is centered withing its parent view.
    myLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width + margin, self.collectionView.frame.size.height);
    
    // A negative margin will shift each item to the left.
    myLayout.minimumLineSpacing = -margin;
    
    myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView setCollectionViewLayout:myLayout];
}

#pragma mark - Collection View Data source and Delegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [self.weatherData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCellIdentifier" forIndexPath:indexPath];
    
    //Sets label attributes to white color
    [cell setTextColor];
    
    STWeather *weatherData = self.weatherData[indexPath.row];
    
    self.cityLabel.text = weatherData.city;
    cell.temperatureLabel.text = weatherData.temperature;
    cell.conditionsLabel.text = weatherData.condition;
    cell.hiLoLabel.text = [NSString stringWithFormat:@"%@/%@",weatherData.minTemp, weatherData.maxTemp];
    cell.dayLabel.text = weatherData.dateString;
    [weatherData getIconForWeatherData:^(UIImage *image) {
        cell.conditionImageView.image = image;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STWeather *weather = self.weatherData[indexPath.row];
    
    STDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"STDetailViewControllerID"];
    
    detailVC.weatherData = weather;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark - collection View Layout setup

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.view.frame.size.width * 0.8;
    CGFloat height = 1.77 * width;
    
    
    CGSize mElementSize = CGSizeMake(width, height);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    
    // Imitating paging behaviour
    // Check previous offset and scroll direction
    if ((self.previousOffset > self.collectionView.contentOffset.x) && (velocity.x < 0.0f)) {
        self.currentPage = MAX(self.currentPage - 1, 0);
    } else if ((self.previousOffset < self.collectionView.contentOffset.x) && (velocity.x > 0.0f)) {
        self.currentPage = MIN(self.currentPage + 1, itemsCount - 1);
    }
    
    // Update offset by using item size + spacing
    CGFloat updatedOffset = (flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing) * self.currentPage;
    self.previousOffset = updatedOffset;
    
    return CGPointMake(updatedOffset, proposedContentOffset.y);
}


@end
