//
//  LoginViewController.m
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TimelineViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginbtn;
@end

@implementation LoginViewController
- (IBAction)onLogin:(UIButton *)sender {
    
    [[TwitterClient sharedInstance] loginWithCompelete:^(User *user, NSError *error) {
        if(user !=nil){ //有取得user info
            NSLog(@"Welcome %@",user.name);
            TimelineViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"Timeline"];  //記得要用storyboard id 傳過去
            
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:NO completion:nil];
        }else{
            NSLog(@"fail %@",error);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
