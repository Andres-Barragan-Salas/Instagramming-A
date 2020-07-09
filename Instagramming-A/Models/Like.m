//
//  Like.m
//  Instagramming-A
//
//  Created by Andres Barragan on 08/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "Like.h"

@implementation Like

@dynamic author;
@dynamic post;

/* Delegate required method */
+ (nonnull NSString *)parseClassName {
    return @"Like";
}

/* Create a PFObject with the author and the post of the like in order for the
   user to only be able to like a post once.
   @param post: liked post
*/
+ (void)likePost:(Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    // Create the an object which relates the actual psot to the user liking it
    Like *newLike = [Like new];
    newLike.post = post;
    newLike.author = [PFUser currentUser];
    // Increment the like count of the post liked
    [post incrementKey:@"likeCount"];
    // Store all the changes in the Parse database
    [newLike saveInBackgroundWithBlock: completion];
}

/* Makes a queary for the like object regardig the current post and the actual user to
   delete it, so the post is unliked by the user at hand.
   @param post: unliked post
*/
+ (void)unlikePost:(Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    // Query to detect the like object which links the user and post involved in the like
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"post" equalTo:post];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          // The like object is deleted on completion (success finding the like relationship)
          [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
              if (succeeded) {
                  // The like count attribute of the post is decremented as the like is gone
                  [post incrementKey:@"likeCount" byAmount:@(-1)];
                  // Changes made to the post are updated in the Parse database
                  [post saveInBackgroundWithBlock:completion];
              }
          }];
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

@end
