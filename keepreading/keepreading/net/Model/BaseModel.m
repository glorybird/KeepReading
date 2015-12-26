//
//  BaseModel.m
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import <objc/runtime.h>
#import "BaseModel.h"

@implementation BaseModel

-(NSString *)description
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[self valueForKey:key] forKey:key];
    }
    free(properties);
    return [[NSDictionary dictionaryWithDictionary:dict] description];
}

@end
