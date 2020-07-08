//
//  CommentViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
@import Parse;

@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.commentField becomeFirstResponder];
    PFUser *user = [PFUser currentUser];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.file = user[@"image"];
    [self.profileImageView loadInBackground];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)commentAction:(id)sender {
    [Comment postCommentWithCaption:self.commentField.text onPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    if (error) {
        NSLog(@"Error uploading post: %@", error.localizedDescription);
    } else {
        NSLog(@"Upload Success!");
        [self closeAction:sender];
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
