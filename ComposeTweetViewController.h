//
//  ComposeTweetViewController.h
//  twitter
//
//  Created by Anthony Sherbondy on 3/30/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableProtocol.h"

@interface ComposeTweetViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, weak) id<RefreshableProtocol> refreshDelegate;
@end
