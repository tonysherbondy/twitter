//
//  BaseTweetsViewController.h
//  twitter
//
//  Created by Anthony Sherbondy on 4/8/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableProtocol.h"

@interface BaseTweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RefreshableProtocol>
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
