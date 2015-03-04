//
//  GFNewUserViewController.h
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFNewUserViewController;

@protocol GFNewUserDelegate <NSObject>

-(void)createNewUserComplete: (GFNewUserViewController *) controller;

@end
@interface GFNewUserViewController : UIViewController

@property (nonatomic, weak) id<GFNewUserDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textPasswordConfirm;

@property (weak, nonatomic) IBOutlet UIView *viewUsername;
@property (weak, nonatomic) IBOutlet UIView *viewEmailAddress;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewPasswordConfirm;
@end
