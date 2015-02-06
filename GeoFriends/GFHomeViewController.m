//
//  GFHomeViewController.m
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "GFHomeViewController.h"
#import "GFUserProfileViewController.h"

#import <Parse/Parse.h>

#define METERS_MILE 1609.344
#define METERS_FEET 3.28084

@interface GFHomeViewController ()
<CLLocationManagerDelegate, GFUserProfileDelegate>


@end

@implementation GFHomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Disable automatic adjustment, as we want to occupy all screen real estate
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO];
    [[self mapFriends] setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [[self locationManager] setDelegate:self];
    [[self locationManager] requestWhenInUseAuthorization];

    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
    [self setupHandlers];
}

-(void) setupHandlers {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [[self view] addGestureRecognizer:recognizer];
    
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(profile)]];
}

-(void) logout {
    [PFUser logOut];
    [[self delegate] userLoggedOut:self];
}

-(void) profile {
    GFUserProfileViewController *userProfile = [[GFUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    userProfile.delegate = self;

    [[self navigationController] presentViewController:userProfile animated:YES completion:nil];
}

-(void) userProfileComplete:(GFUserProfileViewController *)controller {
    
}

-(void)hideKeyboard {
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
    [[self mapFriends] setRegion:viewRegion animated:YES];}

@end
