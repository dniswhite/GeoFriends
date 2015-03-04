//
//  GFNewUserViewController.m
//  GeoFriends
//
//  Created by Dennis White on 1/11/15.
//  Copyright (c) 2015 dniswhite. All rights reserved.
//

#import "GFNewUserViewController.h"

#import <Parse/Parse.h>

@interface GFNewUserViewController ()
<UITextFieldDelegate>
@end

@implementation GFNewUserViewController

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
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewUsername] addGestureRecognizer:userTap];
    userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewEmailAddress] addGestureRecognizer:userTap];
    userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewPassword] addGestureRecognizer:userTap];
    userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserKeyboard:)];
    [[self viewPasswordConfirm] addGestureRecognizer:userTap];

    self.textUsername.delegate = self;
    self.textEmailAddress.delegate = self;
    self.textPassword.delegate = self;
    self.textPasswordConfirm.delegate = self;
}

-(void)hideKeyboard {
    [[self view] endEditing:YES];
}

-(void)showUserKeyboard: (UITapGestureRecognizer *) recognizer {
    UIView * sender = [recognizer view];
    if (sender == [self viewUsername]) {
        [[self textUsername] becomeFirstResponder];
    } else if (sender == [self viewEmailAddress]) {
        [[self textEmailAddress] becomeFirstResponder];
    } else if (sender == [self viewPassword]) {
        [[self textPassword] becomeFirstResponder];
    } else if (sender == [self viewPasswordConfirm]) {
        [[self textPasswordConfirm] becomeFirstResponder];
    }
}

-(void)dismissNewUser {
    [self hideKeyboard];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textUsername) {
        [self.textEmailAddress becomeFirstResponder];
    } else if (textField == self.textEmailAddress) {
        [self.textPassword becomeFirstResponder];
    } else if (textField == self.textPassword) {
        [self.textPasswordConfirm becomeFirstResponder];
    } else if (textField == self.textPasswordConfirm) {
        [self hideKeyboard];
        [self handleNewUser];
    }
    
    return YES;
}

- (void) handleNewUser {
    // check that all the fields are entered
    if ([self validateFields] == YES) {
        // need to validate the email address looks good
        if ([self isValidEmail:self.textEmailAddress.text] == NO) {
            [self.textEmailAddress becomeFirstResponder];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter a valid eMail." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            
            return;
        }

        PFUser *user = [PFUser user];
        user.username = self.textUsername.text;
        user.password = self.textPassword.text;
        user.email = self.textEmailAddress.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self hideKeyboard];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                
                [[self delegate] createNewUserComplete: self];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        }];
    }
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL) validateFields {
    NSString *username = self.textUsername.text;
    NSString *email = self.textEmailAddress.text;
    NSString *password = self.textPassword.text;
    NSString *passwordConfirm = self.textPasswordConfirm.text;
    
    NSString *errorMessage = @"";

    BOOL result = YES;

    if (username.length == 0 || email.length == 0 || password.length == 0 || passwordConfirm.length == 0) {
        if (passwordConfirm.length == 0) {
            [self.textPasswordConfirm becomeFirstResponder];
            
            errorMessage = [@"" stringByAppendingString:@"a Password"];
        }
        if (password.length == 0) {
            [self.textPassword becomeFirstResponder];
            
            errorMessage = [@"" stringByAppendingString:@"a Password"];
        }
        if (email.length == 0) {
            [self.textEmailAddress becomeFirstResponder];
            
            if (errorMessage.length == 0) {
                errorMessage = [errorMessage stringByAppendingString:@"your eMail address"];
            } else {
                errorMessage = [@"your eMail address and " stringByAppendingString:errorMessage];
            }
        }
        if (username.length == 0) {
            [self.textUsername becomeFirstResponder];
            
            if (errorMessage.length == 0) {
                errorMessage = [errorMessage stringByAppendingString:@"enter a username"];
            } else {
                errorMessage = [@"a username and " stringByAppendingString:errorMessage];
            }
        }
    } else if ([password compare:passwordConfirm] != NSOrderedSame) {
        [self.textPasswordConfirm becomeFirstResponder];
        
        errorMessage = [errorMessage stringByAppendingString:@"matching password information"];
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

- (IBAction)createNewUser:(id)sender {
    [self handleNewUser];
}

- (IBAction)cancelNewUser:(id)sender {
    [self dismissNewUser];
}
@end
