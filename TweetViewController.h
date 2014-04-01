//
//  TweetViewController.h
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "RefreshableProtocol.h"

@interface TweetViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id <RefreshableProtocol> refreshDelegate;
@end
