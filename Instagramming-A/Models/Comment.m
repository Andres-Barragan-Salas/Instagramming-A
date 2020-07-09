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

/* Delegate required method */
+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

/* Create a PFObject with comment attributes which is then stored in the Parse database.
   @param caption: content of the comment
   @param post: post in which the comment is submitted
*/
+ (void) postCommentWithCaption: ( NSString * _Nullable )caption onPost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    // Create the objects atributes with the information of the comment
    Comment *newComment = [Comment new];
    newComment.post = post;
    newComment.author = [PFUser currentUser];
    newComment.caption = caption;
    // Increment the comment count of the post in which the comment is placed
    [post incrementKey:@"commentCount"];
    // Save the created Comment object in the Parse database
    [newComment saveInBackgroundWithBlock: completion];
}

@end
