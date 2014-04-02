//
//  Tweet.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "TwitterClient.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.tweetId = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.isFavorited = [dictionary[@"favorited"] boolValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.isRetweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        
        if (dictionary[@"current_user_retweet"]) {
			self.retweetId = dictionary[@"current_user_retweet"][@"id_str"];
		}
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
        self.date = [formatter dateFromString:dictionary[@"created_at"]];
    }
    return self;
}

+ (NSArray *)arrayFromJSON:(NSArray *)jsonArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in jsonArray) {
        [array addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return array;
}

+ (void)createTweetWithText:(NSString *)text success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[TwitterClient instance] POST:@"1.1/statuses/update.json"
                        parameters:@{@"status":text}
                           success:success
                           failure:failure];
}

@synthesize sinceDate = _sinceDate;
- (NSString *)sinceDate
{
    if (!_sinceDate) {
        NSTimeInterval elapsedTimeInterval = [self.date timeIntervalSinceNow];
		int elapsedSeconds = (int)(elapsedTimeInterval * -1);
        
		if (elapsedSeconds < 60) {
            _sinceDate = @"now";
		}
		else if (elapsedSeconds < 3600) {
			int minutes = elapsedSeconds / 60;
			_sinceDate = [NSString stringWithFormat:@"%dm", minutes];
		}
		else if (elapsedSeconds < 86400) {
			int hours = elapsedSeconds / 3600;
			_sinceDate = [NSString stringWithFormat:@"%dh", hours];
		}
		else if (elapsedSeconds < 31536000) {
			int days = elapsedSeconds / 86400;
			_sinceDate = [NSString stringWithFormat:@"%dd", days];
		}
		else {
			int years = elapsedSeconds / 31536000;
			_sinceDate = [NSString stringWithFormat:@"%dyr", years];
		}
    }
    return _sinceDate;
}

@synthesize fullDisplayDate = _fullDisplayDate;
- (NSString *)fullDisplayDate
{
    if (!_fullDisplayDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yy, h:mm a"];
        _fullDisplayDate = [formatter stringFromDate:self.date];
    }
    return _fullDisplayDate;
}

- (void)addToFavorites
{
    if (!self.isFavorited) {
        self.isFavorited = YES;
        self.favoriteCount++;
        [[TwitterClient instance] POST:@"1.1/favorites/create.json"
                            parameters:@{@"id":self.tweetId}
                               success:nil
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"couldn't favorite");
                                   self.favoriteCount--;
                                   self.isFavorited = NO;
                               }];
    }
}

- (void)removeFromFavorites
{
    if (self.isFavorited) {
        self.isFavorited = NO;
        self.favoriteCount--;
        [[TwitterClient instance] POST:@"1.1/favorites/destroy.json"
                            parameters:@{@"id":self.tweetId}
                               success:nil
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   self.favoriteCount++;
                                   self.isFavorited = YES;
                               }];

    }
}

- (void)retweet
{
	if (!self.isRetweeted) {
		self.isRetweeted = YES;
		self.retweetCount++;
		
		[[TwitterClient instance] POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.tweetId]
         
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   self.retweetId = responseObject[@"id_str"];
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"error retweeting");
                                   self.isRetweeted = NO;
                                   self.retweetCount--;
                               }];
									
	}
}

- (void)unretweet
{
	if (self.isRetweeted) {
		self.isRetweeted = NO;
		self.retweetCount--;
		
		[[TwitterClient instance] POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", self.retweetId]
									
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   self.retweetId = nil;
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"error: %@", error);
                                   self.isRetweeted = YES;
                                   self.retweetCount++;
                               }];
	}
}


@end
