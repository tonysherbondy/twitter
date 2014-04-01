//
//  TweetCell.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/1/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TweetCell.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
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

- (void)setTweet:(Tweet *)tweet
{
    // Update the UI when we set the tweet
    self.tweetTextLabel.text = tweet.text;
    self.authorNameLabel.text = tweet.author.name;
    _tweet = tweet;
}

@end
