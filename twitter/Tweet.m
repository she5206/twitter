//
//  Tweet.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        NSLog(@"%@", dictionary);
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString *createdAtString =dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
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
