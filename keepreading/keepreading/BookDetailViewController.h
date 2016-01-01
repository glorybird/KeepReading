//
//  BookDetailViewController.h
//  keepreading
//
//  Created by FanFamily on 16/1/1.
//  Copyright © 2016年 glory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *surface;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *average;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *pages;
@property (nonatomic, weak) Book* book;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *briefView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UIButton *addLocalReadListButton;

@property (nonatomic, assign) BOOL isComeFromSearchList;

@end
