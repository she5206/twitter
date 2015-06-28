//
//  PostViewController.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/28/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "PostViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    User *user = [User currentUser];
    
    NSString *imageURL= user.profileImageUrl;
    [self.profileImage setImageWithURL:[NSURL URLWithString:imageURL]];
    self.nameLabel.text=user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",user.screenName];
    
    // 左邊 Logout
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Cancel"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onCancelButton)];
    
    
    // 右邊 Post
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Tweet"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onTweetButton)];
    
}

-(void)onCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onTweetButton{
    [[TwitterClient sharedInstance] newPost:self.postLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
