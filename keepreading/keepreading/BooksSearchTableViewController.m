//
//  BooksSearchTableViewController.m
//  keepreading
//
//  Created by FanFamily on 16/1/1.
//  Copyright © 2016年 glory. All rights reserved.
//

#import "BooksSearchTableViewController.h"
#import "BookTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "RVTask.h"
#import "BookCore.h"

@interface BooksSearchTableViewController () <UISearchBarDelegate>

@property (nonatomic) NSArray* books;

@end

@implementation BooksSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar setDelegate:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [RVTask mountaintop].thenFinishSetYourself(^(RVTask *preTask, void (^finishBlock)(id result)) {
        [[BookCore sharedInstance] searchBooksWithName:searchBar.text completeHandler:^(NSArray *books, NSError *error) {
            finishBlock(books);
        }];
    }).then(^id(RVTask *preTask) {
        self.books = preTask.result;
        return nil;
    }).then(^id(RVTask *preTask) {
        [self.tableView reloadData];
        return nil;
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BookTableViewCellIdentifier";
    Book* book = [self.books objectAtIndex:indexPath.row];
    BookTableViewCell* cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.book = book;
    cell.presentVC = self.presentVC;
    [cell.surface sd_setImageWithURL:[NSURL URLWithString:book.imageUrl]];;
    cell.title.text = book.title;
    cell.average.text = [NSString stringWithFormat:@"评分:%@", book.average];
    cell.author.text = [NSString stringWithFormat:@"作者:%@", book.authors.firstObject];
    cell.pages.text = [NSString stringWithFormat:@"页数:%@", book.pages];
    return cell;
}

@end
