//
//  SettingsViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
@import Parse;

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (strong, nonatomic) PFUser *user;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    self.usernameField.text = self.user.username;
    self.descriptionField.text = self.user[@"description"];
    self.profileImageView.file = self.user[@"image"];
    [self.profileImageView loadInBackground];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnPhoto:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self updateUserInfo];
}

- (void)updateUserInfo {
    self.user.username = self.usernameField.text;
    self.user[@"description"] = self.descriptionField.text;
    
    if (self.profileImageView.image != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.profileImageView.image);
        self.user[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    }
    
    [self.user saveInBackground];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profileImageView.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)dismissOnTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tappedUploadFromGallery:(id)sender {
    [self.view endEditing:YES];
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)tappedTakeAPhoto:(id)sender {
    [self.view endEditing:YES];
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)tappedOnPhoto:(UIGestureRecognizer *)sender{
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select An Option" message:nil preferredStyle:(UIAlertControllerStyleAlert)];

    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Upload From Gallery"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             [self tappedUploadFromGallery:sender];
                                                     }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take A Photo"
      style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * _Nonnull action) {
            [self tappedTakeAPhoto:sender];
    }];
    [alert addAction:galleryAction];
    [alert addAction:takePhotoAction];

    [self presentViewController:alert animated:YES completion:^{}];
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
