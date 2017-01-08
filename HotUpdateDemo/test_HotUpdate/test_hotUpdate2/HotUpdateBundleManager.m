//
//  HotUpdateBundleManager.m
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HotUpdateBundleManager.h"
#import "HotUpdate_NSTimer+block.h"
#import "HJHotUpdateHandler.h"
#import "HJDataInterface.h"
//#import "HJCrypt.h"
#import "HotUpdate_NSProgress+HJCustom.h"
#import "ZipArchive/ZipArchive.h"
//#import "HJCommon.h"
//#import <ReactiveCocoa.h>
#import <CommonCrypto/CommonDigest.h>
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import <objc/runtime.h>

#define _HU_ALIAS_KEY_   @"aliasmap"
#define _HU_UPGRADE_KEY_ @"upgrademap"
#define _HU_VERSION_KEY_ @"version"

#define _HU_HOTBUNDLE_PREFIX_NAME_ @"resource"

#define _HU_CHECKUPDATE_START_                           0
#define _HU_CHECKUPDATE_END_                             0.1
#define _HU_CHECKUPDATE_PROGRESS_                        (_HU_CHECKUPDATE_END_ - _HU_CHECKUPDATE_START_)

#define _HU_DOWNLOAD_START                               _HU_CHECKUPDATE_END_
#define _HU_DOWNLOAD_END                                 0.8
#define _HU_DOWNLOAD_PROGRESS                            (_HU_DOWNLOAD_END - _HU_DOWNLOAD_START)

#define _HU_CHECKFILE_START                              _HU_DOWNLOAD_END
#define _HU_CHECKFILE_END                                0.9
#define _HU_CHECKFILE_PROGRESS                           (_HU_CHECKFILE_END - _HU_CHECKFILE_START)

#define _HU_ZIPUPGRADE_START                             _HU_CHECKFILE_END
#define _HU_ZIPUPGRADE_END                               1.0
#define _HU_ZIPUPGRADE_PROGRESS                          (_HU_ZIPUPGRADE_END - _HU_ZIPUPGRADE_START)

inline static NSString *documentPath(){
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
NSString* hotUpdate_appVersion(){
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
typedef void (^hotUpdate_encrypted)(NSString *filePath);
NSString* hotUpdate_fileMD5(NSString *filePath){
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}
void hotUpdate_decryptFile(NSString *inputFilePath ,NSString *outputFilePath , hotUpdate_encrypted decryptedFunc){
    int blockSize = 32 * 1024;
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:inputFilePath];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:outputFilePath append:NO];
    
    [inputStream open];
    [outputStream open];
    
    // We don't need to keep making new NSData objects. We can just use one repeatedly.
    __block NSMutableData *data = [NSMutableData dataWithLength:blockSize];
    __block RNDecryptor *decryptor = nil;
    
    dispatch_block_t readStreamBlock = ^{
        [data setLength:blockSize];
        NSInteger bytesRead = [inputStream read:[data mutableBytes] maxLength:blockSize];
        if (bytesRead < 0) {
            // Throw an error
        }
        else if (bytesRead == 0) {
            [decryptor finish];
        }
        else {
            [data setLength:bytesRead];
            [decryptor addData:data];
            NSLog(@"Sent %ld bytes to decryptor", (unsigned long)bytesRead);
        }
    };
    
    decryptor = [[RNDecryptor alloc] initWithPassword:@"nishiyizhigou"
                                              handler:^(RNCryptor *cryptor, NSData *data) {
                                                  NSLog(@"Decryptor recevied %ld bytes", (unsigned long)data.length);
                                                  [outputStream write:data.bytes maxLength:data.length];
                                                  if (cryptor.isFinished) {
                                                      [outputStream close];
                                                      if(decryptedFunc) decryptedFunc(outputFilePath);
                                                      // call my delegate that I'm finished with decrypting
                                                  }
                                                  else {
                                                      // Might want to put this in a dispatch_async(), but I don't think you need it.
                                                      readStreamBlock();
                                                  }
                                              }];
    
    // Read the first block to kick things off
    readStreamBlock();

}


inline static NSString *bundleName(){
    static NSMutableString *bundleName = nil;
    if(bundleName) return bundleName;
    NSString *version = hotUpdate_appVersion();
    bundleName = [NSMutableString stringWithString:_HU_HOTBUNDLE_PREFIX_NAME_];
    NSArray *ary = [version componentsSeparatedByString:@"."];
    for(NSString *num in ary){
        [bundleName appendFormat:@"_%@",num];
    }
    return bundleName;
}

