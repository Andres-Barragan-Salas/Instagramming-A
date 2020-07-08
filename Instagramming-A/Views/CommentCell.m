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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithComment:(Comment *)comment {
    self.commentLabel.text = comment.caption;
    
    PFUser *user = comment.author;
    self.usernameLabel.text = user.username;
    self.userImageView.file = user[@"image"];
    [self.userImageView loadInBackground];
}

@end
