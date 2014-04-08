//
//  ProfileController.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/8/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ProfileController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSString *backgroundImageURL;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic) NSInteger numTweets;
@property (nonatomic) NSInteger numFollowers;
@property (nonatomic) NSInteger numFollowing;
@end

@implementation ProfileController

- (void)setupNavbar
{
    self.navigationItem.title = @"Profile";
}

- (void)setupTable
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    [self loadUserProfile];
}

- (void)loadUserProfile
{
    //    User *user = [User currentUser];
    if (self.user) {
        [self.user profileDataWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.backgroundImageURL = responseObject[@"profile_background_image_url"];
            self.profileImageURL = responseObject[@"profile_image_url"];
            self.numFollowers = [responseObject[@"followers_count"] integerValue];
            self.numFollowing = [responseObject[@"friends_count"] integerValue];
            self.numTweets = [responseObject[@"statuses_count"] integerValue];
            [self refreshUI];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error retrieving profile data for %@", self.user.name);
            NSLog(@"error: %@", error);
        }];
    }
}

// this should be the overridden method and it should say loadTweets or something
- (void)loadTimeline
{
    if (self.user) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        [self.user timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tweets = [[Tweet arrayFromJSON:responseObject] mutableCopy];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"load timeline error");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.refreshControl endRefreshing];
        }];
    }
}

- (void)setUser:(User *)user
{
    _user = user;
    [self loadUserProfile];
    [self loadTimeline];
}

- (void)refreshUI
{
    [self.tableView reloadData];
    
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.backgroundImageURL]];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.profileImageURL]];
    self.numTweetsLabel.text = [NSString stringWithFormat:@"%d", self.numTweets];
    self.numFollowingLabel.text = [NSString stringWithFormat:@"%d", self.numFollowing];
    self.numFollowersLabel.text = [NSString stringWithFormat:@"%d", self.numFollowers];
}

@end