NSString *bundlePath(){
    static NSString *bundlePath = nil;
    if(bundlePath == nil){
        NSString *docPath = documentPath();
        bundlePath = [NSString stringWithFormat:@"%@/%@.bundle",docPath,bundleName()];
    }
    return bundlePath;
}

inline static NSURL *downloadTmpFilePath(){
    static NSURL *tmpFilePath = nil;
    if(tmpFilePath == nil){
        NSURL *docPath = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        tmpFilePath = [docPath URLByAppendingPathComponent:@"tmpfile"];
    }
    
    return tmpFilePath;
}

NSBundle *hotupdateBundle(){
    NSBundle *upgradeBundle = [NSBundle bundleWithPath:bundlePath()];
    return upgradeBundle;
}

@interface HotUpdateBundleManager()
{
    NSDictionary        *_dicAlias;
    NSDictionary        *_dicUpgrade;
    NSTimer             *_updateTimer;
    HJHotUpdateHandler  *_handler;
    HJHotUpdateModel    *_model;
    NSString            *_version;
}

@property (nonatomic,copy) HotUpdateNeedUpdate needUpdateFunc;
@property (nonatomic,copy) HotUpdateUpdating   updatingFunc;
@property (nonatomic,copy) HotUpdateUpdated    updatedFunc;
@property (nonatomic,copy) HotUpdateError      updateError;

@end




@implementation HotUpdateBundleManager



-(instancetype)init{
    if(self = [super init]){
        //! 热更新开发阶段，将resource.bundle从程序目录移动至程序的document目录
#ifdef LOCAL_HOTUPDATE_DEVLELOPMENT
        [self moveLocalBundleToDocumentPath];
#endif
        //! 读取本地数据包
        NSBundle *upgradeBundle = hotupdateBundle();
        if(upgradeBundle){
            NSString *path    = [upgradeBundle pathForResource:@"upgrade" ofType:@"plist"];
            assert(path != nil);
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
            _dicAlias         = dic[_HU_ALIAS_KEY_];
            _dicUpgrade       = dic[_HU_UPGRADE_KEY_];
            _version          = dic[_HU_VERSION_KEY_];
        }
        
        _handler = [HJHotUpdateHandler new];
    }
    return self;
}

-(void) moveLocalBundleToDocumentPath{
    
    NSString *myBundlePath = [[NSBundle mainBundle] pathForResource:bundleName() ofType:@"bundle" inDirectory:@"PlugIns"];
    NSLog(@"update plugin bunlde path: %@",myBundlePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *moveFrom = myBundlePath;
    NSString *moveto = [NSString stringWithFormat:@"%@/%@.bundle",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],bundleName()];
    
    NSError *err = nil;
    [fileManager removeItemAtPath:moveto error:nil];
    bool bSucc = [fileManager moveItemAtPath:moveFrom toPath:moveto error:&err];
    NSLog(@" move update plugin bundle result:%d,%@",bSucc,err);
}

-(HJHotUpdateHandler *) handler{
    return _handler;
}

-(NSString *)classNameByAlias:(NSString *)aliasName{
    return _dicAlias == nil?nil:_dicAlias[aliasName];
}

-(NSString *)nibNameByClassName:(NSString *)className{
    return _dicUpgrade == nil? nil:_dicUpgrade[className];
}







-(NSArray<NSString *> *)filePathsWithSuffixes:(NSString *)suffixes{
    NSBundle *bundle = hotupdateBundle();
    if(bundle){
        return [bundle pathsForResourcesOfType:suffixes inDirectory:nil];
    }else{
        return nil;
    }
}

-(void)update:(HotUpdateNeedUpdate)toUpdate progress:(HotUpdateUpdating)updateInfo updated:(HotUpdateUpdated)updated error:(HotUpdateError)error{
//    [self end];
    assert(toUpdate != nil && updateInfo != nil && updated != nil);
    self.needUpdateFunc = toUpdate;
    self.updatingFunc = updateInfo;
    self.updatedFunc = updated;
    self.updateError = error;
//    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1000000 target:self selector:@selector(updateLoop) userInfo:nil repeats:YES];
//    [_updateTimer fire];
    
    
    [self update];
}

