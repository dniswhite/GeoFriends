//
//  GFUserProfileViewController.m
//  GeoFriends
//
//  Created by Dennis White on 1/26/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "GFUserProfileViewController.h"

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
    
    [self setupHandlers];
    
}

-(void) setupHandlers {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [[self view] addGestureRecognizer:recognizer];
    
    [[self.bioText layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.bioText layer] setBorderWidth:.4];
    [[self.bioText layer] setCornerRadius:8.0f];
    
    [[self bioText] setText:@"Bio Information"];
    [[self bioText] setTextColor:[UIColor lightGrayColor]];
    
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
    [[self delegate] userProfileComplete:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
