//
//  AppDelegate.m
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "AppDelegate.h"

#import "GFLoginViewController.h"
#import "GFHomeViewController.h"
#import "GFUserProfileViewController.h"
#import "GFLogoutViewController.h"

#import "DNISActionSheetBlocks.h"

#import <Parse/Parse.h>

@interface AppDelegate ()
<GFLoginDelegate, GFUserProfileDelegate, UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:@"appId" clientKey:@"clientKey"];
    // ****************************************************************************
    
    [self setNavigationController: [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]]];
    
    [self setTabController: [[UITabBarController alloc] init]];
    [[self tabController] setDelegate:self];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setRootViewController:[self navigationController]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];

    // what screen do we switch to??
    [self presentUserView];

    // Override point for customization after application launch.
    return YES;
}

-(void) presentUserView {
    if ([PFUser currentUser]) {
        
        PFUser *user = [PFUser currentUser];
        NSString *name = user[@"name"];
        NSString *location = user[@"location" ];
        NSString *bio = user[@"bio"];
        
        if (name.length != 0 && location.length != 0 && bio.length != 0) {
            [self displayGFHomeView];
        } else {
            [self displayGFUserProfileView];
        }
    } else {
        [self displayGFLoginView];
    }
}

-(void) displayGFHomeView {
    GFHomeViewController *homeViewController = [[GFHomeViewController alloc] initWithNibName:nil bundle:nil];
    
    [[homeViewController tabBarItem] setTitle:@"Friends"];
    [[homeViewController tabBarItem] setImage:[UIImage imageNamed:@"friends"]];

    GFUserProfileViewController *profileViewController = [[GFUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    
    [[profileViewController tabBarItem] setTitle:@"Profile"];
    [[profileViewController tabBarItem] setImage:[UIImage imageNamed:@"id_profile"]];
    
    GFLogoutViewController *logoutView = [[GFLogoutViewController alloc] initWithCoder:nil];
    
    [[logoutView tabBarItem] setTitle:@"Logout"];
    [[logoutView tabBarItem] setImage:[UIImage imageNamed:@"logout"]];
    
    [[self tabController] setViewControllers:[NSArray arrayWithObjects:homeViewController, profileViewController, logoutView, nil] animated:YES];
    [[[self tabController] tabBar] setBarTintColor:[UIColor blackColor]];
    
    [[self window] setRootViewController:[self tabController]];
}

-(void) displayGFLoginView {
    GFLoginViewController *loginViewController = [[GFLoginViewController alloc] initWithNibName:nil bundle:nil];
    loginViewController.delegate = self;
    
    [[self window] setRootViewController:[self navigationController]];
    [[self navigationController] setViewControllers:@[loginViewController] animated:NO];
}

- (void) userLoginComplete:(GFLoginViewController *)controller {
    [self presentUserView];
}

-(void) displayGFUserProfileView {
    GFUserProfileViewController *userProfile = [[GFUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    userProfile.delegate = self;
    
    [[self navigationController] setViewControllers:@[userProfile] animated:YES];
}

-(void) userProfileComplete:(GFUserProfileViewController *)controller {
    [self displayGFHomeView];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[GFHomeViewController class]]) {
        GFHomeViewController *home = (GFHomeViewController *) [[self tabController] selectedViewController];
        [home refreshUserLocation];
    }
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    BOOL showView = NO;
    
    if ([[self tabController] selectedViewController] == viewController) {
        showView = YES;
    } else if ([viewController isKindOfClass:[GFLogoutViewController class]]) {
        DNISActionSheetBlocks *logoutSheet = [[DNISActionSheetBlocks alloc] initWithTitleAndButtons:@"Are you sure you want to logout?" cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
        
        [logoutSheet setBlockDestructiveDismissButton:^(UIActionSheet * sheet, NSInteger index) {
            NSLog(@"user logging out");
            
            [PFUser logOut];
            [self presentUserView];
        }];
        
        [logoutSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [logoutSheet showInView: [[[self tabController] selectedViewController] view]];
    } else {
        if ([[[self tabController] selectedViewController] isKindOfClass:[GFUserProfileViewController class]]) {
            GFUserProfileViewController *profile = (GFUserProfileViewController *)[[self tabController] selectedViewController];
            if (YES == [profile saveUserInformation]) {
                showView = YES;
            }
        } else {
            showView = YES;
        }
    }
    
    return showView;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
