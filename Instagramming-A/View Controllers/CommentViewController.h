//
//  CommentViewController.h
//  Instagramming-A
//
//  Created by Andres Barragan on 07/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentViewController : UIViewController

@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
