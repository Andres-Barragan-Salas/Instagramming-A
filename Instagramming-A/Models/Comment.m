//
//  Comment.m
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic author;
@dynamic post;
@dynamic caption;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) postCommentWithCaption: ( NSString * _Nullable )caption onPost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Comment *newComment = [Comment new];
    newComment.post = post;
    newComment.author = [PFUser currentUser];
    newComment.caption = caption;
    
    [newComment saveInBackgroundWithBlock: completion];
}

@end
