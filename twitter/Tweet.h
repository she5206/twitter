//
//  Tweet.h
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) User *user;

-(id) initWithDictionary:(NSDictionary *)dictionary;
+(NSArray *) tweetsWithArray:(NSArray *)array;

@end
