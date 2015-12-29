//
//  BookTableViewCell.m
//  keepreading
//
//  Created by FanFamily on 15/12/28.
//  Copyright © 2015年 glory. All rights reserved.
//

#import "BookTableViewCell.h"
#import <JTSImageViewController.h>

@implementation BookTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.surface.userInteractionEnabled = YES;
    UITapGestureRecognizer *surfacePress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(surfacePress:)];
    [self.surface addGestureRecognizer:surfacePress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)surfacePress:(id)sender
{
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:self.book.imageUrlLarge];
    imageInfo.referenceRect = self.surface.frame;
    imageInfo.referenceView = self.surface.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self.presentVC transition:JTSImageViewControllerTransition_FromOriginalPosition];

}

@end
