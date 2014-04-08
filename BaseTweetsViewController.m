//
//  BaseTweetsViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/8/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "BaseTweetsViewController.h"
#import "User.h"
#import "TweetCell.h"
#import "TweetViewController.h"

@interface BaseTweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BaseTweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadTimeline];
    }
    return self;
}

- (void)loadTimeline
{
    NSLog(@"Need to implement loadTimeline!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    [self setupTable];
    [self setupRefreshControl];
    
}

- (void)setupNavbar
{
    self.navigationItem.title = @"Base";
}

- (void)setupTable
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)refreshUI
{
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetViewController *tweetVC = [[TweetViewController alloc] init];
    tweetVC.tweet = self.tweets[indexPath.row];
    tweetVC.refreshDelegate = self;
    [self.navigationController pushViewController:tweetVC animated:YES];
}

@end
