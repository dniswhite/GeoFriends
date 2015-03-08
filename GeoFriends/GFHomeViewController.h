//
//  GFHomeViewController.h
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

static NSString *baseURLString = @"http://devapi.mygasfeed.com/";

@interface GFHomeViewController : UIViewController

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapFriends;

- (void) refreshUserLocation;

@end
