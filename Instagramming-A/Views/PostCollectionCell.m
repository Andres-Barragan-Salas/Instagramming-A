//
//  PostCollectionCell.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

- (void)updateWithPost:(Post *)post {
    self.postImageView.image = nil;
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
}

@end
