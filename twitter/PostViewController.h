//
//  PostViewController.h
//  twitter
//
//  Created by Man-Chun Hsieh on 6/28/15.
//  Copyright (c) 2015 Man-Chun Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *postLabel;

@end
