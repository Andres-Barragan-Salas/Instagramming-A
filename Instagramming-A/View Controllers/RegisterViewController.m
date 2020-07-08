//
//  RegisterViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)dismissOnTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tappedSignup:(id)sender {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.email = self.emailField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        if(!([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] || [self.emailField.text isEqual:@""])) {
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error != nil) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up failed"
                           message:@"Please review your the fields"
                    preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                      style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction * _Nonnull action) {}];
                    
                    [alert addAction:cancelAction];
                    
                    [self presentViewController:alert animated:YES completion:^{}];
                } else {
                    NSLog(@"User registered successfully");
                    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
