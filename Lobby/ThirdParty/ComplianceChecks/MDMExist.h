//
//  MDMExist.h
//  MDMExist
//
//  Created by trustmobi on 15/3/10.
//  Copyright (c) 2015年 trustmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    CodeMDMExistError_noError = 0,              //成功，管控中
    CodeMDMExistError_CACertImportError = 1,    //失败，导入ca证书不存在
    CodeMDMExistError_CACertFormatError = 2,        //失败，导入的ca证书格式不为der格式
    CodeMDMExistError_CACertMatchError = 3         //设备脱离管控
}CodeMDMExistError;

@interface MDMExist : NSObject
@property(nonatomic, retain)NSString *lockUdidStr;

/**
 * @function: 检测手机是否出处于管控状态
 * @param name: 导入证书的名称
 * @param ext: 导入证书的后缀名
 * @return 0:表示管控中
 */
+ (int)checkPhoneStatusWithpathForResource:(NSString *)name ofType:(NSString *)ext;

//初始化
+(MDMExist *)shareManager;

//返回udid
-(NSString *)returnUDIDString;

@end
