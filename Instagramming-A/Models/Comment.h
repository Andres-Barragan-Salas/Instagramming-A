//
//  Comment.h
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSString *caption;

+ (void) postCommentWithCaption: ( NSString * _Nullable )caption onPost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
