//
//  HotUpdateDefine.h
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  是否更新的回调
 *
 *  @param description 更新内容
 *  @param size        更新包大小
 *
 *  @return 是，则下载更新。否，则放弃更新
 */
typedef bool (^HotUpdateNeedUpdate)(NSString *description, NSString *size);

/**
 *  更新中的回调
 *
 *  @param progress 更新的进度
 */
typedef void (^HotUpdateUpdating)(NSProgress *progress);

/**
 *  更新完成的通知
 *
 *  @param hasUpdated 是否更新了本地版本。返回yes，则代表更新包有更新。返回no，则代表当前的更新包已经是最新
 */
typedef void (^HotUpdateUpdated)(bool hasUpdated);

/**
 *  更新出错的回调
 *
 *  @param error 错误原因
 */
typedef void (^HotUpdateError)(NSError *error);