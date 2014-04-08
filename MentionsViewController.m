//
//  MentionsViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/8/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "MentionsViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MentionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MentionsViewController

- (void)setupNavbar
{
    self.navigationItem.title = @"Mentions";
}

- (void)loadTimeline
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [[TwitterClient instance] mentionsTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
