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

@end

@implementation TweetsViewController

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
    self.navigationItem.title = @"Home";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweet)];
}

- (void)signout
{
    NSLog(@"sign out");
}

- (void)newTweet
{
    NSLog(@"new tweet");
    ComposeTweetViewController *cvc = [[ComposeTweetViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
