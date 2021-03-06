//
//  TweetCell.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/1/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@end

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)profileImageClick:(UITapGestureRecognizer *)tapGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show_profile" object:self.tweet.author];
}

- (void)setTweet:(Tweet *)tweet
{
    // Update the UI when we set the tweet
    self.tweetTextLabel.text = tweet.text;
    self.authorNameLabel.text = tweet.author.name;
    self.authorHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.author.handle];
    self.dateLabel.text = tweet.sinceDate;
    [self.authorImageView setImageWithURL:[NSURL URLWithString:tweet.author.imageURL]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageClick:)];
    [self.authorImageView addGestureRecognizer:tap];
    
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
    
    _tweet = tweet;
}

@end
