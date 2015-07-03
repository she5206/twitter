//
//  TwitterClient.h
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
@interface TwitterClient : BDBOAuth1RequestOperationManager


+ (TwitterClient *)sharedInstance;
-(void) loginWithCompelete:(void (^)(User *user, NSError *error))compeletion;
-(void) openUrl:(NSURL *)url;

-(void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
-(void) newPost:(NSString *)postContent;
-(void) retweet:(NSString *)retweetId;
-(void) favorite:(NSString *)favoriteId;
-(void) reply:(NSString *)postContent status_id:(NSString *)status_id;
@end
