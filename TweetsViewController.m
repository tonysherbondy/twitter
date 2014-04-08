//
//  TweetsViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TweetsViewController

- (void)setupNavbar
{
    self.navigationItem.title = @"Home";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
}

- (void)newTweet
{
    ComposeTweetViewController *cvc = [[ComposeTweetViewController alloc] init];
    cvc.tweets = self.tweets;
    cvc.refreshDelegate = self;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)loadTimeline
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [[TwitterClient instance] timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tweets = [[Tweet arrayFromJSON:responseObject] mutableCopy];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load timeline error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
    }];
}

@end
