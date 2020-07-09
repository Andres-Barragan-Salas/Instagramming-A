//
//  LoginViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//


#import <MBProgressHUD/MBProgressHUD.h>
#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)dismissOnTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tappedLogin:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if(!([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""])) {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log in failed"
                       message:@"Please review your credentials"
                preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                  style:UIAlertActionStyleCancel
                handler:^(UIAlertAction * _Nonnull action) {}];
                
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:^{}];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"User logged in successfully");
                
                // display view controller that needs to shown after successful login
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty fields"
               message:@"Please complete all the required fields"
        preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
          style:UIAlertActionStyleCancel
        handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (IBAction)tappedSignup:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
