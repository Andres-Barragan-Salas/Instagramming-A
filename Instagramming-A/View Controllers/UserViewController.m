//
//  UserViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewController.h"
#import "PostCollectionCell.h"
#import "PostCollectionCell.h"
#import "PostViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "Post.h"
@import Parse;

@interface UserViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *postsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) PFUser *user;

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated {
    self.user = [PFUser currentUser];
    [self setUserInfo];
    [self fetchPosts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // Do any additional setup after loading the view.
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    
    //Layout adjustments
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat postsPerLine = 3;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerLine - 1)) / postsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)setUserInfo {
    self.usernameLabel.text = self.user.username;
    self.descriptionLabel.text = self.user[@"description"];
    self.postsCountLabel.text = [NSString stringWithFormat:@"%@", self.user[@"postCount"]];
    self.followersCountLabel.text = @"0";
    self.followingCountLabel.text = @"0";
    self.userImageView.file = self.user[@"image"];
    [self.userImageView loadInBackground];
}

- (void)fetchPosts {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:self.user];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;

    // Fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.posts = posts;
            [self.collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    
    [cell updateWithPost:post];
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[PostCollectionCell class]]) {
        PostCollectionCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        PostViewController *singlePostViewController = [segue destinationViewController];
        singlePostViewController.post = post;
    }
}


@end
