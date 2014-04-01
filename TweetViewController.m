//
//  TweetViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TweetViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TweetsViewController.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorHandleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFavoritesLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation TweetViewController

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
    
    self.navigationItem.title = @"Tweet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(reply)];
    
    // update the ui based on the tweet
    [self updateUI];
}

- (void)setTweet:(Tweet *)tweet
{
    // update the ui based on the tweet
    _tweet = tweet;
    [self updateUI];
}

- (void)updateUI
{
    if (self.tweet) {
        Tweet *tweet = self.tweet;
        // Update the UI when we set the tweet
        self.textLabel.text = tweet.text;
        self.authorNameLabel.text = tweet.author.name;
        self.authorHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.author.handle];
        self.dateLabel.text = tweet.fullDisplayDate;
        [self.authorImageView setImageWithURL:[NSURL URLWithString:tweet.author.imageURL]];
        
        self.numberRetweetsLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
        self.numberFavoritesLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
        
        if (tweet.isRetweeted) {
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        } else {
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
        }
        if (tweet.isFavorited) {
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
        } else {
            [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        }
        
        // Round the profile image corners
        CALayer *layer = [self.authorImageView layer];
        layer.masksToBounds = YES;
        layer.cornerRadius = 10.0;
    }
}

- (IBAction)favoriteButtonTouch:(UIButton *)sender
{
    if (self.tweet.isFavorited) {
        [self.tweet removeFromFavorites];
    } else {
        [self.tweet addToFavorites];
    }
    [self updateUI];
    [self.refreshDelegate refreshUI];
}

- (IBAction)retweetButtonTouch:(id)sender {
    if (self.tweet.isRetweeted) {
        [self.tweet unretweet];
    } else {
        [self.tweet retweet];
    }
    [self updateUI];
    [self.refreshDelegate refreshUI];
}

- (void)reply
{
    NSLog(@"reply");
}

@end
