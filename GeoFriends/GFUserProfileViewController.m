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

-(void) viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) setupHandlers {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [[self view] addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewName] addGestureRecognizer:userTap];
    userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewUrl] addGestureRecognizer:userTap];
    userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewLocation] addGestureRecognizer:userTap];
    userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewBio] addGestureRecognizer:userTap];

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

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint hiddenField = [[self activeField] frame].origin;
    CGFloat hiddenFieldHeight = [[self activeField] frame].size.height;
    
    CGRect visibleRect = [[self view] frame];
    visibleRect.size.height -= keyboardSize.height;

    if (!CGRectContainsPoint(visibleRect, hiddenField)) {
        CGPoint scrollPoint = CGPointMake(0.0, hiddenField.y - visibleRect.size.height + hiddenFieldHeight);
        [[self scrollView] setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [[self scrollView] setContentOffset:CGPointZero animated:YES];
}

-(void)hideKeyboard {
    [[self view] endEditing:YES];
}

-(void)showUserKeyboard: (UITapGestureRecognizer *) recognizer {
    UIView * sender = [recognizer view];
    if (sender == [self viewName]) {
        [[self nameText] becomeFirstResponder];
    } else if (sender == [self viewUrl]) {
        [[self urlText] becomeFirstResponder];
    } else if (sender == [self viewLocation]) {
        [[self locationText] becomeFirstResponder];
    } else if (sender == [self viewBio]) {
        [[self bioText] becomeFirstResponder];
    }
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
        [self hideKeyboard];
        [[self urlText] becomeFirstResponder];
    } else if (textField == [self urlText]) {
        [self hideKeyboard];
        [[self locationText] becomeFirstResponder];
    } else if (textField == [self locationText]) {
        [self hideKeyboard];
        [[self bioText] becomeFirstResponder];
    } else {
        [self hideKeyboard];
    }
    
    return YES;
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@"Bio Information"] == YES) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [self setActiveField: (UIControl *)textView];
    [textView becomeFirstResponder];
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@""] == YES) {
        [textView setText:@"Bio Information"];
        [textView setTextColor:[UIColor lightGrayColor]];
    }
    
    [self hideKeyboard];
    [self setActiveField:nil];

    [textView resignFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    [self setActiveField:textField];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [self hideKeyboard];
    [self setActiveField:nil];
}

@end
