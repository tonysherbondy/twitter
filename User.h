//
//  User.h
//  twitter
//
//  Created by Anthony Sherbondy on 3/31/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface User : NSObject
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)signout;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic) NSInteger userID;

- (void)profileDataWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)timelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
