//
//  PostTableCell.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "PostTableCell.h"
#import "NSDate+DateTools.h"

@implementation PostTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithPost:(Post *)post {
    self.post = post;
    
    self.descriptionLabel.text = post.caption;
    self.dateLabel.text = post.createdAt.timeAgoSinceNow;
    self.likesCountLabel.text = [post.likeCount stringValue];
    self.comentsCountLabel.text = [NSString stringWithFormat:@"%@ Comments", post.commentCount];
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    
    PFUser *user = post.author;
    self.usernameLabel.text = user.username;
    self.authorLabel.text = user.username;
    self.userImageView.file = user[@"image"];
    [self.userImageView loadInBackground];
}

@end
