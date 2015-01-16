//
//  GFHomeViewController.h
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFHomeViewController;

@protocol GFHomeDelegate <NSObject>

-(void) userLoggedOut: (GFHomeViewController *) controller;

@end

@interface GFHomeViewController : UIViewController

@property (nonatomic, weak) id<GFHomeDelegate> delegate;

@end
