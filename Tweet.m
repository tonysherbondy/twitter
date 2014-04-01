//
//  Tweet.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.isFavorited = [dictionary[@"favorited"] boolValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.isRetweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        
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

@end
