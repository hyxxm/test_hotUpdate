//
//  HJHotUpdateModel.h
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJHotUpdateModel : NSObject

@property (nonatomic,copy  ) NSString  *version;
@property (nonatomic,copy  ) NSString  *upgradeDescription;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,copy  ) NSString  *checksum;
@property (nonatomic,copy  ) NSString  *filepath;
@property (nonatomic,copy  ) NSNumber  *forceUpdate;

@end
