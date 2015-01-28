//
//  GFUserProfileViewController.m
//  GeoFriends
//
//  Created by Dennis White on 1/26/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "GFUserProfileViewController.h"

@interface GFUserProfileViewController ()
<UITextViewDelegate>

@end

@implementation GFUserProfileViewController

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
    
    // Do any additional setup after loading the view from its nib.
    [[self.bioText layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.bioText layer] setBorderWidth:.4];
    [[self.bioText layer] setCornerRadius:8.0f];
    
    [[self bioText] setDelegate:self];
    [[self bioText] setText:@"Bio Information"];
    [[self bioText] setTextColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideKeyboard {
    [[self view] endEditing:YES];
}

- (IBAction)doneClicked:(id)sender {
    [self hideKeyboard];
    [[self delegate] userProfileComplete:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@"Bio Information"] == YES) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [textView becomeFirstResponder];
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@""] == YES) {
        [textView setText:@"Bio Information"];
        [textView setTextColor:[UIColor lightGrayColor]];
    }
    
    [textView resignFirstResponder];
}
@end
