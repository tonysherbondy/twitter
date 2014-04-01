//
//  TweetsViewController.h
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableProtocol.h"

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RefreshableProtocol>
@end