- (void) update{
//    @weakify(self);
    __block __typeof(self) weakSelf=self;
    NSProgress *progress = [NSProgress hotUpdate_create:1 completed:0 customFraction:0 description:@"正在检查更新"];
    self.updatingFunc(progress);
    [[self handler] get:^(id data, RequestResult *result) {
//        @strongify(self);
        _model = (HJHotUpdateModel *)data;
        //!校验本地版本号和网络最新版本的区别

        if([_model.version isEqualToString:_version]){
            
            NSProgress *progress = [NSProgress hotUpdate_create:1 completed:1 customFraction:1 description:@"检测完成"];
            weakSelf.updatingFunc(progress);
//            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.updatedFunc(NO);
//            });
            return;
        }
        
        //! 开始更新
        if(self.needUpdateFunc(_model.description , [NSString stringWithFormat:@"%ld",(long)_model.size])){
            [weakSelf downloadfile];
        }
        
        
    } error:^(RequestResult *result) {
        //! do nothing
        self.updateError([result transResult2Error]);
    }];
}

-(void) downloadfile
{
    NSProgress *progress = [NSProgress hotUpdate_create:1 completed:1 customFraction:_HU_CHECKUPDATE_END_ description:@"下载更新包"];
    self.updatingFunc(progress);
    
    RequestParam* param = [RequestParam new];
    param.url = _model.filepath;
    param.type = CACHE_NONE;
    
//    @weakify(self)
    __block __typeof(self) weakSelf=self;
    DownloadFile(param,
                 downloadTmpFilePath(),
                 ^(NSProgress *progress){
//                     @strongify(self);
                     progress.customFractionCompleted = progress.fractionCompleted * _HU_DOWNLOAD_PROGRESS + _HU_DOWNLOAD_START;
                     progress.localizedDescription = [NSString stringWithFormat:@"下载中 %.0f％",(progress.customFractionCompleted + _HU_DOWNLOAD_START)*100];
                     weakSelf.updatingFunc(progress);
                 },^(NSURL *filepath){
//                     @strongify(self);
                     [weakSelf handleUpgradeFile:filepath];
                 },^(RequestResult* result){
                     weakSelf.updateError([result transResult2Error]);
                 });
}

-(void) handleUpgradeFile:(NSURL *)filePath{
    NSString* strFilePath = [filePath resourceSpecifier];
    assert([filePath isEqual:downloadTmpFilePath()]);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:strFilePath]){
        //!校验文件
        unsigned long long size = [[fileManager attributesOfItemAtPath:strFilePath error:nil] fileSize];
        NSLog(@"check upgradefile size %@",size == _model.size?@"successed":@"failed");
        if(size == _model.size){
            NSString* strFileMD5 = hotUpdate_fileMD5(strFilePath);
            NSLog(@"cehck checksum %@",[_model.checksum isEqualToString:strFileMD5]?@"successed":@"failed");
            if([_model.checksum isEqualToString:strFileMD5]){
                //!aes解码文件
                NSString *decrptyFilePath = [NSString stringWithFormat:@"%@/decryptfile",documentPath()];
//                @weakify(self);
                __block __typeof(self) weakSelf=self;
                NSProgress *progress = [NSProgress hotUpdate_create:1 completed:0 customFraction:_HU_DOWNLOAD_END description:@"解码中"];
                self.updatingFunc(progress);
                hotUpdate_decryptFile(strFilePath, decrptyFilePath, ^(NSString *filePath) {
                    
                    NSProgress *progress = [NSProgress hotUpdate_create:1 completed:0 customFraction:_HU_CHECKFILE_END description:@"解压中"];
                    weakSelf.updatingFunc(progress);
                    
//                    @strongify(self);
                    //!解压文件
                    ZipArchive *zipFile = [ZipArchive new];
                    [zipFile UnzipOpenFile:filePath];
                    [zipFile UnzipFileTo:bundlePath() overWrite:YES];
                    [zipFile UnzipCloseFile];
                    
                    //!删除下载包
                    bool bRemove = [fileManager removeItemAtPath:[downloadTmpFilePath() resourceSpecifier] error:nil];
                    NSLog(@"remove download file %@",bRemove?@"successed":@"failed");
                    //!删除加密包
                    bRemove = [fileManager removeItemAtPath:decrptyFilePath error:nil];
                    NSLog(@"remove decrypt file %@",bRemove?@"successed":@"failed");
                    
                    progress = [NSProgress hotUpdate_create:1 completed:1 customFraction:_HU_ZIPUPGRADE_END description:@"完成"];
                    weakSelf.updatingFunc(progress);
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.updatedFunc(YES);
//                    });
                });
                
                
            }else{
                NSError *error = [NSError errorWithDomain:@"下载到的内容与服务器不一致" code:-1001 userInfo:nil];
                self.updateError(error);
            }
        }else{
            NSError *error = [NSError errorWithDomain:@"下载到的大小和预期大小不一致" code:-1002 userInfo:nil];
            self.updateError(error);
        }
    }
}

-(void)end{
    if(_updateTimer){
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
}

-(bool) hasUpgradeFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:bundlePath()];
}

@end
