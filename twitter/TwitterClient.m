 //
//  TwitterClient.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

//NSString * const kTwitterConsumerKey=@"wf57y68hBfWmdLEOs6MLsxLFM";
//NSString * const kTwitterConsumerSecret=@"2oclWdP9euYThB1GymyIgvqWLY5DY4VmscoaJtoZF0GVPGeV1C";
NSString * const kTwitterConsumerKey=@"JYgJcHLbSfNTxSdE8npwKKu5T";
NSString * const kTwitterConsumerSecret=@"7GpQrXxRyrSSMwDlA5QAoHIO62THpdblr6C7yG2a3lHJlYo0Yn";
NSString * const kTwitterBaseUrl=@"https://api.twitter.com";

@interface TwitterClient()
@property (strong,nonatomic) void(^logincompelete)(User *user, NSError *error);
@end

@implementation TwitterClient


+ (TwitterClient *)sharedInstance{
    static TwitterClient *instance = nil;
    
    //只有第一次的時候做這件事
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

-(void) loginWithCompelete:(void (^)(User *user, NSError *error))compeletion{
    self.logincompelete = compeletion;
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"kochitwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        // 成功取得requestToken
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];

        // ios會自動尋找可以打開authURL的APP (ex Safari)
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"fail to token");
        self.logincompelete(nil, error);
    }];
}

-(void) openUrl:(NSURL *)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query ] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"get access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //成功拉回user資訊
            User *user = [[User alloc] initWithDictionary:responseObject];
            
            //把login成功的user存起來
            [User setcurrentUser:user];
            
            self.logincompelete(user,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.logincompelete(nil,error);
            NSLog(@"fail get responseobj");
        }];
        
/*        
    [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            for(Tweet *tweet in tweets){
                NSLog(@"tweet:%@ createdAt:%@",tweet.text,tweet.createdAt);
            }
            //NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail get responseobj");
        }];
 */
        
    } failure:^(NSError *error) {
        self.logincompelete(nil,error);
        NSLog(@"fail get access token");
    }];

}

-(void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        //NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail get responseobj");
    }];
}


-(void) newPost:(NSString *)postContent{
        NSDictionary *parameters = @{@"status": postContent};
            [self POST:@"1.1/statuses/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"success post");
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"post fail %@",error);
            }];
    
    // 傳訊息到某人的msg裡面拉！私訊
//    NSDictionary *parameters = @{@"text": @"hihi",
//                                 @"screen_name": @"emily1233212002"};
//        [self POST:@"1.1/direct_messages/new.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"success post %@",responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"post fail %@",error);
//        }];

    
}



@end
