//
//  HamburgerMenuViewController.m
//  twitter
//
//  Created by Anthony Sherbondy on 4/6/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "HamburgerMenuViewController.h"
#import "TweetsViewController.h"

@interface HamburgerMenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) TweetsViewController *tweetsController;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation HamburgerMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweetsController = [[TweetsViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.contentView addSubview:self.tweetsController.view];
    CGRect frame = self.view.frame;
    self.tweetsController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

@end
