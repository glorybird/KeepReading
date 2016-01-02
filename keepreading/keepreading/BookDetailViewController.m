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

@property (nonatomic, assign) CGFloat preProgressValue;

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
        self.progressView.hidden = YES;
        self.progressSlider.hidden = YES;
        if ([[BookCore sharedInstance] bookWithId:self.book.uid]) {
            [self.addLocalReadListButton setTitle:@"已加入阅读列表" forState:UIControlStateNormal];
            self.addLocalReadListButton.enabled = NO;
        }
    } else {
        self.progressView.hidden = NO;
        self.progressView.hintViewBackgroundColor = [UIColor clearColor];
        self.progressView.startAngle = -90;
        self.progressView.hintTextFont = [UIFont systemFontOfSize:13];
        self.progressView.progressBarWidth = 10.0f;
        self.progressView.progressBarProgressColor = [UIColor blackColor];
        self.progressView.progressBarTrackColor = [UIColor clearColor];
        self.progressSlider.hidden = NO;
        self.progressSlider.minimumValue = 0.0f;
        self.progressSlider.maximumValue = [self.book.pages floatValue];
        self.progressSlider.value = [[[BookCore sharedInstance] progessWithBookId:self.book.uid] floatValue];
        self.preProgressValue = self.progressSlider.value;
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteBook:)];
        [self.progressView setProgress:self.progressSlider.value/[self.book.pages floatValue] animated:NO];
        self.navigationItem.rightBarButtonItem = deleteButton;
        [self.progressView setHintTextGenerationBlock:^NSString *(CGFloat progress) {
            if (progress == 1) {
                return @"已完成";
            } else {
                return [NSString stringWithFormat:@"%ld/%@", (NSInteger)self.progressSlider.value, self.book.pages];
            }
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BookCore sharedInstance] saveProgressWithBookId:self.book.uid progress:@(self.progressSlider.value)];
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
    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAX([UIScreen mainScreen].bounds.size.height, height));
    [self.view layoutIfNeeded];
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

- (IBAction)progressValue:(UIControl*)sender {
    if ([sender isTouchInside] && [sender isTracking]) {
        self.preProgressValue = self.progressSlider.value;
        [self.progressView setProgress:self.progressSlider.value/self.book.pages.floatValue animated:NO];
        if (self.progressSlider.value/self.book.pages.floatValue == 1.0f) {
            [[BookCore sharedInstance] saveProgressWithBookId:self.book.uid progress:@(self.progressSlider.value)];
        }
    } else {
        self.progressSlider.value = self.preProgressValue;
    }
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
