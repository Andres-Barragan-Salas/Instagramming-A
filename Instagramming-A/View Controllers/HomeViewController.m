//
//  HomeViewController.m
//  Instagramming-A
//
//  Created by Andres Barragan on 06/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "PostViewController.h"
#import "HomeViewController.h"
#import "PostTableCell.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts {
   PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

   // Fetch data asynchronously
   [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
       if (error) {
           NSLog(@"%@", error.localizedDescription);
       } else {
           self.posts = posts;
           [self.tableView reloadData];
           [self.refreshControl endRefreshing];
       }
   }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableCell"];
    
    Post *post = self.posts[indexPath.row];
    [cell updateWithPost:post];
    
    return cell;
}

- (IBAction)tappedUpload:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"PostCellSegue"]) {
        PostTableCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        PostViewController *singlePostViewController = [segue destinationViewController];
        singlePostViewController.post = post;
    }
}


@end
