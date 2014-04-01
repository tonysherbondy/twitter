//
//  TweetsViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeTweetViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "TweetCell.h"

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadTimeline];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navbar
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
    
    // Table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
}

- (void)loadTimeline
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [[TwitterClient instance] timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tweets = [Tweet arrayFromJSON:responseObject];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load timeline error");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)signout
{
    NSLog(@"sign out");
    [User signout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)newTweet
{
    NSLog(@"new tweet");
    ComposeTweetViewController *cvc = [[ComposeTweetViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = self.tweets[indexPath.row];
    
    // Need to consider the retweet header changing size
    
    // replace magic numbers with prototype cell
    int textWidth = 220;
    int heightOffset = 90;
    
    CGRect textRect = [tweet.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                             context:nil];
    return ceilf(textRect.size.height) + heightOffset;
}

@end
