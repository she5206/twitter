//
//  FullTweetViewController.h
//  twitter
//
//  Created by Man-Chun Hsieh on 7/2/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullTweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;


@property (strong, nonatomic) NSDictionary *tweet;
@end
