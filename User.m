//
//  User.m
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;
+ (User *)currentUser
{
    if (!currentUser) {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        currentUser = dictionary ? [[User alloc] initWithDictionary:dictionary] : nil;
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user
{
    currentUser = user;
    
    // Save to NSUserDefaults
    NSDictionary *dictionary = [user dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"current_user"];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    return @{@"name":self.name};
}

@end
