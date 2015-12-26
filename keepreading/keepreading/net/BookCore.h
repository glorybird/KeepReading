//
//  NetCore.h
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookCore : NSObject

+ (instancetype)sharedInstance;

/*!
 *  @brief 搜索图书
 *
 *  @param name 图书关键字
 */
- (void)searchBooksWithName:(NSString *)name completeHandler:(void(^)(NSArray* books, NSError* error))handler;

/*!
 *  @brief 将书保存到本地，代表正在阅读的书
 *
 *  @param book
 */
- (void)saveBook:(Book*)book;

/*!
 *  @brief 删除图书
 *
 */
- (void)deleteBookWithId:(NSString *)bookId;

/*!
 *  @brief 本地图书列表
 */
- (NSArray *)listBooks;

/*!
 *  @brief 保存读书进度
 *
 *  @param bookId  书的ID
 *
 */
- (void)saveProgressWithBookId:(NSString *)bookId progress:(NSNumber *)progress;

/*!
 *  @brief 提取读书进度
 */
- (NSNumber*)progessWithBookId:(NSString *)bookId;

@end
