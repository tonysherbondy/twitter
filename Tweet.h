//
//  Tweet.h
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)arrayFromJSON:(NSArray *)jsonArray;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *author;
@end
