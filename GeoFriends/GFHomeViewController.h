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

@class GFHomeViewController;

@protocol GFHomeDelegate <NSObject>

-(void) userLoggedOut: (GFHomeViewController *) controller;

@end

@interface GFHomeViewController : UIViewController

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapFriends;
@property (nonatomic, weak) id<GFHomeDelegate> delegate;
- (IBAction)getDataFromServer:(id)sender;
- (IBAction)logoutUser:(id)sender;

@end
