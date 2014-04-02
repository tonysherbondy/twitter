//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>
#import "Tweet.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, strong) UIBarButtonItem *numberCharsBarItem;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;
@end

@implementation ComposeTweetViewController

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    self.numberCharsBarItem = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.numberCharsBarItem.tintColor = [UIColor grayColor];
    
    self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];
    self.tweetButton.enabled = NO;
    self.navigationItem.rightBarButtonItems = @[self.tweetButton, self.numberCharsBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    // Update view
    User *currentUser = [User currentUser];
    self.userNameLabel.text = currentUser.name;
    self.userHandleLabel.text = [NSString stringWithFormat:@"@%@",currentUser.handle];
    [self.userImageView setImageWithURL:[NSURL URLWithString:currentUser.imageURL]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}
     
- (void)textViewDidChange
{
    NSString *text = self.tweetTextView.text;
    NSInteger numberChars = 140 - text.length;
    UIColor *tintColor = nil;
    if (numberChars < 0) {
        tintColor = [UIColor redColor];
        self.tweetButton.enabled = NO;
    } else {
        tintColor = [UIColor grayColor];
        if (text.length > 0) {
            self.tweetButton.enabled = YES;
        }
    }
    self.numberCharsBarItem.tintColor = tintColor;
    self.numberCharsBarItem.title =[NSString stringWithFormat:@"%d", numberChars];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tweet
{
    [Tweet createTweetWithText:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        [self.tweets insertObject:tweet atIndex:0];
        [self.refreshDelegate refreshUI];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error creating new tweet");
    }];
}

@end
