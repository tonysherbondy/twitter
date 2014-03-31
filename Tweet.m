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

@end
