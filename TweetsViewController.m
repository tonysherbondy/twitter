//
//  TweetsViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeTweetViewController.h"

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
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

@end
