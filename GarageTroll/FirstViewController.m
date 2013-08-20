//
//  FirstViewController.m
//  GarageTroll
//
//  Created by Jessica Tai on 8/2/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
CLLocationManager *locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    
    self.locations = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter = 1609.34f; // update every 1 mile
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateCount:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://boxtrip10x.appspot.com/stats?lot_id=5733953138851840"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    int blue = 30;
    int yellow = 10;
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        __block NSString *latestCountStr = nil;
        if (error == nil) {
            NSLog(@"%@", result);
            NSString *currentValue = [result valueForKey:@"current"];
            NSString *capacityValue = [result valueForKey:@"capacity"];
            [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSLog(@"\tKey: %@ Value: %@", key, obj);            }];
            NSLog(@"%@", currentValue);
            int currentInt = [currentValue doubleValue];
            int capacityInt = [capacityValue intValue];
            NSInteger latestCount = MAX(0,capacityInt - currentInt);
            NSString *greeting = [[NSString alloc] initWithFormat:@"%d", latestCount];
            if (latestCount > blue) {
                self.counterLabel.textColor = [UIColor colorWithRed:(62/255.0) green:(193/255.0) blue:(230/255.0) alpha:1];
                self.cloudImage.image = [UIImage imageNamed:@"blueCloud.png"];
                self.commentLabel.text = [NSString stringWithFormat:@"You're good to go!"];
            }
            else if (latestCount <= blue && latestCount > yellow){
                self.counterLabel.textColor = [UIColor colorWithRed:(245/255.0) green:(214/255.0) blue:(91/255.0) alpha:1];
                self.cloudImage.image = [UIImage imageNamed:@"yellowCloud.png"];
                self.commentLabel.text = [NSString stringWithFormat:@"Not many spots left..."];
            }
            else {
                self.counterLabel.textColor = [UIColor redColor];
                self.cloudImage.image = [UIImage imageNamed:@"redCloud.png"];
                self.commentLabel.text = [NSString stringWithFormat:@"Probably should look somewhere else."];
            }
            self.counterLabel.text = greeting;
            
            // update text with current time
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            DateFormatter.locale = [NSLocale currentLocale];
            [DateFormatter setDateFormat:@"hh:mm:ss a"];
            self.dateTimeLabel.text = [NSString stringWithFormat:@"As of %@",[DateFormatter stringFromDate:[NSDate date]]];
        }
    }
}

- (IBAction)getLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Stop Location Manager
    //[locationManager stopUpdatingLocation];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    
    // hard coded to Box HQ
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:37.4025381 longitude:-122.1163549];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    // distance in miles
    double miles = distance * 0.000621371;
    
    NSLog(@"Distance (mi):%f", miles);
    if (miles <= 1) {
        [self.countButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}



//- (IBAction)accuracyChanged:(id)sender
//{
//    const CLLocationAccuracy accuracyValues[] = {
//        kCLLocationAccuracyBestForNavigation,
//        kCLLocationAccuracyBest,
//        kCLLocationAccuracyNearestTenMeters,
//        kCLLocationAccuracyHundredMeters,
//        kCLLocationAccuracyKilometer,
//        kCLLocationAccuracyThreeKilometers};
//    
//    self.locationManager.desiredAccuracy = accuracyValues[self.segmentAccuracy.selectedSegmentIndex];
//}
//
//- (IBAction)enabledStateChanged:(id)sender
//{
//    if (self.switchEnabled.on)
//    {
//        [self.locationManager startUpdatingLocation];
//    }
//    else
//    {
//        [self.locationManager stopUpdatingLocation];
//    }
//}

#pragma mark - CLLocationManagerDelegate

/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 *
 *    This method is deprecated. If locationManager:didUpdateLocations: is
 *    implemented, this method will not be called.
 */
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    // Add another annotation to the map.
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    annotation.coordinate = newLocation.coordinate;
//    [self.map addAnnotation:annotation];
//    
//    // Also add to our map so we can remove old values later
//    [self.locations addObject:annotation];
//    
//    // Remove values if the array is too big
//    while (self.locations.count > 100)
//    {
//        annotation = [self.locations objectAtIndex:0];
//        [self.locations removeObjectAtIndex:0];
//        
//        // Also remove from the map
//        [self.map removeAnnotation:annotation];
//    }
//    
//    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
//    {
//        // determine the region the points span so we can update our map's zoom.
//        double maxLat = -91;
//        double minLat =  91;
//        double maxLon = -181;
//        double minLon =  181;
//        
//        for (MKPointAnnotation *annotation in self.locations)
//        {
//            CLLocationCoordinate2D coordinate = annotation.coordinate;
//            
//            if (coordinate.latitude > maxLat)
//                maxLat = coordinate.latitude;
//            if (coordinate.latitude < minLat)
//                minLat = coordinate.latitude;
//            
//            if (coordinate.longitude > maxLon)
//                maxLon = coordinate.longitude;
//            if (coordinate.longitude < minLon)
//                minLon = coordinate.longitude;
//        }
//        
//        MKCoordinateRegion region;
//        region.span.latitudeDelta  = (maxLat +  90) - (minLat +  90);
//        region.span.longitudeDelta = (maxLon + 180) - (minLon + 180);
//        
//        // the center point is the average of the max and mins
//        region.center.latitude  = minLat + region.span.latitudeDelta / 2;
//        region.center.longitude = minLon + region.span.longitudeDelta / 2;
//        
//        // Set the region of the map.
//        [self.map setRegion:region animated:YES];
//    }
//    else
//    {
//        NSLog(@"App is backgrounded. New location is %@", newLocation);
//    }
//}

@end
