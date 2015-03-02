//
//  GFUserProfileViewController.h
//  GeoFriends
//
//  Created by Dennis White on 1/26/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFUserProfileViewController;

@protocol GFUserProfileDelegate <NSObject>

-(void) userProfileComplete: (GFUserProfileViewController *) controller;

@end

@interface GFUserProfileViewController : UIViewController

@property (weak, nonatomic) id<GFUserProfileDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *bioText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextField *urlText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIControl *activeField;

- (IBAction)doneClicked:(id)sender;

@end
