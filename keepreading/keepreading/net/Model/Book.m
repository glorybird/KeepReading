//
//  Book.m
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import "Book.h"

@implementation Book

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            _uid = [dict objectForKey:@"id"];
            _title = [dict objectForKey:@"title"];
            _imageUrl = [[dict objectForKey:@"images"] objectForKey:@"medium"];
            _pages = @([[dict objectForKey:@"pages"] integerValue]);
            _authors = [dict objectForKey:@"author"];
            _pubdate = [dict objectForKey:@"pubdate"];
            _publisher = [dict objectForKey:@"publisher"];
            _summary = [dict objectForKey:@"summary"];
            _price = [dict objectForKey:@"price"];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uid forKey:@"_uid"];
    [aCoder encodeObject:_title forKey:@"_title"];
    [aCoder encodeObject:_imageUrl forKey:@"_imageUrl"];
    [aCoder encodeObject:_pages forKey:@"_pages"];
    [aCoder encodeObject:_authors forKey:@"_authors"];
    [aCoder encodeObject:_pubdate forKey:@"_pubdate"];
    [aCoder encodeObject:_publisher forKey:@"_publisher"];
    [aCoder encodeObject:_summary forKey:@"_summary"];
    [aCoder encodeObject:_price forKey:@"_price"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        _uid =  [aDecoder decodeObjectForKey:@"_uid"];
        _title = [aDecoder decodeObjectForKey:@"_title"];
        _imageUrl = [aDecoder decodeObjectForKey:@"_imageUrl"];
        _pages = [aDecoder decodeObjectForKey:@"_pages"];
        _authors = [aDecoder decodeObjectForKey:@"_authors"];
        _pubdate = [aDecoder decodeObjectForKey:@"_pubdate"];
        _publisher = [aDecoder decodeObjectForKey:@"_publisher"];
        _summary = [aDecoder decodeObjectForKey:@"_summary"];
        _price = [aDecoder decodeObjectForKey:@"_price"];
    }
    return self;
}

@end
