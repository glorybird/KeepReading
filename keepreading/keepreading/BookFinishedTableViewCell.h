//
//  BookFinishedTableViewCell.h
//  keepreading
//
//  Created by FanFamily on 16/1/2.
//  Copyright © 2016年 glory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@protocol BookFinishedTableViewCellDelegate <NSObject>

- (void)removeBookWithId:(NSString *)bookId;

@end

@interface BookFinishedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *surface;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (nonatomic) Book* book;
@property (nonatomic, weak) id<BookFinishedTableViewCellDelegate> delgate;

@end
