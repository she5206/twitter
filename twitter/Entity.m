//
//  Entity.m
//  twitter
//
//  Created by Man-Chun Hsieh on 7/3/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "Entity.h"


@interface Entity()

@property (strong,nonatomic) NSDictionary *dictionary;
@end

@implementation Entity

-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){
        self.dictionary = dictionary;
        self.media_url = [dictionary valueForKey:@"media.@media_url"];
        NSLog(self.media_url);
    }
    
    return self;
}

@end
