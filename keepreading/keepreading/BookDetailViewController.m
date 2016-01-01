//
//  BookDetailViewController.m
//  keepreading
//
//  Created by FanFamily on 16/1/1.
//  Copyright © 2016年 glory. All rights reserved.
//

#import "BookDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BookCore.h"

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.surface sd_setImageWithURL:[NSURL URLWithString:self.book.imageUrl]];;
    self.bookTitle.text = self.book.title;
    self.average.text = [NSString stringWithFormat:@"评分:%@", self.book.average];
    self.author.text = [NSString stringWithFormat:@"作者:%@", self.book.authors.firstObject];
    self.pages.text = [NSString stringWithFormat:@"页数:%@", self.book.pages];
    [self.summaryTextView setText:self.book.summary];
    [self.summaryTextView setTextColor:[UIColor whiteColor]];
    if (self.isComeFromSearchList) {
        self.addLocalReadListButton.hidden = NO;
        if ([[BookCore sharedInstance] bookWithId:self.book.uid]) {
            [self.addLocalReadListButton setTitle:@"已加入阅读列表" forState:UIControlStateNormal];
            self.addLocalReadListButton.enabled = NO;
        }
    } else {
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteBook:)];
        self.navigationItem.rightBarButtonItem = deleteButton;
    }
}

- (void)deleteBook:(id)sender
{
    [[BookCore sharedInstance] deleteBookWithId:self.book.uid];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize newSize = [self.summaryTextView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
    [self.summaryTextView setFrame:CGRectMake(0, self.briefView.frame.size.height, newSize.width, newSize.height)];
    __block NSInteger height = 0;
    [self.scrollview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        height += obj.frame.size.height;
    }];
    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, height);
    [self.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToLocalReadList:(id)sender {
    [[BookCore sharedInstance] saveBook:self.book];
    [self.addLocalReadListButton setTitle:@"已加入阅读列表" forState:UIControlStateNormal];
    self.addLocalReadListButton.enabled = NO;
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
