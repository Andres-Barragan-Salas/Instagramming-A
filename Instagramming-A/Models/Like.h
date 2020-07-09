//
//  Like.h
//  Instagramming-A
//
//  Created by Andres Barragan on 08/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Like : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) Post *post;

+ (void) likePost:(Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) unlikePost:(Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
