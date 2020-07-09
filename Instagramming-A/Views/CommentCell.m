//
//  CommentCell.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    
    UITapGestureRecognizer *userTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.userImageView addGestureRecognizer:userTapGestureRecognizer];
    [self.userImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithComment:(Comment *)comment {
    self.comment = comment;
    
    self.commentLabel.text = comment.caption;
    
    PFUser *user = comment.author;
    self.usernameLabel.text = user.username;
    self.userImageView.file = user[@"image"];
    [self.userImageView loadInBackground];
}

- (void) didTapUserProfile:(UIGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.userImageView.alpha = 0.5;
        self.userImageView.alpha = 1;
    }];
    [self.delegate commentCell:self didTap:self.comment.author];
}

@end
