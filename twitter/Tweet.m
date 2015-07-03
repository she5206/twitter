//
//  Tweet.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "Tweet.h"
#import "Entity.h"

@implementation Tweet
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        NSLog(@"%@", dictionary);
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.tid=dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        NSString *createdAtString =dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.retweetNumber = dictionary[@"retweet_count"];
        self.favoriteNumber = dictionary[@"favorite_count"];
        self.entity = [[Entity alloc] initWithDictionary:dictionary[@"extended_entities"]];
    }
    
    return self;
}


+ (NSArray *)tweetsWithArray:(NSArray *)array{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for(NSDictionary *dictory in array){
        [tweets addObject: [[Tweet alloc] initWithDictionary:dictory]];
    }
    return tweets;
}

@end
