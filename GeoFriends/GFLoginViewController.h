//
//  GFLoginViewController.h
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFLoginViewController;

@protocol GFLoginDelegate <NSObject>

- (void) userLoginComplete: (GFLoginViewController *) controller;

@end
@interface GFLoginViewController : UIViewController

@property (weak, nonatomic) id<GFLoginDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@end
