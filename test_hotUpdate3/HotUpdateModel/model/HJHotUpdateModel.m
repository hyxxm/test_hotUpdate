//
//  HJHJHotUpdateModel.mModelView
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJHotUpdateModel.h"
#import "MJExtension.h"
#import "JSPatch/JPEngine.h"
@interface HJHotUpdateModel ()

@end

@implementation HJHotUpdateModel

-(instancetype)init {
    if(self = [super init]){
        
    }
    return self;
    // Do any additional setup after loading the view.
}

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"version":@"hotVersion"};
}

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSMutableArray *)mj_totalIgnoredPropertyNames{
    return [[NSMutableArray alloc] initWithArray:@[]];
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+(NSDictionary *)mj_objectClassInArray{
    return @{};
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
