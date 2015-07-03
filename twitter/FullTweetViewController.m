//
//  FullTweetViewController.m
//  twitter
//
//  Created by Man-Chun Hsieh on 7/2/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "FullTweetViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "PostViewController.h"

@interface FullTweetViewController ()
@property (strong,nonatomic) Tweet *fulltweet;
@end

@implementation FullTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"推文";
    //[self.contentLabel sizeToFit];
    [self loadData];
    
}

- (void) loadData{
    self.fulltweet = self.tweet;
    
    // profile image url
    NSString *imageURL= self.fulltweet.user.profileImageUrl;
    [self.imageView setImageWithURL:[NSURL URLWithString:imageURL]];
    // text
    self.idLabel.text = self.fulltweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.fulltweet.user.screenName];
    self.contentLabel.text = self.fulltweet.text;
    self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweet",self.fulltweet.retweetNumber];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%@ favorite",self.fulltweet.favoriteNumber];
    // media url : todo
    //    if(fulltweet.entity.media_url){
    //        NSString *mediaURL= fulltweet.entity.media_url;
    //        NSLog(@"=======%@=========",mediaURL);
    //        [self.mediaImageView setImageWithURL:[NSURL URLWithString:mediaURL]];
    //    }
    // create date
    NSDate *currentDateTime = self.fulltweet.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd a HH:mm"];
    [dateFormatter setAMSymbol:@"上午"];
    [dateFormatter setPMSymbol:@"下午"];
    NSString *dateString = [dateFormatter stringFromDate:currentDateTime];
    self.timeLabel.text = dateString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onReply:(UIButton *)sender {
    PostViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PostView"];  //記得要用storyboard id 傳過去
    vc.replyID = self.fulltweet.tid;
    vc.replyName = self.fulltweet.user.screenName;
    NSLog(self.fulltweet.tid);
    NSLog(self.fulltweet.user.screenName);
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)onRetweet:(UIButton *)sender {
    [[TwitterClient sharedInstance] retweet:self.fulltweet.tid];
    // change image
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"retweeted.png"] forState:UIControlStateNormal];
}
- (IBAction)onFavorite:(UIButton *)sender {
    [[TwitterClient sharedInstance] favorite:self.fulltweet.tid];
    // change image
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"favorited.png"] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
