//
//  PostViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "CommentViewController.h"
#import "UserViewController.h"
#import "PostViewController.h"
#import "PostTableCell.h"
#import "CommentCell.h"
#import "Comment.h"

@interface PostViewController () <UITableViewDataSource, UITableViewDelegate, PostCellDelegate, CommentCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *comments;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    if (self.toComment) {
        [self performSegueWithIdentifier:@"CommentButtonSegue" sender:nil];
    }
    
    [self fetchComments];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count + 1;
}

- (void)fetchComments {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Comment"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"post"];
    [postQuery whereKey:@"post" equalTo:self.post];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;

    // Fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Comment *> * _Nullable comments, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.comments = comments;
            [self.tableView reloadData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        PostTableCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"PostTableCell"];
        postCell.delegate = self;
        Post *post = self.post;
        [postCell updateWithPost:post];
        return postCell;
    }
    else {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        commentCell.delegate = self;
        Comment *comment = self.comments[indexPath.row - 1];
        [commentCell updateWithComment:comment];
        return commentCell;
    }
    
    return cell;
}

- (void)postCell:(nonnull PostTableCell *)postCell didTap:(nonnull PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)commentCell:(nonnull PostTableCell *)postCell didTap:(nonnull PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"CommentButtonSegue"]) {
        self.toComment = NO;
        UINavigationController *navigationController = [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController *)navigationController.topViewController;
        commentViewController.post = self.post;
    }
    if ([segue.identifier isEqual:@"profileSegue"]) {
        UserViewController *userViewController = [segue destinationViewController];
        userViewController.user = sender;
    }
}


@end
