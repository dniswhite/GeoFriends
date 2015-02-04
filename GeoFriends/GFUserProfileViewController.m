//
//  GFUserProfileViewController.m
//  GeoFriends
//
//  Created by Dennis White on 1/26/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "GFUserProfileViewController.h"
#import <Parse/Parse.h>

@interface GFUserProfileViewController ()
<UITextViewDelegate, UITextFieldDelegate>

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
    
    PFUser *user = [PFUser currentUser];
    NSString *name = user[@"name"];
    
    if (name.length != 0) {
        NSString *location = user[@"location"];
        NSString *bio = user[@"bio"];
        NSString *url = user[@"url"];
        
        [[self nameText] setText:name];
        [[self locationText] setText:location];
        [[self bioText] setText:bio];
        [[self urlText] setText:url];
    }

    [self setupHandlers];
}

-(void) setupHandlers {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [[self view] addGestureRecognizer:recognizer];
    
    [[self.bioText layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.bioText layer] setBorderWidth:.4];
    [[self.bioText layer] setCornerRadius:8.0f];
    
    if ([[[self bioText] text] isEqualToString:@""] == YES) {
        [[self bioText] setText:@"Bio Information"];
        [[self bioText] setTextColor:[UIColor lightGrayColor]];
    }
    
    [[self nameText] setDelegate:self];
    [[self urlText] setDelegate:self];
    [[self locationText] setDelegate:self];
    [[self bioText] setDelegate:self];
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
    
    if ([self validateProfile]) {
        PFUser *user = [PFUser currentUser];
        user[@"name"] = self.nameText.text;
        user[@"location"] = self.locationText.text;
        user[@"bio"] = self.bioText.text;
        
        // either an empty string or text in the control (dont send it nil)
        user[@"url"] = ([[[self urlText] text] isEqualToString:@""]) ? @"" : self.urlText.text;
        
        [user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            if (!error) {
                [[self delegate] userProfileComplete:self];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        }];
        
    }
}

-(BOOL) validateProfile {
    BOOL result = YES;
    NSString *name = self.nameText.text;
    NSString *location = self.locationText.text;
    NSString *bio = @"";
    
    NSString *errorMessage = @"";

    if ([[[self bioText] text] isEqualToString:@"Bio Information"] == NO) {
        bio = self.bioText.text;
    }
    
    if (name.length == 0 || location.length == 0 || bio.length == 0) {
        result = NO;
        
        if (bio.length == 0) {
            [[self bioText] becomeFirstResponder];
            
            errorMessage = [@"" stringByAppendingString:@"bio information."];
        }
        
        if (location.length == 0) {
            [[self locationText] becomeFirstResponder];
            
            if (errorMessage.length == 0) {
                errorMessage = [@"" stringByAppendingString:@" location information."];
            } else {
                errorMessage = [@"location and " stringByAppendingString:errorMessage];
            }
        }
        
        if (name.length == 0) {
            [[self nameText] becomeFirstResponder];
            
            if (errorMessage.length == 0) {
                errorMessage = [@"" stringByAppendingString:@" name."];
            } else {
                errorMessage = [@"name and " stringByAppendingString:errorMessage];
            }
        }
        
        errorMessage = [@"Please enter your " stringByAppendingString:errorMessage];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    return result;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == [self nameText]) {
        [[self urlText] becomeFirstResponder];
    } else if (textField == [self urlText]) {
        [[self locationText] becomeFirstResponder];
    } else if (textField == [self locationText]) {
        [[self bioText] becomeFirstResponder];
    }
    
    return YES;
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@"Bio Information"] == YES) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [textView becomeFirstResponder];
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@""] == YES) {
        [textView setText:@"Bio Information"];
        [textView setTextColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [textView resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // need to figure out how to move the view
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    // reset view back to normal
}

@end
