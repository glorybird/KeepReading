//
//  BookTableViewCell.h
//  keepreading
//
//  Created by FanFamily on 15/12/28.
//  Copyright © 2015年 glory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *surface;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *average;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *pages;
@property (nonatomic, weak) Book* book;
@property (nonatomic, weak) UIViewController* presentVC;

@end
