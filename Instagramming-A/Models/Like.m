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

+ (nonnull NSString *)parseClassName {
    return @"Like";
}

+ (void)likePost:(Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Like *newLike = [Like new];
    newLike.post = post;
    newLike.author = [PFUser currentUser];
    
    [post incrementKey:@"likeCount"];
    
    [newLike saveInBackgroundWithBlock: completion];
}

+ (void)unlikePost:(Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"post" equalTo:post];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
              if (succeeded) {
                  [post incrementKey:@"likeCount" byAmount:@(-1)];
                  [post saveInBackgroundWithBlock:completion];
              }
          }];
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

@end
