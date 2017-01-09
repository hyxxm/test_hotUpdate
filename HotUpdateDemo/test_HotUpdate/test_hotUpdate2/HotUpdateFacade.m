//
//  HotUpdateFacade.m
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HotUpdateFacade.h"
#import "HotUpdateBundleManager.h"
#import "HotUpdateCreatorInterface.h"
#import "HJDataInterface.h"
#import <objc/runtime.h>
//#import <ReactiveCocoa.h>
//#import "HJWebViewController.h"
#ifdef DEBUG
#define HotUpdate_HJLog(format,...) NSLog(format,##__VA_ARGS__)
#define HotUpdate_HJAssert(condition, desc, ...) NSAssert(condition,desc,##__VA_ARGS__)
#else
#define HotUpdate_HJLog(format,...)
#define HotUpdate_HJAssert(condition, desc, ...)
#endif
id HotUpdate_dynamicCreate(NSString* className){
    
    Class class = objc_getClass([className UTF8String]);
    if(class == nil) return nil;
    id instance = [class new];
    
    return instance;
}
static NSArray *s_clist;

/**
 *  加载脚本支持类别
 *
 *  @return 脚本创造者列表
 */
static NSArray<NSObject<HotUpdateCreatorInterface> *> *creatorList(){
    if(!s_clist){
        s_clist = @[HotUpdate_dynamicCreate(@"HotUpdateJSCreator")];
    }
    return s_clist;
}


@interface HotUpdateFacade(){
    HotUpdateBundleManager *_bundle;
}

@end

@implementation HotUpdateFacade

HotUpdate_SYNTHESIZE_SINGLETON_FOR_CLASS(HotUpdateFacade);

-(instancetype)init{
    if(self = [super init]){
        _bundle = [HotUpdateBundleManager new];
    }
    return self;
}

-(void) load{
    [self loadAllScript];
}

-(void)checkUpdate:(HotUpdateUpdating)updateInfo updated:(HotUpdateUpdated)updated error:(HotUpdateError)hu_error{
#ifdef LOCAL_HOTUPDATE_DEVLELOPMENT
    //! do nothing
    [self loadAllScript];
    updated(YES);
#else
//    @weakify(self)
    __block __typeof(&*self) weakSelf=self;
    [_bundle
     update:^bool(NSString *description, NSString *size)
     {
         return YES;
     }
     progress:updateInfo
     updated:^(bool isUpdated){
         //! 加载脚本
//         @strongify(self);
         [weakSelf loadAllScript];
         updated(isUpdated);
     }
     error:^(NSError *err) {
//         @strongify(self);
         hu_error(err);
         //!更新失败 加载老的js包
         [weakSelf loadAllScript];
     }];

#endif
}

-(void) loadAllScript{
    if([_bundle hasUpgradeFile]){
        for(NSObject<HotUpdateCreatorInterface> *creator in creatorList()){
            //! 先卸载再重新加载，jspatch没有对应的函数实现
            [creator uninstall];
            NSArray *filePaths = [_bundle filePathsWithSuffixes:creator.suffixes];
            [creator load:filePaths];
        }
    }
}


-(UIView *)createView:(NSString *)className parent:(id)parent{
    NSString *fileName = [_bundle nibNameByClassName:className];
    UINib *nib = nil;
    //!先尝试从nib加载
    if(fileName != nil && fileName.length > 0){
        nib = [UINib nibWithNibName:fileName bundle:hotupdateBundle()];
    }else{
        nib = [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
    }
    
    if(nib){
        NSArray *topItems = [[NSBundle mainBundle] loadNibNamed:className owner:parent options:nil];
        for(NSObject *obj in topItems){
            if([obj isKindOfClass:objc_getClass([className UTF8String])]){
                return (UIView *)obj;
            }
        }
        
        assert(0);
        
        id class = objc_getClass([className UTF8String]);
        if(class != nil) return [class new];
        else return nil;
    }else{
        //! nib中不存在则直接new
        id class = objc_getClass([className UTF8String]);
        if(class != nil) return [class new];
        else return nil;
    }
}

-(UIViewController *)createViewController:(NSString *)className{
    //从热更新中找nibName
    NSString *nibName = [_bundle nibNameByClassName:className];
    id class = objc_getClass([className UTF8String]);

    if(nibName != nil && nibName.length > 0){
        //!nib name 不为空，则从热更新的bundle中由xib加载viewcontroller
        return [(UIViewController *)[class alloc] initWithNibName:nibName bundle:hotupdateBundle()];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        //! path 为空，则说明viewcontroller没有更新，或者xib没有更新。如果mainbundle中有nib，则从mainbundle中加载
        if(path != nil && path.length != 0){
            UIViewController* vc = [(UIViewController *)[class alloc] initWithNibName:className bundle:[NSBundle mainBundle]];
            HotUpdate_HJLog(@"%@",vc.nibName);
            return vc;
        }else{
            //! nib 为空，则直接new出来
            return [class new];
        }
    }
}

-(UIViewController *)createViewControllerByAlias:(NSString *)alias error:(HotUpdateError) error{
    NSString *className = [_bundle classNameByAlias:alias];
    //!通过别名获取类名
    if(className != nil && className.length > 0){
        //!先查询是否有nib
        id class = objc_getClass([className UTF8String]);
        UINib* nib = [UINib nibWithNibName:className bundle:hotupdateBundle()];
        if(nib){
            //! 有nib则重热更新的bundle中创建
            return [(UIViewController *)[class alloc] initWithNibName:className bundle:hotupdateBundle()];
        }else{
            //! 没有nib则直接new
            return [class new];
        }
    }else{
        //! 如果更新包中没有此别名，则返回一个webviewcontroller,并且加载默认url
//        HJWebViewController *webvc = [HJWebViewController new];
//        [webvc loadUrl:strUrl];
//        return webvc;
        if(error) error([NSError errorWithDomain:@"未找到对应的class" code:HU_ERROR_CREATE userInfo:@{@"alias":alias}]);
        return nil;
    }
}

-(void)end{
    [_bundle end];
}

-(NSBundle *)upgradeBundle{
    return hotupdateBundle();
}

-(NSString *) filePath:(NSString *)fileName Extension:(NSString *)ex{
    NSString *path = [[self upgradeBundle] pathForResource:fileName ofType:ex];
    if(path != nil && path.length != 0 )
        return path;
    else
        return [[NSBundle mainBundle] pathForResource:fileName ofType:ex];
}




@end
