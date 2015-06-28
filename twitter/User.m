//
//  User.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification =@"UserDidLoginNotification";
NSString * const UserDidLogoutNotification =@"UserDidLogoutNotification";

@interface User()

@property (strong,nonatomic) NSDictionary *dictionary;
@end

@implementation User

-(id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }
    
    return self;
}

static User *_currentUser=nil;
NSString * const kCurrentUserKey =@"kCurrentUserKey";
+(User *) currentUser{
    if(_currentUser == nil){
        NSData *data =[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if(data!=nil){
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc]initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}
+(void)setcurrentUser:(User *)currentUser{
    _currentUser=currentUser;
    
    if(_currentUser!=nil){
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)logout{
    [User setcurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
