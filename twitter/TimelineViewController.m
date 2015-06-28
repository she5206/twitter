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

@interface TimelineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *timelineTable;
@property (strong, nonatomic) NSArray* tweets;


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
        // Do any additional setup after loading the view.
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
    
    //處理時間格式
    //NSString *createdAtString =tweet.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    cell.createdAtLabel.text = [self convertTimeToAgo:tweet.createdAt];

    // 處理圖片
    
    NSString *imageURL= tweet.user.profileImageUrl;
    [cell.profile setImageWithURL:[NSURL URLWithString:imageURL]];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
