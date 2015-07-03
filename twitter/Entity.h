//
//  Entity.h
//  twitter
//
//  Created by Man-Chun Hsieh on 7/3/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject

@property (strong, nonatomic) NSString *media_url;
-(id) initWithDictionary:(NSDictionary *)dictionary;

@end
