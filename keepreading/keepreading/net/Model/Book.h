//
//  Book.h
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Book : BaseModel<NSCoding>

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSNumber* pages;
@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* pubdate;
@property (nonatomic, copy) NSString* publisher;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, copy) NSString* price;

@end
