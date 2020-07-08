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

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (void)updateWithComment:(Comment *)comment;

@end

NS_ASSUME_NONNULL_END
