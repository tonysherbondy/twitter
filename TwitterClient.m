//
//  TwitterClient.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "TwitterClient.h"
#import <BDBOAuth1Manager/NSDictionary+BDBOAuth1Manager.h>
#import "TwitterClient.h"
#import "User.h"

#define TWITTER_BASEURL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"lCFBhLO0xQm0W0bJYpiMKzlYO"
#define TWITTER_CONSUMER_SECRET @"XXPjsKltBS65LeiO4UHumGnY5t94uUxtksDkvsyfSDV3fG2BAu"

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
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"/oauth/request_token"
                                            method:@"POST"
                                       callbackURL:[NSURL URLWithString:@"cptwitter://request"]
                                             scope:nil
                                           success:^(BDBOAuthToken *requestToken) {
											   NSLog(@"request token %@", requestToken);
											   
                                               NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                           }
                                           failure:^(NSError *error) {
                                               NSLog(@"Error: %@", error.localizedDescription);
                                           }];
}

- (BOOL)authorizationCallbackURL:(NSURL *)url onSuccess:(void (^)(void))completion
{
	if ([url.scheme isEqualToString:@"cptwitter"]) {
		if ([url.host isEqualToString:@"request"])	{
			NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
            NSLog(@"parameters: %@", parameters);
			if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
				[client fetchAccessTokenWithPath:@"/oauth/access_token"
													   method:@"POST"
												 requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
													  success:^(BDBOAuthToken *accessToken) {
														  NSLog(@"access token %@", accessToken);
														  [client.requestSerializer saveAccessToken:accessToken];
                                                          [self currentUser:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              if ([User currentUser]) {
                                                                  NSLog(@"already have user = %@", [User currentUser].name);
                                                              } else {
                                                                  User *user = [[User alloc] initWithDictionary:(NSDictionary *)responseObject];
                                                                  [User setCurrentUser:user];
                                                                  NSLog(@"new user = %@", [User currentUser].name);
                                                              }
                                                              if (completion) {
                                                                  completion();
                                                              }
                                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              NSLog(@"response error");
                                                          }];
													  }
													  failure:^(NSError *error) {
														  NSLog(@"Error: %@", error.localizedDescription);
													  }];
			}
		}
        
		return YES;
	}
    
	return NO;
}

- (void)timelineWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:@{@"include_my_retweet": @(YES)}
      success:success
      failure:failure];
}

- (void)mentionsTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self GET:@"1.1/statuses/mentions_timeline.json"
   parameters:nil
      success:success
      failure:failure];
}

- (void)currentUser:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

@end
