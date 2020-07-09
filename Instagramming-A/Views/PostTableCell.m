//
//  PostTableCell.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "PostTableCell.h"
#import "NSDate+DateTools.h"
#import "Like.h"

@implementation PostTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    self.likeButton.selected = NO;
    self.likeButton.tintColor = UIColor.blackColor;
    
    UITapGestureRecognizer *userTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.userImageView addGestureRecognizer:userTapGestureRecognizer];
    [self.userImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)updateWithPost:(Post *)post {
    self.post = post;
    
    self.descriptionLabel.text = post.caption;
    self.dateLabel.text = post.createdAt.timeAgoSinceNow;
    self.likesCountLabel.text = [post.likeCount stringValue];
    self.comentsCountLabel.text = [NSString stringWithFormat:@"%@ Comments", post.commentCount];
    self.postImageView.image = nil;
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    
    PFUser *user = post.author;
    self.usernameLabel.text = user.username;
    self.authorLabel.text = user.username;
    self.userImageView.image = nil;
    self.userImageView.file = user[@"image"];
    [self.userImageView loadInBackground];
    
    [self updateLikeStatus];
}

- (void)updateLikeStatus {
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"post" equalTo:self.post];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          if (objects.count != 0) {
              self.likeButton.selected = YES;
              self.likeButton.tintColor = UIColor.redColor;
          }
          else {
              self.likeButton.selected = NO;
              self.likeButton.tintColor = UIColor.blackColor;
          }
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

- (IBAction)tappedLikeButton:(id)sender {
    self.likeButton.enabled = NO;
    if (!self.likeButton.selected) {
        self.likeButton.selected = YES;
        self.likeButton.tintColor = UIColor.redColor;
        [Like likePost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                self.likeButton.enabled = YES;
                self.likesCountLabel.text = [self.post.likeCount stringValue];
            }
        }];
    }
    else {
        self.likeButton.selected = NO;
        self.likeButton.tintColor = UIColor.blackColor;
        [Like unlikePost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                self.likeButton.enabled = YES;
                self.likesCountLabel.text = [self.post.likeCount stringValue];
            }
        }];
    }
}

- (void) didTapUserProfile:(UIGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.userImageView.alpha = 0.5;
        self.userImageView.alpha = 1;
    }];
    [self.delegate postCell:self didTap:self.post.author];
}

@end
