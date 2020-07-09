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

/* Life cycle method of the cell called when the cell is about to appear on screen. */
- (void)awakeFromNib {
    [super awakeFromNib];
    // Make the user image view rounded
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    // Set initial values for the like button (unselected state)
    self.likeButton.selected = NO;
    self.likeButton.tintColor = UIColor.blackColor;
    // Add a gesture reconiser to the user photo of a post to be able to segue to that user's profile page, the gesture is linked to the function which will handle the segue
    UITapGestureRecognizer *userTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.userImageView addGestureRecognizer:userTapGestureRecognizer];
    [self.userImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // How the cell will change when it's selected, no animations since this behaiviour is not wanted
}

/* Utility funtion so the attributes of the cell can be initialized by using an object of type post.
   @param post: Post object (PFObject) with information to be displayed on the cell
*/
- (void)updateWithPost:(Post *)post {
    // Set the attributes of type Post and User in the cell
    self.post = post;
    PFUser *user = post.author;
    // Update the labels inside the cell with the post information
    self.usernameLabel.text = user.username;
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@  %@", user.username, post.caption];
    self.likesCountLabel.text = [post.likeCount stringValue];
    self.comentsCountLabel.text = [NSString stringWithFormat:@"%@ Comments", post.commentCount];
    // Set the time since creation of the post using its creation date and the "DateTools" library
    self.dateLabel.text = post.createdAt.timeAgoSinceNow;
    // Wipe the current user image of the cell (because of reusability) and display the author's one
    self.userImageView.image = nil;
    self.userImageView.file = user[@"image"];
    [self.userImageView loadInBackground];
    // Wipe the current post image of the cell (because of reusability) and display the post's one
    self.postImageView.image = nil;
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    // Modify the fonts and colors of the post's caption based on their type using the "ResponsiveLabel" library
    [self.descriptionLabel enableStringDetection:user.username withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    [self.descriptionLabel enableHashTagDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor systemBlueColor]}];
    // Change the state of the like button (selected or not) based on the post-user information (likes)
    [self updateLikeStatus];
}

/* Utlity funtion that checks in the Parse thatabase if the current post has been liked
   by the actual user and if so, changes the state of the like button to selected.*/
- (void)updateLikeStatus {
    // Query inside the like table that looks for an object that relates the post at hand with the current user
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"post" equalTo:self.post];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          if (objects.count != 0) {
              // Changes the color and selected state of the button
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

/* Action that takes place whenever the user taps the like button inside the cell, it calls
   for the like object to be created and updates the button's attributes. */
- (IBAction)tappedLikeButton:(id)sender {
    // Unables the like button until the database request is complete so no conlficts occur
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

- (IBAction)didTappedComment:(id)sender {
    [self.delegate postCell:self didCommentOn:self.post];
}

@end
