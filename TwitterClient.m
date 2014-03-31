//
//  TwitterClient.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TwitterClient.h"

#define TWITTER_BASEURL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"JPe0NlgfmAIACmRlWIptv0eKl"
#define TWITTER_CONSUMER_SECRET @"dyz93SHCN9a4vjYmRIjeFwxy8OeyfkKVD8XIPmghQQiVbwGPwM"

@implementation TwitterClient

+ (TwitterClient *)instance
{
    static dispatch_once_t once;
    static TwitterClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASEURL
                                              consumerKey:TWITTER_CONSUMER_KEY
                                           consumerSecret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

#pragma mark - OAuth Authorization

- (void)login
{
    [self fetchRequestTokenWithPath:@"/oauth/request_token"
                                            method:@"POST"
                                       callbackURL:[NSURL URLWithString:@"cptwitter://request"]
                                             scope:nil
                                           success:^(BDBOAuthToken *requestToken) {
											   NSLog(@"request token %@", requestToken);
											   
//                                               NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
//                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                           }
                                           failure:^(NSError *error) {
                                               NSLog(@"Error: %@", error.localizedDescription);
                                           }];
}

@end
