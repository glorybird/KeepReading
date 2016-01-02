//
//  NetCore.m
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import "BookCore.h"
#import "AFNetworking.h"
#import "DataParseHelper.h"
#import "YapDatabase.h"

@interface BookCore ()

@property (nonatomic) YapDatabase* database;

@end

@implementation BookCore

+ (instancetype)sharedInstance
{
    static BookCore* core;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [[self alloc]init];
    });
    return core;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        NSString *databasePath = [baseDir stringByAppendingPathComponent:@"kp.sqlite"];
        _database = [[YapDatabase alloc] initWithPath:databasePath];
    }
    return self;
}

- (void)searchBooksWithName:(NSString *)name completeHandler:(void(^)(NSArray* books, NSError* error))handler
{
    [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":name, @"count":@100} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (handler) {
            handler([DataParseHelper parseToBooksWithDictionary:responseObject], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}

- (void)saveBook:(Book*)book
{
    [[self.database newConnection] readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction setObject:book forKey:book.uid inCollection:@"books"];
    }];
}

- (void)deleteBookWithId:(NSString *)bookId
{
    [[self.database newConnection] readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction setObject:nil forKey:bookId inCollection:@"books"];
    }];
}

- (Book *)bookWithId:(NSString *)bookId
{
    __block Book* book = nil;
    [[self.database newConnection] readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        book = [transaction objectForKey:bookId inCollection:@"books"];
    }];
    return book;
}

- (NSArray *)listBooks
{
    NSMutableArray* books = [NSMutableArray array];
    [[self.database newConnection] readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
       [transaction enumerateKeysAndObjectsInAllCollectionsUsingBlock:^(NSString * _Nonnull collection, NSString * _Nonnull key, Book*  _Nonnull object, BOOL * _Nonnull stop) {
           if ([collection isEqualToString:@"books"] && [[transaction objectForKey:object.uid inCollection:@"progress"] integerValue] < object.pages.integerValue) {
               [books addObject:object];
           }
       }];
    }];
    return books;
}

- (NSArray *)listFinishReadBooks
{
    NSMutableArray* books = [NSMutableArray array];
    [[self.database newConnection] readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        [transaction enumerateKeysAndObjectsInAllCollectionsUsingBlock:^(NSString * _Nonnull collection, NSString * _Nonnull key, Book*  _Nonnull object, BOOL * _Nonnull stop) {
            if ([collection isEqualToString:@"books"] && [[transaction objectForKey:object.uid inCollection:@"progress"] integerValue] >= object.pages.integerValue) {
                [books addObject:object];
            }
        }];
    }];
    return books;
}

- (void)saveProgressWithBookId:(NSString *)bookId progress:(NSNumber *)progress
{
    [[self.database newConnection] readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction setObject:progress forKey:bookId inCollection:@"progress"];
    }];
}

- (NSNumber*)progessWithBookId:(NSString *)bookId
{
    __block NSNumber* progress = nil;
    [[self.database newConnection] readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        progress = [transaction objectForKey:bookId inCollection:@"progress"];
    }];
    return progress;
}

@end
