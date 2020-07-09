//
//  UploadViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "UploadViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>
#import "Post.h"
@import Parse;

@interface UploadViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.delegate = self;
    self.textField.text = @"Caption...";
    self.textField.textColor = UIColor.lightGrayColor;
    // Do any additional setup after loading the view
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    PFUser *user = [PFUser currentUser];
    self.profileImageView.file = user[@"image"];
    [self.profileImageView loadInBackground];
    self.postImageView.image = nil;
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnPhoto:)];
    [self.postImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.postImageView setUserInteractionEnabled:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.postImageView.image = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textField.textColor == UIColor.lightGrayColor) {
        self.textField.text = @"";
        self.textField.textColor = UIColor.blackColor;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.textField.text isEqualToString:@""]) {
        self.textField.text = @"Caption...";
        self.textField.textColor = UIColor.lightGrayColor;
    }
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

- (IBAction)tappedCancel:(id)sender {
    self.postImageView.image = nil;
    self.textField.text = @"Caption...";
    self.textField.textColor = UIColor.lightGrayColor;
    [self.view endEditing:YES];
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)tappedShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.textField.textColor == UIColor.lightGrayColor) {
        self.textField.text = @"";
    }
    
    [Post postUserImage:self.postImageView.image withCaption:self.textField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error uploading post: %@", error.localizedDescription);
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Upload Success!");
                [self tappedCancel:sender];
            }
            }];
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
