//
//  TwitterClient.h
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *)instance;
- (void)login;
@end
