//
//  TimelineViewController.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineCell.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "PostViewController.h"
#import "FullTweetViewController.h"


@interface TimelineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *timelineTable;
@property (strong, nonatomic) NSArray* tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timelineTable.delegate = self;
    self.timelineTable.dataSource = self;

    // auto height
    self.timelineTable.estimatedRowHeight = 250.0;
    self.timelineTable.rowHeight = UITableViewAutomaticDimension;

    // load data
    [self loadTimeline];
    
    // do Navigation settings
    [self setNavgationBar];

    // PULL refresh table view
    [self addRefreshViewController];
    
    
}

- (void) setNavgationBar{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:135/255.0f green:206/255.0f blue:250/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    self.title=@"Twitter";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // 左邊 Logout
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Logout"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onLogoutButton)];

    
    // 右邊 Post
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Post"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onPostButton)];

}

-(void)onLogoutButton{
    [User logout];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)onPostButton{
    PostViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PostView"];  //記得要用storyboard id 傳過去
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}


-(void)loadTimeline{
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.timelineTable reloadData];
//        for(Tweet *tweet in tweets){
//            NSLog(@"tweet:%@ createdAt:%@",tweet.text,tweet.createdAt);
//        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTimelineCell" forIndexPath:indexPath];
//    for(Tweet *tweet in self.tweets){
//        NSLog(@"[tweet]:%@ [createdAt]:%@ [image]:%@",tweet.text,tweet.createdAt,tweet.user.profileImageUrl);
//    }
    Tweet *tweet = self.tweets[indexPath.row];
    cell.contentLabel.text=tweet.text;
    cell.nameLabel.text=tweet.user.name;
    cell.screenNamelabel.text=[NSString stringWithFormat:@"@%@",tweet.user.screenName];
    
    //處理時間格式
    //NSString *createdAtString =tweet.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    cell.createdAtLabel.text = [self convertTimeToAgo:tweet.createdAt];

    // 處理圖片
    NSString *imageURL= tweet.user.profileImageUrl;
    [cell.profile setImageWithURL:[NSURL URLWithString:imageURL]];


    cell.replyBtn.tag = indexPath.row;
    cell.retweetBtn.tag = indexPath.row;
    cell.favoriteBtn.tag = indexPath.row;
    return cell;
}

- (NSString *)convertTimeToAgo:(NSDate *)createdDate
{
    NSTimeInterval time_get = [createdDate timeIntervalSince1970];
    NSTimeInterval time_now = [[NSDate date] timeIntervalSince1970];
    
    double difference = time_now - time_get;
    NSMutableArray *periods = [NSMutableArray arrayWithObjects:@"sec", @"min", @"hr", @"day", @"week", @"month", @"year", @"decade", nil];
    NSArray *lengths = [NSArray arrayWithObjects:@60, @60, @24, @7, @4.35, @12, @10, nil];
    int j = 0;
    for(j=0; difference >= [[lengths objectAtIndex:j] doubleValue]; j++)
    {
        difference /= [[lengths objectAtIndex:j] doubleValue];
    }
    difference = roundl(difference);
    if(difference != 1)
    {
        [periods insertObject:[[periods objectAtIndex:j] stringByAppendingString:@"s"] atIndex:j];
    }
    return [NSString stringWithFormat:@"%li %@", (long)difference, [periods objectAtIndex:j]];
}

- (IBAction)onLogout:(UIButton *)sender {
    [User logout];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)addRefreshViewController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"uploading your timeline..."];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.timelineTable addSubview:self.refreshControl]; //把RefreshControl加到TableView中
}
-(void) refresh {
    [self.refreshControl beginRefreshing];
    [self loadTimeline];
    [self.refreshControl endRefreshing];
}
- (IBAction)onRetweet:(UIButton *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    Tweet *tweet = self.tweets[indexPath.row];
    [[TwitterClient sharedInstance] retweet:tweet.tid];
    // change image
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"retweeted.png"] forState:UIControlStateNormal];
}

- (IBAction)onFavorite:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    Tweet *tweet = self.tweets[indexPath.row];
    [[TwitterClient sharedInstance] favorite:tweet.tid];
    // change image
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"favorited.png"] forState:UIControlStateNormal];
}
- (IBAction)onReply:(UIButton *)sender {
    PostViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PostView"];  //記得要用storyboard id 傳過去
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    Tweet *tweet = self.tweets[indexPath.row];
    vc.replyID = tweet.tid;
    vc.replyName = tweet.user.screenName;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TimelineCell *cell = sender; // 轉型
    NSIndexPath *indexPath = [self.timelineTable indexPathForCell:cell];
    NSDictionary *tweet = self.tweets[indexPath.row];
    FullTweetViewController *dest = segue.destinationViewController; //傳給下一頁
    dest.tweet = tweet;
}

@end
