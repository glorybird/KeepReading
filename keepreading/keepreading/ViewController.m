//
//  ViewController.m
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import "ViewController.h"
#import "BookCore.h"
#import "RVTask.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RVTask mountaintop].thenFinishSetYourself(^(RVTask *preTask, void (^finishBlock)(id result)) {
        [[BookCore sharedInstance] searchBooksWithName:@"面包会有的" completeHandler:^(NSArray *books, NSError *error) {
            finishBlock(books.firstObject);
        }];
    }).then(^id(RVTask *preTask) {
        Book* book = (Book *)preTask.result;
        [[BookCore sharedInstance] saveBook:book];
        return book.uid;
    }).then(^id(RVTask *preTask) {
        NSLog(@"%@", [[BookCore sharedInstance] listBooks]);
        return nil;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
