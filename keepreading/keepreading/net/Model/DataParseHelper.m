//
//  DataParseHelper.m
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import "DataParseHelper.h"
#import "Book.h"

@implementation DataParseHelper

+ (NSArray *)parseToBooksWithDictionary:(NSDictionary *)dictionary
{
    NSMutableArray* result = [NSMutableArray array];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    
    if ([[dictionary objectForKey:@"books"] isKindOfClass:[NSArray class]]) {
        NSArray* books = [dictionary objectForKey:@"books"];
        [books enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                Book* book = [[Book alloc] initWithDictionary:obj];
                [result addObject:book];
            }
        }];
    }
    return result;
}

@end
