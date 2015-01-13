//
//  GFLoginViewController.m
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "GFLoginViewController.h"
#import "GFNewUserViewController.h"

#import <Parse/Parse.h>

@interface GFLoginViewController ()
<UITextFieldDelegate, GFNewUserDelegate>
@end

@implementation GFLoginViewController

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
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    [self setupHandlers];
}

-(void) setupHandlers {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [[self view] addGestureRecognizer:recognizer];
    
    self.textUserName.delegate = self;
    self.textPassword.delegate = self;
}

-(void)hideKeyboard {
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textUserName) {
        [self.textPassword becomeFirstResponder];
    } else if (textField == self.textPassword) {
        [self.textPassword resignFirstResponder];
        [self hideKeyboard];
        [self handleUserLogin];
    }
    
    return YES;
}

- (IBAction)loginUser:(id)sender {
    [self handleUserLogin];
}

-(void) handleUserLogin {
    if ([self validateFields] == YES) {
        PFUser *user = [PFUser user];
        user.username = self.textUserName.text;
        user.password = self.textPassword.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.delegate userLogingComplete:self];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
             }
        }];
    }
}

- (BOOL) validateFields {
    NSString *username = self.textUserName.text;
    NSString *password = self.textPassword.text;
    
    NSString *errorMessage = @"";
    
    BOOL result = YES;
    
    if (username.length == 0 || password.length == 0) {
        if (password.length == 0) {
            [self.textPassword becomeFirstResponder];
            
            errorMessage = [errorMessage stringByAppendingString:@"a Password"];
        }
        if (username.length == 0) {
            [self.textUserName becomeFirstResponder];
            
            if (errorMessage.length == 0) {
                errorMessage = [errorMessage stringByAppendingString:@"enter a username"];
            } else {
                errorMessage = [@"a username and " stringByAppendingString:errorMessage];
            }
        }
    }
    
    if (errorMessage.length > 0) {
        result = NO;
        
        // make it polite
        errorMessage = [@"Please enter " stringByAppendingString:errorMessage];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    
    return result;
}

- (IBAction)createUser:(id)sender {
    GFNewUserViewController *newUserViewController = [[GFNewUserViewController alloc] initWithNibName:nil bundle:nil];
    newUserViewController.delegate = self;
    [[self navigationController] presentViewController:newUserViewController animated:YES completion:nil];
}

-(void) createNewUserComplete:(GFNewUserViewController *)controller {
    [self.delegate userLogingComplete:self];
}
@end