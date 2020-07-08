//
//  UserViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
@import Parse;

@interface UserViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *postsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PFUser *user;

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated {
    self.user = [PFUser currentUser];
    [self setUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
}

- (void)setUserInfo {
    self.usernameLabel.text = self.user.username;
    self.descriptionLabel.text = self.user[@"description"];
    [self countPosts];
    self.followersCountLabel.text = @"0";
    self.followingCountLabel.text = @"0";
    self.userImageView.file = self.user[@"image"];
    [self.userImageView loadInBackground];
}

- (void) countPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
      if (!error) {
          self.postsCountLabel.text = [NSString stringWithFormat:@"%d", count];
      } else {
          self.postsCountLabel.text = @"0";
      }
    }];
}

- (IBAction)tappedLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // Log out completion block
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
