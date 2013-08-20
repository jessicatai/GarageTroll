//
//  FirstViewController.h
//  GarageTroll
//
//  Created by Jessica Tai on 8/2/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate>
- (IBAction)updateCount:(id)sender;
- (IBAction)getLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UITextView *counterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImage;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;

//@property (strong, nonatomic) IBOutlet MKMapView *map;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentAccuracy;
//@property (strong, nonatomic) IBOutlet UISwitch *switchEnabled;
//
//- (IBAction)accuracyChanged:(id)sender;
//- (IBAction)enabledStateChanged:(id)sender;


@end
