//
//  ProfileViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/6/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;

@property (nonatomic, strong) NSString *backgroundImageURL;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic) NSInteger numTweets;
@property (nonatomic) NSInteger numFollowers;
@property (nonatomic) NSInteger numFollowing;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)setUser:(User *)user
{
    _user = user;
    [self loadUserProfile];
}

- (void)refreshUI
{
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.backgroundImageURL]];
    self.numTweetsLabel.text = [NSString stringWithFormat:@"%d", self.numTweets];
    self.numFollowingLabel.text = [NSString stringWithFormat:@"%d", self.numFollowing];
    self.numFollowersLabel.text = [NSString stringWithFormat:@"%d", self.numFollowers];
}

@end
