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

@property bool mapZoomed;


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

    [[self mapFriends] setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [[self locationManager] setDelegate:self];
    [[self locationManager] requestWhenInUseAuthorization];

    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
    [self setupHandlers];
}

-(void) setupHandlers {
    [self setMapZoomed:NO];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [[self view] addGestureRecognizer:recognizer];
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
    
    if ([self mapZoomed] == NO) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
        [[self mapFriends] setRegion:viewRegion animated:YES];
        
        [self setMapZoomed:YES];
    }
}

- (void) refreshUserLocation {
    [self getLocalFriends:CLLocationCoordinate2DMake([[self mapFriends] centerCoordinate].latitude, [[self mapFriends] centerCoordinate].longitude)];
}

-(void) getLocalFriends: (CLLocationCoordinate2D) location {
    NSString *urlString = [baseURLString stringByAppendingString:[NSString stringWithFormat:@"/stations/radius/%1.6f/%1.6f//5/reg/Price/rfej9napna.json?", location.latitude, location.longitude]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = @"some data";
        NSDictionary *data = (NSDictionary *)responseObject;
        
        NSArray *stations = data[@"stations"];
        for (id object in stations) {
            NSString *debug2 = @"";
            
        }
        NSString *debug1 = @"";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Fuel Information"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

- (IBAction)getDataFromServer:(id)sender {
    [self getLocalFriends:CLLocationCoordinate2DMake([[self mapFriends] centerCoordinate].latitude, [[self mapFriends] centerCoordinate].longitude)];
}

- (IBAction)logoutUser:(id)sender {
    [PFUser logOut];
    [[self delegate] userLoggedOut:self];
}
@end
