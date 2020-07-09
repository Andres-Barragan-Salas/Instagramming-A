//
//  Post.m
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;

/* Delegate required method */
+ (nonnull NSString *)parseClassName {
    return @"Post";
}

/* Create a PFObject with Post attributes which is then stored in the Parse database.
   @param image: image to be posted to the feed
   @param caption: text input that goes along with the image
*/
+ (void)postUserImage:( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    // Create the objects atributes with the information of the post
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    // Create an object of tipe PFUser to be stored as an attribute of the post ("author")
    PFUser *user = [PFUser currentUser];
    newPost.author = user;
    [user incrementKey:@"postCount"];
    // Saves the object into the Parse database
    [newPost saveInBackgroundWithBlock: completion];
}

/* Method to convert an image into a PFFile (format accepted by database) */
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // Check if image is not nil
    if (!image) {
        return nil;
    }
    // Get image data and check if that is not nil
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    // Convert image into a file
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
