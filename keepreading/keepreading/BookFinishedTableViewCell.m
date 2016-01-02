//
//  BookFinishedTableViewCell.m
//  keepreading
//
//  Created by FanFamily on 16/1/2.
//  Copyright © 2016年 glory. All rights reserved.
//

#import "BookFinishedTableViewCell.h"
#import "BookCore.h"

@implementation BookFinishedTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)recoverProgress:(id)sender {
    [[BookCore sharedInstance] saveProgressWithBookId:self.book.uid progress:@0];
    if ([self.delgate respondsToSelector:@selector(removeBookWithId:)]) {
        [self.delgate removeBookWithId:self.book.uid];
    }
}

- (IBAction)deleteBook:(id)sender {
    [[BookCore sharedInstance] deleteBookWithId:self.book.uid];
    if ([self.delgate respondsToSelector:@selector(removeBookWithId:)]) {
        [self.delgate removeBookWithId:self.book.uid];
    }
}
@end
