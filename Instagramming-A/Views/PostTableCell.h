//
//  PostTableCell.h
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <ResponsiveLabel.h>
#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostTableCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (nonatomic, weak) id<PostCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (void)updateWithPost:(Post *)post;

@end

@protocol PostCellDelegate

- (void)postCell:(PostTableCell *) postCell didTap: (PFUser *)user;
- (void)postCell:(PostTableCell *)postCell didCommentOn:(Post *)post;

@end

NS_ASSUME_NONNULL_END
