//
//  TimelineCell.h
//  twitter
//
//  Created by Man-Chun Hsieh on 6/27/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNamelabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *retweetBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@end
