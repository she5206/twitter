//
//  User.h
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;


@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *tagline;

-(id) initWithDictionary:(NSDictionary *)dictionary;

+(User *) currentUser;
+(void)setcurrentUser:(User *)currentUser;
+(void)logout;
@end
