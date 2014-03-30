//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ComposeTweetViewController.h"

@interface ComposeTweetViewController ()

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweet)];
}

- (void)cancel
{
    NSLog(@"cancel");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tweet
{
    NSLog(@"tweet");
}

@end
