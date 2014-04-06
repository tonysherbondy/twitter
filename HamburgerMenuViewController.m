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
@property (nonatomic, strong) UINavigationController *navController;
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
        self.navController = [[UINavigationController alloc] initWithRootViewController:self.tweetsController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.contentView addSubview:self.navController.view];
    CGRect frame = self.view.frame;
    self.contentView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self.navController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
 
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)]];
}

static const CGFloat sizeOpenMenu = 100;
- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGRect contentFrame = self.contentView.frame;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [panGestureRecognizer translationInView:self.view];
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        CGFloat x = contentFrame.origin.x + point.x;
        x = x > sizeOpenMenu ? sizeOpenMenu : x;
        x = x < 0 ? 0 : x;
        self.contentView.frame = CGRectMake(x, contentFrame.origin.y, contentFrame.size.width, contentFrame.size.height);
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            if ([panGestureRecognizer velocityInView:self.view].x < 0) {
                [self closeMenu];
            } else {
                [self openMenu];
            }
        }];
    }
}

- (void)closeMenu
{
    CGRect contentFrame = self.contentView.frame;
    self.contentView.frame = CGRectMake(0, 0, contentFrame.size.width, contentFrame.size.height);
}

- (void)openMenu
{
    CGRect contentFrame = self.contentView.frame;
    self.contentView.frame = CGRectMake(sizeOpenMenu, 0, contentFrame.size.width, contentFrame.size.height);
}

- (IBAction)onLogoutButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        [self closeMenu];
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"signout" object:nil];
    }];
}

@end
