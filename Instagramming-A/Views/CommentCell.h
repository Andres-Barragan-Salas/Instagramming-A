//
//  CommentCell.h
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol CommentCellDelegate;

@interface CommentCell : UITableViewCell

@property (nonatomic, weak) id<CommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) Comment *comment;

- (void)updateWithComment:(Comment *)comment;

@end

@protocol CommentCellDelegate

- (void)commentCell:(CommentCell *) commentCell didTap: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
